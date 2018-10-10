require 'test_helper'

class ConvertRegistrarVATRateTaskTest < ActiveSupport::TestCase
  setup do
    @registrar = registrars(:bestnames)
  end

  def test_converts_registrar_vat_rate
    @registrar.update_columns(vat_rate: '0.205')

    capture_io { run_task }
    @registrar.reload

    assert_equal VATRate.new(BigDecimal('20.5')), @registrar.vat_rate
  end

  def test_keeps_registrars_with_no_vat_intact
    @registrar.update_columns(vat_rate: NoVATRate.instance)

    capture_io { run_task }
    @registrar.reload

    assert_equal NoVATRate.instance, @registrar.vat_rate
  end

  def test_task_is_idempotent
    @registrar.update_columns(vat_rate: VATRate.new(10))

    capture_io { run_task }
    @registrar.reload

    assert_equal VATRate.new(10), @registrar.vat_rate
  end

  def test_output
    @registrar.update_columns(vat_rate: '0.205')
    assert_output("Registrars processed: 1\n") { run_task }
  end

  private

  def run_task
    Rake::Task['data_migrations:convert_registrar_vat_rate'].execute
  end
end
