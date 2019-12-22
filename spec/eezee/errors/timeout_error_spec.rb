# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Eezee::TimeoutError, type: :model do
  describe '#log' do
    subject { error.log }
    let(:error) { described_class.new(response) }
    let(:response) { Eezee::Response.new(nil) }

    after { subject }

    it { expect(Eezee::Logger).to receive(:error).with(error) }
  end
end
