module Billing
  class PricePresenter
    def initialize(price:, view:)
      @price = price
      @view = view
    end

    def expire_btn
      return if price.expired?

      view.link_to(view.t('admin.billing.prices.expire_btn.label'),
                   view.expire_admin_price_path(price),
                   method: :patch,
                   data: {
                     confirm: view.t('admin.billing.prices.expire_btn.confirm'),
                   },
                   class: 'btn btn-danger')
    end

    private

    attr_reader :price
    attr_reader :view
  end
end
