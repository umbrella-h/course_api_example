require 'dry-initializer'
require 'dry-validation'

module Frameworks
  class BaseValidator < Dry::Validation::Contract
    extend Dry::Initializer
  end
end
