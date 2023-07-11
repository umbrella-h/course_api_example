require 'dry-initializer'
require 'dry/monads'

# Mimic the mechanisum in Boxenn::UseCase, credited to sunnyfounder/boxenn

module Frameworks
  class BaseUseCase
    extend Dry::Initializer
    include Dry::Monads[:result, :do]

    def call(*args)
      Success(yield(steps(*args)))
    rescue Dry::Monads::Do::Halt
      raise
    rescue StandardError => e
      Failure.new(e, trace: e.backtrace.first)
    end

    protected

    def steps
      raise NotImplementedError
    end
  end
end
