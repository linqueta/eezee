# frozen_string_literal: true

RSpec.describe Katinguele::Client, type: :module do
  it_behaves_like :katinguele_client_builder, described_class
end
