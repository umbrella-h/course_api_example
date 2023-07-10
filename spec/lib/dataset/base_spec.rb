require 'dataset/base'

RSpec.describe Dataset::Base do
  before(:example) do
    test_seed_paths = Dir['spec/lib/dataset/test_seeds/*.yml']
    described_class.instance.set_up(seed_paths: test_seed_paths)
  end

  after(:example) do
    described_class.instance.clean_up
  end

  # TODO: add unhappy path cases

  context 'set up default dataset' do
    it do
      data = described_class.instance.tables

      expect(data).to eq(expected_default_dataset)
    end
  end

  context 'where' do
    it 'happy path' do
      data = described_class.instance.where(table_name: 'users', query_hash: { name: 'Test User A'})

      expect(data).to match_array([{ id: 123, name: 'Test User A', email: 'aa@t'}, { id: 456, name: 'Test User A', email: 'ab@t'}])
    end
  end

  context 'find' do
    it 'happy path' do
      data = described_class.instance.find(table_name: 'users', primary_hash: { id: 456 })

      expect(data).to eq({ id: 456, name: 'Test User A', email: 'ab@t'})
    end
  end

  context 'update' do
    it 'happy path' do
      described_class.instance.update(table_name: 'users', primary_hash: { id: 789 }, attributes: { name: 'Test User D' })

      expect(described_class.instance.find(table_name: 'users', primary_hash: { id: 789 })).to eq({ id: 789, name: 'Test User D', email: 'c@t'})
    end
  end

  context 'create' do
    it 'happy path' do
      described_class.instance.create(table_name: 'users', primary_hash: { id: 012 }, attributes: { id: 012, name: 'Test User D', email: 'd@t' })

      expect(described_class.instance.find(table_name: 'users', primary_hash: { id: 012 })).to eq({ id: 012, name: 'Test User D', email: 'd@t'})
    end
  end

  context 'delete' do
    it 'happy path' do
      described_class.instance.delete(table_name: 'users', primary_hash: { id: 123 })

      expect(described_class.instance.tables[:users]).to match_array([{ id: 789, name: 'Test User C', email: 'c@t'}, { id: 456, name: 'Test User A', email: 'ab@t'}])
    end
  end

  private

  def expected_default_dataset
    {
      courses: [
        { id: 123, name: 'Test Course A' },
        { id: 456, name: 'Test Course B' },
      ],
      users: [
        { id: 123, name: 'Test User A', email: 'aa@t'},
        { id: 456, name: 'Test User A', email: 'ab@t'},
        { id: 789, name: 'Test User C', email: 'c@t'},
      ],
    }
  end
end
