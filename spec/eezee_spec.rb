# frozen_string_literal: true

RSpec.describe Eezee, type: :module do
  it { expect(described_class::VERSION).not_to be_nil }

  describe '.configure' do
    subject do
      described_class.configure do |config|
        config.add_service :linqueta,
                           protocol: 'https',
                           raise_error: true,
                           url: 'www.linqueta.com'
      end
    end

    before { subject }

    it do
      expect(described_class.configuration.services[:linqueta]).to have_attributes(
        protocol: 'https',
        raise_error: true,
        url: 'www.linqueta.com',
        uri: 'https://www.linqueta.com'
      )
    end
  end

  describe '.configuration' do
    subject { described_class.configuration }

    it { is_expected.to be_a(described_class::Configuration) }
  end
end
