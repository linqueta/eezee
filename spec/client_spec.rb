# frozen_string_literal: true

RSpec.describe Katinguele::Client, type: :module do
  describe '#katinguele_request_options' do
    subject { KatingueleRequestOptions.katinguele_request_options }

    class KatingueleRequestOptions
      extend Katinguele::Client

      katinguele_request_options raise_error: true,
                                 url: 'https://www.linqueta.com',
                                 headers: { 'Content-Type' => 'application/json' }
    end

    it do
      is_expected.to eq(
        raise_error: true,
        url: 'https://www.linqueta.com',
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end
