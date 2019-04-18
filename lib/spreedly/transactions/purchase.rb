module Spreedly

  class Purchase < AuthPurchase
    field :checkout_url, :checkout_form, :redirect_url, :callback_url
  end

end
