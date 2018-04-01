require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  def setup
    @domain = domains(:shop)
  end

  def test_valid_fixture_is_valid
    assert @domain.valid?
  end

  def test_invalid_fixture_is_invalid
    assert domains(:invalid).invalid?
  end

  def test_invalid_when_registrant_is_invalid
    @domain.registrant = contacts(:invalid).becomes(Registrant)
    assert @domain.invalid?
  end
end
