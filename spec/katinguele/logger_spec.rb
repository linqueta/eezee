# frozen_string_literal: true

RSpec.describe Katinguele::Logger, type: :model do
  describe '.request' do
    subject do
      Katinguele::Logger.request(
        FactoryBot.build(
          :request,
          path: nil,
          params: { user: 1 },
          headers: { Token: 'Token 2b173033-45fa-459a-afba-9eea79cb75be' },
          payload: { street: 'Paulista Avenue' }
        ),
        :GET
      )
    end

    after { subject }

    it 'puts request logs' do
      expect(described_class)
        .to receive(:p)
        .with('INFO -- request: GET https://www.linqueta.com?user=1')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- request: HEADERS: {"Token":"Token 2b173033-45fa-459a-afba-9eea79cb75be"}')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- request: PAYLOAD: {"street":"Paulista Avenue"}')
        .once
    end
  end

  describe '.response' do
    subject { Katinguele::Logger.response(response) }

    let(:response) { Katinguele::Response.new(nil) }

    before do
      allow(response).to receive(:body).and_return(error: 'some error')
      allow(response).to receive(:code).and_return(400)
      allow(response).to receive(:success).and_return(false)
      allow(response).to receive(:timeout?).and_return(false)
    end

    after { subject }

    it 'puts response logs' do
      expect(described_class)
        .to receive(:p)
        .with('INFO -- response: SUCCESS: false')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- response: TIMEOUT: false')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- response: CODE: 400')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- response: BODY: {"error":"some error"}')
        .once
    end
  end

  describe '.response' do
    subject { Katinguele::Logger.error(error) }

    let(:error) { Katinguele::ResourceNotFoundError.new(response) }
    let(:response) { Katinguele::Response.new(nil) }

    before do
      allow(response).to receive(:body).and_return(error: 'some error')
      allow(response).to receive(:code).and_return(400)
      allow(response).to receive(:success).and_return(false)
      allow(response).to receive(:timeout?).and_return(false)
    end

    after { subject }

    it 'puts response logs' do
      expect(described_class)
        .to receive(:p)
        .with('INFO -- error: Katinguele::ResourceNotFoundError')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- error: SUCCESS: false')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- error: TIMEOUT: false')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- error: CODE: 400')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- error: BODY: {"error":"some error"}')
        .once
    end
  end


end
