# frozen_string_literal: true

RSpec.describe Katinguele::Client, type: :module do
  it_behaves_like :katinguele_client_builder, described_class
  it_behaves_like :katinguele_client_requester_get, described_class
  it_behaves_like :katinguele_client_requester_post, described_class
  it_behaves_like :katinguele_client_requester_patch, described_class
  it_behaves_like :katinguele_client_requester_put, described_class
end
