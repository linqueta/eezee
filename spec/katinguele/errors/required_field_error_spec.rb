# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::RequiredFieldError, type: :model do
  describe '#initialize' do
    subject { described_class.new(origin, field) }

    let(:origin) { Katinguele }
    let(:field) { :url }

    it do
      is_expected.to have_attributes(
        message: 'The field url is required for Katinguele',
        origin: origin,
        field: field
      )
    end
  end
end
