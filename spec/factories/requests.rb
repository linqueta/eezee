# frozen_string_literal: true

FactoryBot.define do
  factory :request, class: Katinguele::Request do
    initialize_with { new(attributes) }

    after { ->(_req, _res, _err) { true } }
    before { ->(_req, _res, _err) { nil } }
    logger { true }
    headers do
      {
        'User-Agent' => 'Katinguele',
        Token: 'Token 2b173033-45fa-459a-afba-9eea79cb75be'
      }
    end
    params do
      {
        user_id: 10,
        address_id: 15,
        state: 'Sao Paulo',
        country: 'Brazil'
      }
    end
    path { 'users/:user_id/addresses/:address_id' }
    payload do
      {
        street: 'Paulista Avenue',
        number: '123',
        state: 'Sao Paulo',
        country: 'Brazil'
      }
    end
    protocol { 'https' }
    raise_error { true }
    url { 'addresses.linqueta.com' }
  end
end
