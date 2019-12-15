# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::Service::Base, type: :model do
  describe '.get' do
    subject { described_class.get(nil) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError) }
  end

  describe '.post' do
    subject { described_class.post(nil) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError) }
  end

  describe '.patch' do
    subject { described_class.patch(nil) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError) }
  end

  describe '.put' do
    subject { described_class.put(nil) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError) }
  end

  describe '.delete' do
    subject { described_class.delete(nil) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError) }
  end
end
