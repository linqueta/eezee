# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::Service::Base, type: :model do
  describe '.get' do
    subject { described_class.get(build(:request)) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError, /get/) }
  end

  describe '.post' do
    subject { described_class.post(build(:request)) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError, /post/) }
  end

  describe '.patch' do
    subject { described_class.patch(build(:request)) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError, /patch/) }
  end

  describe '.put' do
    subject { described_class.put(build(:request)) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError, /put/) }
  end

  describe '.delete' do
    subject { described_class.delete(build(:request)) }

    it { expect { subject }.to raise_error(Katinguele::NotImplementedError, /delete/) }
  end
end
