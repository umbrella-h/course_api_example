module User
  module UseCases
    class UpdateUserById::Validator < Frameworks::BaseValidator
      option :user_repo, default: -> { ::User::Repositories::User.new }

      params do
        required(:id).filled(:integer)
        optional(:name).filled(:string)
        optional(:email).filled(:string)
      end

      rule(:id) do
        user = user_repo.find(id: value)

        key.failure('user not found') if user.nil?
      end

      rule(:name) do
        next unless key?

        same_name_users = user_repo.where(name: value)
        key.failure("'#{value}' is used") unless same_name_users.size.zero? || same_name_users.map(&:id) == [values[:id]]
      end

      rule(:email) do
        next unless key?

        key.failure("format should match /^\S@\S$/") if value.match(/^\S@\S$/).nil?

        same_email_users = user_repo.where(email: value)
        key.failure("'#{value}' is used") unless same_email_users.size.zero? || same_email_users.map(&:id) == [values[:id]]
      end
    end
  end
end
