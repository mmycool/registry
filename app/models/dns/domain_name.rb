module DNS
  # Namespace is needed, because a class with the same name is defined by `domain_name` gem,
  # a dependency of `actionmailer`,
  class DomainName
    def initialize(name)
      @name = name
    end

    def unavailable?
      registered? || blocked? || zone_with_same_origin?
    end

    def unavailability_reason
      if registered?
        :registered
      elsif blocked?
        :blocked
      elsif zone_with_same_origin?
        :zone_with_same_origin
      end
    end

    private

    attr_reader :name

    def registered?
      Domain.find_by_idn(name)
    end

    def blocked?
      BlockedDomain.where(name: name).any?
    end

    def zone_with_same_origin?
      DNS::Zone.where(origin: name).any?
    end
  end
end
