module User
  module UseCases
    class QueryUser::Validator < Frameworks::BaseValidator
      option :user_repo, default: -> { ::User::Repositories::User.new }

      params do
        optional(:name).filled(:string)
        optional(:email).filled(:string)
      end

      rule(:email) do
        next unless key?

        key.failure("format should match /^\S@\S$/") if value.match(/^\S@\S$/).nil?
      end
    end
  end
end