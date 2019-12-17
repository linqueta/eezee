# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::InvalidValueError, type: :model do
  describe '#initialize' do
    subject { described_class.new(origin, field, snippet) }

    let(:origin) { Katinguele }
    let(:field) { :url }
    let(:snippet) { 'You should pass a valid url like: www.linqueta.com' }

    it do
      is_expected.to have_attributes(
        message:
        "The field Katinguele's url receives an invalid value. You should pass a valid url like: www.linqueta.com",
        origin: origin,
        field: field,
        snippet: snippet
      )
    end
  end
end
