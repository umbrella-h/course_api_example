require 'rails_helper'

RSpec.describe Enrollment::Repositories::Enrollment do
  subject(:enrollment_repo) { described_class.new }
 
  before(:example) do
    test_seed_paths = Dir['spec/domains/enrollment/repositories/test_seeds/*.yml']
    Dataset::Base.instance.set_up(seed_paths: test_seed_paths)
  end

  after(:example) do
    Dataset::Base.instance.clean_up
  end

  context 'filter by userId or courseId or role' do
    it 'happy path: filter by userId' do
      entities = enrollment_repo.where(userId: 32)

      expect(entities.map(&:to_h)).to match_array([{ id: 31, userId: 32, courseId: 33, role: 'teacher' }])
    end

    it 'happy path: filter by courseId' do
      entities = enrollment_repo.where(courseId: 23)

      expect(entities.map(&:to_h)).to match_array([{ id: 21, userId: 22, courseId: 23, role: 'student' }])
    end

    it 'happy path: filter by role' do
      entities = enrollment_repo.where(role: 'student')

      expect(entities.map(&:to_h)).to match_array([{ id: 11, userId: 12, courseId: 13, role: 'student' }, { id: 21, userId: 22, courseId: 23, role: 'student' }])
    end
  end

  context 'find by primary key' do
    it 'find by id' do
      entity = enrollment_repo.find(id: 31 )

      expect(entity.to_h).to eq({ id: 31, userId: 32, courseId: 33, role: 'teacher' })
    end
  end

  context 'create' do
    it 'happy path' do
      enrollment_repo.create(attributes: { userId: 42, courseId: 43, role: 'teacher' })

      expect(Dataset::Base.instance.find(table_name: 'enrollments', primary_hash: { id: 32 })).to eq({ id: 32, userId: 42, courseId: 43, role: 'teacher' })
    end
  end

  context 'delete' do
    it 'happy path' do
      enrollment_repo.delete(id: 11)

      expect(Dataset::Base.instance.tables[:enrollments]).to match_array([{ id: 21, userId: 22, courseId: 23, role: 'student' }, { id: 31, userId: 32, courseId: 33, role: 'teacher' }])
    end
  end

  context 'all' do
    it 'happy path' do
      entities = enrollment_repo.all

      expect(entities.map(&:to_h)).to match_array(expected_default_dataset[:enrollments])
    end
  end

  private

  def expected_default_dataset
    {
      enrollments: [
        { id: 11, userId: 12, courseId: 13, role: 'student' },
        { id: 21, userId: 22, courseId: 23, role: 'student' },
        { id: 31, userId: 32, courseId: 33, role: 'teacher' },
      ],
    }
  end
end
