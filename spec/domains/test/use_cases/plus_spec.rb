require './domains/test/use_cases/plus'

RSpec.describe ::Test::UseCases::Plus do
  let(:x) { 10 }

  context 'plus 1' do
    it do
      result = described_class.new.perform(a: x, b: 1)

      expect(result).to eq(11)
    end
  end

  context 'plus 2' do
    it do
      result = described_class.new.perform(a: x, b: 2)

      expect(result).to eq(12)
    end
  end
end