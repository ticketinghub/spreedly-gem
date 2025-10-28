require 'test_helper'
require 'unit/response_stubs/purchase_stubs'
require 'unit/payment_token_stubs/google_payment_token_stubs'
require 'unit/payment_token_stubs/apple_payment_token_stubs'

class PurchaseTest < Test::Unit::TestCase

  include PurchaseStubs
  include GooglePaymentTokenStubs
  include ApplePaymentTokenStubs

  def setup
    @environment = Spreedly::Environment.new("key", "secret")
  end

  def test_successful_purchase
    t = purchase_using(successful_purchase_response)

    assert_kind_of(Spreedly::Purchase, t)
    assert_equal 'Btcyks35m4JLSNOs9ymJoNQLjeX', t.token
    assert_equal 144, t.amount
    assert t.on_test_gateway?
    assert_equal Time.parse("2013-07-31 19:46:26 UTC"), t.created_at
    assert_equal Time.parse("2013-07-31 19:46:32 UTC"), t.updated_at
    assert_equal 'USD', t.currency_code
    assert t.succeeded?
    assert_equal 'succeeded', t.state
    assert_equal '187A', t.order_id
    assert_equal '', t.ip
    assert_equal '4 Shardblades', t.description
    assert_equal '', t.merchant_name_descriptor
    assert_equal '', t.merchant_location_descriptor
    assert_equal 'YOaCn5a9xRaBTGgmGAWbkgWUuqv', t.gateway_token
    assert_equal '8xXXIPGXTaPXysDA5OUpgnjTEjK', t.payment_method.token
    assert_equal "44", t.gateway_transaction_id
    assert_equal "Purchase", t.transaction_type
    assert_equal "three-ds-context", t.three_ds_context

    assert t.response.success
    assert_equal 'Successful purchase', t.response.message
    assert_equal '22', t.response.avs_code
    assert_equal 'I will be back', t.response.avs_message
    assert_equal '31', t.response.cvv_code
    assert_equal 'Rutabaga', t.response.cvv_message
    assert !t.response.pending
    assert !t.response.fraud_review
    assert_equal '899', t.response.error_code
    assert_equal 'The eagle lives!', t.response.error_detail
    assert !t.response.cancelled
    assert_equal Time.parse('2013-07-31T19:46:26Z'), t.response.created_at
    assert_equal Time.parse('2013-07-31T19:46:27Z'), t.response.updated_at

    assert_equal '', t.shipping_address.name
    assert_equal '', t.shipping_address.address1
    assert_equal '', t.shipping_address.address2
    assert_equal '', t.shipping_address.city
    assert_equal '', t.shipping_address.state
    assert_equal '', t.shipping_address.zip
    assert_equal '', t.shipping_address.country
    assert_equal '', t.shipping_address.phone_number
  end

  def test_successful_3dsecure_purchase_attempt
    t = purchase_using(successful_purchase_3dsecure_attempt_response)

    assert_kind_of(Spreedly::Purchase, t)
    assert_equal 'Btcyks35m4JLSNOs9ymJoNQLjeX', t.token
    assert_equal 144, t.amount
    assert t.on_test_gateway?
    assert_equal Time.parse("2013-07-31 19:46:26 UTC"), t.created_at
    assert_equal Time.parse("2013-07-31 19:46:32 UTC"), t.updated_at
    assert_equal 'USD', t.currency_code
    assert !t.succeeded?
    assert_equal 'pending', t.state
    assert_equal 'none', t.required_action
    assert_equal 'http://challenge_url.test', t.challenge_url
    assert_equal 'challenge form data', t.challenge_form
    assert_equal 'device fingerprint form data', t.device_fingerprint_form
    assert_equal '', t.order_id
    assert_equal '', t.ip
    assert_equal '4 Shardblades', t.description
    assert_equal '', t.merchant_name_descriptor
    assert_equal '', t.merchant_location_descriptor
    assert_equal 'YOaCn5a9xRaBTGgmGAWbkgWUuqv', t.gateway_token
    assert_equal '8xXXIPGXTaPXysDA5OUpgnjTEjK', t.payment_method.token
    assert_equal "44", t.gateway_transaction_id

    assert t.response.success
    assert_equal 'Checked enrollment status', t.response.message
    assert !t.response.pending
    assert !t.response.fraud_review
    assert_equal '', t.response.error_code
    assert_equal Time.parse('2013-07-31T19:46:26Z'), t.response.created_at
    assert_equal Time.parse('2013-07-31T19:46:27Z'), t.response.updated_at

    assert_equal 'https://example.com/callback_url', t.callback_url
    assert_equal 'https://example.com/redirect_url', t.redirect_url
    assert_equal '', t.checkout_url

    assert t.checkout_form.include?('<form action="https://core.spreedly.com/test/1234/auth/1234" method="POST">')
    assert t.checkout_form.include?('<input name="PaReq" value="" type="hidden"/>')
    assert t.checkout_form.include?('<input name="MD" value="" type="hidden"/>')
    assert t.checkout_form.include?('<input name="TermUrl" value="https://core.spreedly.com/transaction/Btcyks35m4JLSNOs9ymJoNQLjeX/redirect" type="hidden"/>')
    assert t.checkout_form.include?('<input name="Complete" value="Authorize Transaction" type="submit"/>')

    assert_equal '', t.shipping_address.name
    assert_equal '', t.shipping_address.address1
    assert_equal '', t.shipping_address.address2
    assert_equal '', t.shipping_address.city
    assert_equal '', t.shipping_address.state
    assert_equal '', t.shipping_address.zip
    assert_equal '', t.shipping_address.country
    assert_equal '', t.shipping_address.phone_number
  end

  def test_failed_purchase
    t = purchase_using(failed_purchase_response)

    assert_kind_of(Spreedly::Purchase, t)
    assert_equal 'RxkxK78ZlvDiXRQRnyuJM5ee0Ww', t.token
    assert_equal 5148, t.amount
    assert !t.succeeded?
    assert_equal 'gateway_processing_failed', t.state

    assert_equal 'The eagle is dead Jim.', t.response.error_detail
  end

  def test_successful_purchase_with_shipping_address_override
    t = purchase_using(successful_purchase_with_shipping_address_override_response)

    assert_equal 'John Doe', t.shipping_address.name
    assert_equal '123 Main St.', t.shipping_address.address1
    assert_equal 'Unit 1', t.shipping_address.address2
    assert_equal 'Acme', t.shipping_address.city
    assert_equal 'Corp', t.shipping_address.state
    assert_equal '45678', t.shipping_address.zip
    assert_equal 'USA', t.shipping_address.country
    assert_equal '123-456-7890', t.shipping_address.phone_number
  end

  def test_successful_purchase_with_billing_address_override
    t = purchase_using(successful_purchase_with_billing_address_override_response)

    assert_equal 'Jane Smith', t.billing_address.name
    assert_equal '456 Elm St.', t.billing_address.address1
    assert_equal 'Apt 2B', t.billing_address.address2
    assert_equal 'Springfield', t.billing_address.city
    assert_equal 'IL', t.billing_address.state
    assert_equal '62701', t.billing_address.zip
    assert_equal 'USA', t.billing_address.country
    assert_equal '555-123-4567', t.billing_address.phone_number
  end

  def test_request_body_params
    body = get_request_body(successful_purchase_response) do
      @environment.purchase_on_gateway("TheGatewayToken", "TheCardToken", 2001, all_possible_options)
    end

    transaction = body.xpath('./transaction')
    assert_xpaths_in transaction,
      [ './amount', '2001' ],
      [ './currency_code', 'EUR' ],
      [ './payment_method_token', 'TheCardToken' ],
      [ './order_id', '8675' ],
      [ './description', 'SuperDuper' ],
      [ './ip', '183.128.100.103' ],
      [ './merchant_name_descriptor', 'Real Stuff' ],
      [ './merchant_location_descriptor', 'Raleigh' ],
      [ './retain_on_success', 'true' ],
      [ './continue_caching', 'true']
  end

  def test_request_body_params_for_google_pay
    body = get_request_body(successful_purchase_response) do
      @environment.purchase_on_gateway("TheGatewayToken", google_pay_token, 2001, all_possible_options.merge(payment_method: :google_pay))
    end

    transaction = body.xpath('./transaction')
    assert_xpaths_in transaction,
      [ './amount', '2001' ],
      [ './currency_code', 'EUR' ],
      [ './payment_method_token', '' ],
      [ './order_id', '8675' ],
      [ './description', 'SuperDuper' ],
      [ './ip', '183.128.100.103' ],
      [ './merchant_name_descriptor', 'Real Stuff' ],
      [ './merchant_location_descriptor', 'Raleigh' ],
      [ './retain_on_success', 'true' ],
      [ './continue_caching', 'true']

    assert body.to_s.include?(google_pay_token)
  end

  def test_request_body_params_for_apple_pay
    body = get_request_body(successful_purchase_response) do
      @environment.purchase_on_gateway("TheGatewayToken", apple_pay_token, 2001, all_possible_options.merge(payment_method: :apple_pay))
    end

    transaction = body.xpath('./transaction')
    assert_xpaths_in transaction,
      [ './amount', '2001' ],
      [ './currency_code', 'EUR' ],
      [ './payment_method_token', '' ],
      [ './order_id', '8675' ],
      [ './description', 'SuperDuper' ],
      [ './ip', '183.128.100.103' ],
      [ './merchant_name_descriptor', 'Real Stuff' ],
      [ './merchant_location_descriptor', 'Raleigh' ],
      [ './retain_on_success', 'true' ],
      [ './continue_caching', 'true']

    assert body.to_s.include?(apple_pay_token)
  end

  def test_request_body_params_with_billing_address
    billing_address = {
      name: "Jane Smith",
      address1: "456 Elm St.",
      address2: "Apt 2B",
      city: "Springfield",
      state: "IL",
      zip: "62701",
      country: "USA",
      phone_number: "555-123-4567"
    }

    body = get_request_body(successful_purchase_response) do
      @environment.purchase_on_gateway("TheGatewayToken", "TheCardToken", 2001, {billing_address: billing_address})
    end

    transaction = body.xpath('./transaction')
    assert_xpaths_in transaction,
      [ './billing_address/name', 'Jane Smith' ],
      [ './billing_address/address1', '456 Elm St.' ],
      [ './billing_address/address2', 'Apt 2B' ],
      [ './billing_address/city', 'Springfield' ],
      [ './billing_address/state', 'IL' ],
      [ './billing_address/zip', '62701' ],
      [ './billing_address/country', 'USA' ],
      [ './billing_address/phone_number', '555-123-4567' ]
  end

  def test_successful_google_pay_purchase_with_billing_address
    billing_address = {
      name: "Google Pay User",
      address1: "789 Google St",
      city: "Mountain View",
      state: "CA",
      zip: "94043",
      country: "US"
    }

    request_body = nil
    @environment.stubs(:raw_ssl_request).with do |method, endpoint, body, headers|
      request_body = body
      true
    end.returns(successful_purchase_response)

    options = {
      payment_method: :google_pay,
      billing_address: billing_address,
      order_id: "GP-123",
      email: "user@example.com",
      currency_code: "EUR"
    }

    transaction = @environment.purchase_on_gateway("TheGatewayToken", google_pay_token, 7551, options)

    # Verify the transaction succeeded
    assert_kind_of(Spreedly::Purchase, transaction)
    assert transaction.succeeded?

    # Parse and verify the request body that was sent
    body = Nokogiri::XML(request_body)
    trans = body.xpath('./transaction')

    # Verify Google Pay data is in the request
    assert request_body.include?(google_pay_token), "Google Pay token should be in request body"
    assert trans.at_xpath('./google_pay/payment_data'), "Google Pay payment_data element should exist"

    # Verify billing address is in the request
    assert_xpaths_in trans,
      [ './billing_address/name', 'Google Pay User' ],
      [ './billing_address/address1', '789 Google St' ],
      [ './billing_address/city', 'Mountain View' ],
      [ './billing_address/state', 'CA' ],
      [ './billing_address/zip', '94043' ],
      [ './billing_address/country', 'US' ],
      [ './order_id', 'GP-123' ],
      [ './email', 'user@example.com' ],
      [ './currency_code', 'EUR' ]
  end

  def test_request_body_params_for_google_pay_with_billing_address
    billing_address = {
      name: "Google Pay User",
      address1: "789 Google St",
      city: "Mountain View",
      state: "CA",
      zip: "94043",
      country: "US"
    }

    body = get_request_body(successful_purchase_response) do
      @environment.purchase_on_gateway("TheGatewayToken", google_pay_token, 2001,
        payment_method: :google_pay,
        billing_address: billing_address,
        order_id: "GP-123",
        email: "user@example.com"
      )
    end

    transaction = body.xpath('./transaction')

    # Verify Google Pay data is present
    assert body.to_s.include?(google_pay_token), "Google Pay token should be in request body"
    assert transaction.at_xpath('./google_pay/payment_data'), "Google Pay payment_data element should exist"

    # Verify billing address is present
    assert_xpaths_in transaction,
      [ './billing_address/name', 'Google Pay User' ],
      [ './billing_address/address1', '789 Google St' ],
      [ './billing_address/city', 'Mountain View' ],
      [ './billing_address/state', 'CA' ],
      [ './billing_address/zip', '94043' ],
      [ './billing_address/country', 'US' ],
      [ './order_id', 'GP-123' ],
      [ './email', 'user@example.com' ]
  end

  def test_request_body_params_for_apple_pay_with_billing_address
    billing_address = {
      name: "Apple Pay User",
      address1: "1 Apple Park Way",
      city: "Cupertino",
      state: "CA",
      zip: "95014",
      country: "US"
    }

    body = get_request_body(successful_purchase_response) do
      @environment.purchase_on_gateway("TheGatewayToken", apple_pay_token, 2001,
        payment_method: :apple_pay,
        billing_address: billing_address,
        order_id: "AP-456",
        email: "apple@example.com"
      )
    end

    transaction = body.xpath('./transaction')

    # Verify Apple Pay data is present
    assert body.to_s.include?(apple_pay_token), "Apple Pay token should be in request body"
    assert transaction.at_xpath('./apple_pay/payment_data'), "Apple Pay payment_data element should exist"

    # Verify billing address is present
    assert_xpaths_in transaction,
      [ './billing_address/name', 'Apple Pay User' ],
      [ './billing_address/address1', '1 Apple Park Way' ],
      [ './billing_address/city', 'Cupertino' ],
      [ './billing_address/state', 'CA' ],
      [ './billing_address/zip', '95014' ],
      [ './billing_address/country', 'US' ],
      [ './order_id', 'AP-456' ],
      [ './email', 'apple@example.com' ]
  end

  private
  def purchase_using(response)
    @environment.stubs(:raw_ssl_request).returns(response)
    @environment.purchase_on_gateway("IgnoredGatewayTokenSinceResponseIsStubbed", "IgnoredPaymentMethodTokenSinceResponseIsStubbed", 5921)
  end

  def all_possible_options
    {
      currency_code: "EUR",
      order_id: "8675",
      description: "SuperDuper",
      ip: "183.128.100.103",
      merchant_name_descriptor: "Real Stuff",
      merchant_location_descriptor: "Raleigh",
      retain_on_success: true,
      continue_caching: true
    }
  end

end
