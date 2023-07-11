module User
  module UseCases
    class CreateUser::Validator < Frameworks::BaseValidator
      option :user_repo, default: -> { ::User::Repositories::User.new }

      params do
        required(:name).filled(:string)
        required(:email).filled(:string)
      end

      rule(:name) do
        key.failure("'#{value}' is used") if user_repo.where(name: value).any?
      end

      rule(:email) do
        key.failure("format should match /^\S@\S$/") if value.match(/^\S@\S$/).nil?

        key.failure("'#{value}' is used") if user_repo.where(email: value).any?
      end
    end
  end
end
