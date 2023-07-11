require 'rails_helper'

RSpec.describe User::Repositories::User do
  subject(:user_repo) { described_class.new }
 
  before(:example) do
    test_seed_paths = Dir['spec/domains/user/repositories/test_seeds/*.yml']
    Dataset::Base.instance.set_up(seed_paths: test_seed_paths)
  end

  after(:example) do
    Dataset::Base.instance.clean_up
  end

  context 'filter by name or email' do
    it 'happy path: filter by name' do
      entities = user_repo.where(name: 'Test User A')

      expect(entities.map(&:to_h)).to match_array([{ id: 123, name: 'Test User A', email: 'a@t' }, { id: 456, name: 'Test User A', email: 'b@t' }])
    end

    it 'happy path: filter by email' do
      entities = user_repo.where(name: 'Test User A')

      expect(entities.map(&:to_h)).to match_array([{ id: 123, name: 'Test User A', email: 'a@t' }, { id: 456, name: 'Test User A', email: 'b@t' }])
    end
  end

  context 'find by primary key' do
    it 'find by id' do
      entity = user_repo.find(id: 456 )

      expect(entity.to_h).to eq({ id: 456, name: 'Test User A', email: 'b@t' })
    end
  end

  context 'update' do
    it 'happy path' do
      user_repo.update(id: 789, attributes: { name: 'Test User D' })

      expect(Dataset::Base.instance.find(table_name: 'users', primary_hash: { id: 789 })).to eq({ id: 789, name: 'Test User D', email: 'c@t' })
    end
  end

  context 'create' do
    it 'happy path' do
      user_repo.create(attributes: { name: 'Test User D', email: 'd@t' })

      expect(Dataset::Base.instance.find(table_name: 'users', primary_hash: { id: 790 })).to eq({ id: 790, name: 'Test User D', email: 'd@t' })
    end
  end

  context 'delete' do
    it 'happy path' do
      user_repo.delete(id: 123)

      expect(Dataset::Base.instance.tables[:users]).to match_array([{ id: 789, name: 'Test User C', email: 'c@t' }, { id: 456, name: 'Test User A', email: 'b@t' }])
    end
  end

  context 'all' do
    it 'happy path' do
      entities = user_repo.all

      expect(entities.map(&:to_h)).to match_array(expected_default_dataset[:users])
    end
  end

  private

  def expected_default_dataset
    {
      users: [
        { id: 123, name: 'Test User A', email: 'a@t' },
        { id: 456, name: 'Test User A', email: 'b@t' },
        { id: 789, name: 'Test User C', email: 'c@t' },
      ],
    }
  end
end
