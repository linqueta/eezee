# frozen_string_literal: true

RSpec.describe Eezee::Client, type: :module do
  it_behaves_like :eezee_client_builder, described_class
  it_behaves_like :eezee_client_requester_get, described_class
  it_behaves_like :eezee_client_requester_post, described_class
  it_behaves_like :eezee_client_requester_patch, described_class
  it_behaves_like :eezee_client_requester_put, described_class
  it_behaves_like :eezee_client_requester_delete, described_class
end
