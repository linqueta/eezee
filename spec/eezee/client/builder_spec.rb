# frozen_string_literal: true

RSpec.describe Eezee::Client::Builder, type: :module do
  it_behaves_like :eezee_client_builder, described_class
end
