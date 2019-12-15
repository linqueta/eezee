# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::NotImplementedError, type: :model do
  describe '#initialize' do
    subject { described_class.new(origin, method) }

    let(:origin) { Katinguele }
    let(:method) { :just_do_it }

    it do
      is_expected.to have_attributes(
        message: 'The method just_do_it is not implemented in Katinguele',
        origin: origin,
        method: method
      )
    end
  end
end
