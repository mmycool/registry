require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  def setup
    @domain = domains(:shop)
  end

  def test_validates
    assert @domain.valid?
  end

  def test_rejects_absent_transfer_code
    @domain.transfer_code = nil
    @domain.validate
    assert @domain.invalid?
  end

  def test_generates_random_transfer_code_if_new
    domain = Domain.new
    another_domain = Domain.new

    refute_empty domain.transfer_code
    refute_empty another_domain.transfer_code
    refute_equal domain.transfer_code, another_domain.transfer_code
  end

  def test_does_not_regenerate_transfer_code_if_persisted
    original_transfer_code = @domain.transfer_code
    @domain.save!
    @domain.reload
    assert_equal original_transfer_code, @domain.transfer_code
  end

  def test_transfers_domain
    old_transfer_code = @domain.transfer_code
    new_registrar = registrars(:goodnames)
    @domain.transfer(new_registrar)

    assert_equal new_registrar, @domain.registrar
    refute_same @domain.transfer_code, old_transfer_code
  end
end
