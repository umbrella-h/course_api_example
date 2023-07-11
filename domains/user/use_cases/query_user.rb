module User
  module UseCases
    class QueryUser < Frameworks::BaseUseCase
      option :validator, default: -> { User::UseCases::QueryUser::Validator.new }
      option :user_repo, default: -> { ::User::Repositories::User.new }

      def steps(name: nil, email: nil)
        query = yield compact_params(name: name, email: email)
        validated_attributes = yield validate(attributes: query)
        record = yield find_record(validated_attributes: validated_attributes)

        Success(record)
      end

      private

      def compact_params(name:, email:)
        query = { name: name, email: email }.compact
        return Failure('Please query by email or name') if query.empty?

        Success(query)
      end

      def validate(attributes:)
        result = validator.call(attributes)
        return Failure(result.errors(full: true).messages.map(&:text).join(". ")) unless result.success?

        Success(result.to_h)
      end

      def find_record(validated_attributes:)
        records = user_repo.where(validated_attributes)
        return Failure('User not found') if records.blank?

        Success(records.first)
      end
    end
  end
end
