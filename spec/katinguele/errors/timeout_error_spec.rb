# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::TimeoutError, type: :model do
  describe '#log' do
    subject { error.log }
    let(:error) { described_class.new(response) }
    let(:response) { Katinguele::Response.new(nil) }

    after { subject }

    it { expect(Katinguele::Logger).to receive(:error).with(error) }
  end
end
