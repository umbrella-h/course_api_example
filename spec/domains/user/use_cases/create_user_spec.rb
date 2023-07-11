require 'rails_helper'

RSpec.describe User::UseCases::CreateUser do 
  before(:example) do
    test_seed_paths = Dir['spec/domains/user/use_cases/test_seeds/create_user.yml']
    Dataset::Base.instance.set_up(seed_paths: test_seed_paths)
  end

  after(:example) do
    Dataset::Base.instance.clean_up
  end

  context 'happy path' do
    let(:fake_user_repo) { instance_double('::User::Repositories::User', where: [], create: { id: 9999, name: 'fake name', email: 'f@n' })}

    it 'create 3 users in a sequence' do
      use_case = described_class.new(
        user_repo: fake_user_repo,
        validator: User::UseCases::CreateUser::Validator.new(user_repo: fake_user_repo),
      )

      use_case.call(name: 'Martin Fowler', email: 'm@f')
      use_case.call(name: 'Sandi Metz', email: 's@m')
      use_case.call(name: 'Yukihiro Matsumoto', email: 'y@m')

      expect(fake_user_repo).to have_received(:create).with(attributes: { name: 'Martin Fowler', email: 'm@f' }).once
      expect(fake_user_repo).to have_received(:create).with(attributes: { name: 'Sandi Metz', email: 's@m' }).once
      expect(fake_user_repo).to have_received(:create).with(attributes: { name: 'Yukihiro Matsumoto', email: 'y@m' }).once
    end
  end

  context 'unhappy path' do
    it 'name is used' do
      use_case = described_class.new
      use_case.call(name: 'Martin Fowler', email: 'm@f')
      result = use_case.call(name: 'Martin Fowler', email: 'n@f')

      expect(result.failure).to eq("name 'Martin Fowler' is used")
    end

    it 'email is used' do
      use_case = described_class.new
      use_case.call(name: 'Martin Fowler', email: 'm@f')
      result = use_case.call(name: 'M Fowler', email: 'm@f')

      expect(result.failure).to eq("email 'm@f' is used")
    end

    it 'email format should match /^\S@\S$/' do
      use_case = described_class.new
      result = use_case.call(name: 'Martin Fowler', email: 'mt@f')

      expect(result.failure).to eq("email format should match /^\S@\S$/")
    end
  end
end
