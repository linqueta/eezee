# frozen_string_literal: true

FactoryBot.define do
  factory :service, class: Katinguele::Service do
    initialize_with { new(attributes) }

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
    url { 'addresses.linqueta.com' }
  end
end
