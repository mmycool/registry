module EPP
  class OperationCategory
    def self.all
      %w[create renew transfer update delete]
    end
  end
end
