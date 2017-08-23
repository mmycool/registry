require 'rails_helper'

RSpec.describe 'admin/settings/index' do
  it 'has :extended_price_lookup checkbox' do
    render
    expect(rendered).to have_css('[type=checkbox][name="[settings][extended_price_lookup]"]')
  end
end
