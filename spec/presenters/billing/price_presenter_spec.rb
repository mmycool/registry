require 'rails_helper'

RSpec.describe Billing::PricePresenter do
  let(:presenter) { described_class.new(price: price, view: view) }

  describe '#expire_btn' do
    context 'when price is not expired' do
      let(:price) { instance_double(Billing::Price, expired?: false) }

      it 'returns expire button' do
        html = view.link_to(t('admin.billing.prices.expire_btn.label'), expire_admin_price_path(price),
                            method: :patch,
                            data: {
                              confirm: view.t('admin.billing.prices.expire_btn.confirm'),
                            },
                            class: 'btn btn-danger')
        expect(presenter.expire_btn).to eq(html)
      end
    end

    context 'when price is expired' do
      let(:price) { instance_double(Billing::Price, expired?: true) }
      specify { expect(presenter.expire_btn).to be_nil }
    end
  end
end
