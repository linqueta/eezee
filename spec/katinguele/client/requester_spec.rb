# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Katinguele::Client::Requester, type: :module do
  it_behaves_like :katinguele_client_requester, described_class
end
