require 'test_helper'

class AccountActivityTest < ActiveSupport::TestCase
  def test_rejects_absent_account
    account_activity = AccountActivity.new(account: nil)
    account_activity.validate
    assert account_activity.errors.added?(:account, :blank)
  end

  def test_delegates_currency_to_account
    account = Account.new(currency: 'EUR')
    account_activity = AccountActivity.new(account: account)
    assert 'EUR', account_activity.currency
  end
end
