module Course
  class Client
    def find_course_by_id(id:)
      result = Course::UseCases::FindCourseById.new.call(id: id)
      return nil unless result.success?

      result.value!
    end

    def find_courses_by_ids(ids:)
      Course::Repositories::Course.new.where_by_ids(ids: ids)
    end
  end
end