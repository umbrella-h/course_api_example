module User
  module UseCases
    class CreateUser < Frameworks::BaseUseCase
      option :validator, default: -> { User::UseCases::CreateUser::Validator.new }
      option :user_repo, default: -> { ::User::Repositories::User.new }

      def steps(attributes:)
        validated_attributes = yield validate(attributes: attributes)
        create_record(validated_attributes: validated_attributes)

        Success()
      end

      private

      def validate(attributes:)
        result = validator.call(attributes)
        return Failure(result.errors(full: true).messages.map(&:text).join(". ")) unless result.success?

        Success(result.to_h)
      end

      def create_record(validated_attributes:)
        user_repo.create(attributes: validated_attributes)
      end
    end
  end
end
