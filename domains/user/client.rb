module User
  class Client
    def find_user_by_id(id:)
      result = User::UseCases::FindUserById.new.call(id: id)
      return nil unless result.success?

      result.value!
    end
  end
end