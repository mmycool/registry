require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def test_rejects_absent_registrar
    account = Account.new(registrar: nil)
    account.validate
    assert account.errors.added?(:registrar, :blank)
  end
end
