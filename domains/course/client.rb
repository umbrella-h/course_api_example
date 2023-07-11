module Course
  class Client
    def find_course_by_id(id:)
      result = Course::UseCases::FindCourseById.new.call(id: id)
      return nil unless result.success?

      result.value!
    end
  end
end