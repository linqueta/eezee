# frozen_string_literal: true

RSpec.describe Katinguele::Logger, type: :model do
  describe '.request' do
    subject do
      Katinguele::Logger.request(
        FactoryBot.build(
          :service,
          path: nil,
          params: { user: 1 },
          headers: { Token: 'Token 2b173033-45fa-459a-afba-9eea79cb75be' },
          payload: { street: 'Paulist Avenue' }
        ),
        :GET
      )
    end

    after { subject }

    it 'puts request logs' do
      expect(described_class)
        .to receive(:p)
        .with('INFO -- request: GET https://addresses.linqueta.com?user=1')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- request: HEADERS: {"Token":"Token 2b173033-45fa-459a-afba-9eea79cb75be"}')
        .once
      expect(described_class)
        .to receive(:p)
        .with('INFO -- request: PAYLOAD: {"street":"Paulist Avenue"}')
        .once
    end
  end
end
