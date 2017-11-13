FactoryBot.define do
  factory :invoice_item do
    description { 'add money' }
    unit 1
    quantity 1
    price 150
  end
end
