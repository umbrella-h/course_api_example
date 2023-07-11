module User
  module UseCases
    class UpdateUserById < Frameworks::BaseUseCase
      option :validator, default: -> { User::UseCases::UpdateUserById::Validator.new }
      option :user_repo, default: -> { ::User::Repositories::User.new }

      def steps(id:, name: nil, email: nil)
        attr_params = yield compact_params(name: name, email: email)
        validated_attributes = yield validate(attributes: attr_params.merge(id: id))
        update_record(validated_attributes: validated_attributes)

        Success()
      end

      private

      def compact_params(name:, email:)
        attrs = { name: name, email: email }.compact
        return Failure('Please input attributes') if attrs.empty?

        Success(attrs)
      end

      def validate(attributes:)
        result = validator.call(attributes)
        return Failure(result.errors(full: true).messages.map(&:text).join(". ")) unless result.success?

        Success(result.to_h)
      end

      def update_record(validated_attributes:)
        user_repo.update(
          id: validated_attributes[:id],
          attributes: validated_attributes.except(:id),
        )
      end
    end
  end
end
