# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Eezee::RequestError, type: :model do
  describe '#initialize' do
    subject { described_class.new(request, response) }

    let(:request) { build :request }
    let(:response) { Eezee::Response.new(nil) }

    before do
      allow(response).to receive(:body).and_return(error: 'some error')
      allow(response).to receive(:code).and_return(400)
    end

    it { is_expected.to be_a(described_class) }
    it { is_expected.to have_attributes(message: 'CODE: 400 - URI: https://www.linqueta.com/users/10/addresses/15?state=Sao Paulo&country=Brazil - BODY: {"error":"some error"}') } # rubocop:disable Metrics/LineLength
  end

  describe '#log' do
    subject { error.log }

    let(:error) { described_class.new(request, response) }
    let(:response) { Eezee::Response.new(nil) }
    let(:request) { build :request }

    before do
      allow(response).to receive(:body).and_return(error: 'some error')
      allow(response).to receive(:code).and_return(400)
    end

    after { subject }

    it { expect(Eezee::Logger).to receive(:error).with(error) }
  end
end
