module User
  module UseCases
    class DeleteUserById < Frameworks::BaseUseCase
      option :user_repo, default: -> { ::User::Repositories::User.new }

      def steps(id:)
        yield delete_record(id: id.to_i)

        Success()
      end

      private

      def delete_record(id:)
        user = user_repo.find(id: id)

        return Failure('User not found') if user.nil?

        user_repo.delete(id: id)

        Success()
      end
    end
  end
end
