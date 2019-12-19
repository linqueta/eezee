# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::Client::Requester, type: :module do
  it_behaves_like :katinguele_client_requester_get, described_class
  it_behaves_like :katinguele_client_requester_post, described_class
  it_behaves_like :katinguele_client_requester_patch, described_class
end
