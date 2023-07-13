module User
  class Client
    def find_user_by_id(id:)
      result = User::UseCases::FindUserById.new.call(id: id)
      return nil unless result.success?

      result.value!
    end

    def find_users_by_ids(ids:)
      User::Repositories::User.new.where_by_ids(ids: ids)
    end
  end
end