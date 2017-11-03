require 'test_helper'

class AccountActivityTest < ActiveSupport::TestCase
  def test_rejects_absent_account
    account_activity = AccountActivity.new(account: nil)
    account_activity.validate
    assert account_activity.errors.added?(:account, :blank)
  end
end
