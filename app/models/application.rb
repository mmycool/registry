class Application
  @features = %i[auto_invoice]
  @auto_invoice = ENV['auto_invoice'] == 'true'

  class << self
    def enable_feature(feature)
      validate_feature(feature)
      instance_variable_set("@#{feature}", true)
    end

    def disable_feature(feature)
      validate_feature(feature)
      instance_variable_set("@#{feature}", false)
    end

    def feature_enabled?(feature)
      validate_feature(feature)
      instance_variable_get("@#{feature}")
    end

    def feature_disabled?(feature)
      validate_feature(feature)
      !feature_enabled?(feature)
    end

    private

    def validate_feature(feature)
      raise 'Unknown feature' unless @features.include?(feature.to_sym)
    end
  end
end