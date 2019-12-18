# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::Configuration, type: :model do
  describe '#initialize' do
    subject { described_class.new }

    it { is_expected.to have_attributes(services: {}) }
  end

  describe '#add_service' do
    subject { instance.add_service(name, options) }

    let(:instance) { described_class.new }
    let(:name) { :linqueta }
    let(:options) do
      {
        protocol: 'https',
        raise_error: true,
        url: 'www.linqueta.com'
      }
    end

    before { subject }

    it { expect(instance.services).not_to be_empty }
    it do
      expect(instance.services[name]).to have_attributes(
        protocol: 'https',
        raise_error: true,
        url: 'www.linqueta.com',
        uri: 'https://www.linqueta.com'
      )
    end
  end
end
