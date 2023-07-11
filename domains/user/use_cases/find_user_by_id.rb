module User
  module UseCases
    class FindUserById < Frameworks::BaseUseCase
      option :user_repo, default: -> { ::User::Repositories::User.new }

      def steps(id:)
        user = yield find_record(id: id.to_i)

        Success(user)
      end

      private

      def find_record(id:)
        user = user_repo.find(id: id)

        return Failure('User not found') if user.nil?

        Success(user)
      end
    end
  end
end
