# frozen_string_literal: true

RSpec.describe Katinguele::RequestErrorFactory, type: :model do
  describe '.build', :vcr do
    subject { described_class.build(original) }

    context 'with timeout error' do
      let(:original) { Katinguele::Response.new(Faraday::TimeoutError.new) }

      it { is_expected.to be_a(Katinguele::TimeoutError) }
    end

    context 'without timeout error' do
      let(:original) { Katinguele::Response.new(nil) }

      before do
        allow(original).to receive(:body).and_return({})
        allow(original).to receive(:code).and_return(code)
      end

      context 'with bad request' do
        let(:code) { 400 }

        it { is_expected.to be_a(Katinguele::BadRequestError) }
      end

      context 'with unauthorized' do
        let(:code) { 401 }

        it { is_expected.to be_a(Katinguele::UnauthorizedError) }
      end

      context 'with forbidden' do
        let(:code) { 403 }

        it { is_expected.to be_a(Katinguele::ForbiddenError) }
      end

      context 'with resource not found' do
        let(:code) { 404 }

        it { is_expected.to be_a(Katinguele::ResourceNotFoundError) }
      end

      context 'with unprocessable entity' do
        let(:code) { 422 }

        it { is_expected.to be_a(Katinguele::UnprocessableEntityError) }
      end

      context 'with client error' do
        let(:code) { 418 }

        it { is_expected.to be_a(Katinguele::ClientError) }
      end

      context 'with internal server error' do
        let(:code) { 500 }

        it { is_expected.to be_a(Katinguele::InternalServerError) }
      end

      context 'with service unavailable' do
        let(:code) { 503 }

        it { is_expected.to be_a(Katinguele::ServiceUnavailableError) }
      end

      context 'with server error' do
        let(:code) { 501 }

        it { is_expected.to be_a(Katinguele::ServerError) }
      end

      context 'with undefined code' do
        let(:code) { nil }

        it { is_expected.to be_a(Katinguele::RequestError) }
      end
    end
  end
end
