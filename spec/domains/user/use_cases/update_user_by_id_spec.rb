require 'rails_helper'

RSpec.describe User::UseCases::UpdateUserById do 
  before(:example) do
    test_seed_paths = Dir['spec/domains/user/use_cases/test_seeds/update_user_by_id.yml']
    Dataset::Base.instance.set_up(seed_paths: test_seed_paths)
  end

  after(:example) do
    Dataset::Base.instance.clean_up
  end

  context 'happy path' do
    let(:fake_user_repo) { instance_double('::User::Repositories::User', find: { id: 9999, name: 'fake name', email: 'f@n' }, where: [], update: { id: 9999, name: 'fake name', email: 'f@n' })}

    it 'update a user' do
      use_case = described_class.new(
        user_repo: fake_user_repo,
        validator: User::UseCases::UpdateUserById::Validator.new(user_repo: fake_user_repo),
      )

      result = use_case.call(id: 3, name: 'Yukihiro Matz')

      expect(result.success?).to eq(true)
      expect(fake_user_repo).to have_received(:update).with(id: 3, attributes: { name: 'Yukihiro Matz' }).once
    end
  end

  context 'unhappy path' do
    it 'user not found' do
      use_case = described_class.new
      result = use_case.call(id: 1, name: 'Martin Fowler' )

      expect(result.failure).to eq('id user not found')
    end

    it 'name is used' do
      use_case = described_class.new
      result = use_case.call(id: 3, name: 'Sandi Metz' )

      expect(result.failure).to eq("name 'Sandi Metz' is used")
    end

    it 'email is used' do
      use_case = described_class.new
      result = use_case.call(id: 3, name: 'Yukihiro Matz', email: 's@m')

      expect(result.failure).to eq("email 's@m' is used")
    end

    it 'name is used by itself' do
      use_case = described_class.new
      result = use_case.call(id: 3, name: 'Yukihiro Matsumoto')

      expect(result.success?).to eq(true)
    end

    it 'email is used by itself' do
      use_case = described_class.new
      result = use_case.call(id: 3, email: 'y@m')

      expect(result.success?).to eq(true)
    end

    it 'email format should match /^\S@\S$/' do
      use_case = described_class.new
      result = use_case.call(id: 3, email: 'yh@m')

      expect(result.failure).to eq("email format should match /^\S@\S$/")
    end
  end
end
