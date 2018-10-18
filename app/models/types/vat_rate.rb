module Types
  class VATRate < ActiveRecord::Type::Value
    def type
      :vat_rate
    end

    def type_cast_from_user(value)
      if value.is_a?(NoVATRate)
        NoVATRate.instance
      elsif value.is_a?(String) && value.empty?
        NoVATRate.instance
      elsif !value.is_a?(VATRate)
        ::VATRate.new(value.to_d)
      end
    end

    def type_cast_from_database(value)
      return if value.nil?

      if value.nil?
        NoVATRate.instance
      else
        ::VATRate.new(value.to_d)
      end
    end

    def type_cast_for_database(value)
      return nil if value.nil?

      if value.is_a?(NoVATRate)
        nil
      else
        value.to_d
      end
    end
  end
end
