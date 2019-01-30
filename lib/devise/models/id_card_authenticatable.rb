module Devise
  module Models
    # Devise fails without this module (and model: false does not help)
    module IDCardAuthenticatable
    end
  end
end