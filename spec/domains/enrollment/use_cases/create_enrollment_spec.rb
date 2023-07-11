require 'rails_helper'

RSpec.describe Enrollment::UseCases::CreateEnrollment do 
  before(:example) do
    test_seed_paths = Dir['spec/domains/enrollment/use_cases/test_seeds/create_enrollment.yml']
    Dataset::Base.instance.set_up(seed_paths: test_seed_paths)
  end

  after(:example) do
    Dataset::Base.instance.clean_up
  end

  context 'happy path' do
    let(:fake_enrollment_repo) { instance_double('::Enrollment::Repositories::Enrollment', where: [], create: { id: 9999, name: 'fake name', email: 'f@n' })}

    it 'create 3 enrollments in a sequence' do
      use_case = described_class.new(
        enrollment_repo: fake_enrollment_repo,
        validator: Enrollment::UseCases::CreateEnrollment::Validator.new(enrollment_repo: fake_enrollment_repo),
      )

      use_case.call(userId: 12, courseId: 13, role: 'student')
      use_case.call(userId: 22, courseId: 23, role: 'student')
      use_case.call(userId: 32, courseId: 33, role: 'teacher')

      expect(fake_enrollment_repo).to have_received(:create).with(attributes: { userId: 12, courseId: 13, role: 'student' }).once
      expect(fake_enrollment_repo).to have_received(:create).with(attributes: { userId: 22, courseId: 23, role: 'student' }).once
      expect(fake_enrollment_repo).to have_received(:create).with(attributes: { userId: 32, courseId: 33, role: 'teacher' }).once
    end
  end

  context 'unhappy path' do
    it 'user has been enrolled in course' do
      use_case = described_class.new
      use_case.call(userId: 42, courseId: 43, role: 'teacher')
      result = use_case.call(userId: 42, courseId: 43, role: 'teacher')

      expect(result.failure).to eq('userId 42 has been enrolled in courseId 43')
    end
  end
end
