require 'openssl'
require 'nokogiri'

module Spreedly
  class SignatureValidator
    def initialize(secret, raw_xml_response)
      @secret = secret
      @raw_xml_response = raw_xml_response
    end

    def valid?
      signature = document.xpath("//transaction/signed/signature").text
      signature == signature_for(@secret, @raw_xml_response)
    end

    private

    def signature_for(secret, xml)
      document = Nokogiri::XML(xml)
      algorithm = document.xpath("//transaction/signed/algorithm").text

      fields = document.xpath("//transaction/signed/fields").text.split(" ")

      values = fields.collect do |field|
        document.xpath("//transaction/#{field}").text
      end

      signature_data = values.join("|")
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new(algorithm),
        secret,
        signature_data
      )
    end
  end
end