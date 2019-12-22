# [Eezee][gem_page]

*Eezee or ee-zee sounds like "Easy"*

[![Gem Version][gem_version_image]][gem_version_page]
[![Build Status][travis_status_image]][travis_page]
[![Maintainability][code_climate_maintainability_image]][code_climate_maintainability_page]
[![Test Coverage][code_climate_test_coverage_image]][code_climate_test_coverage_page]

The easiest HTTP client for Ruby!

With Eezee you can do these things:
  * Define external services in an initializer file and use them through a simple method
  * Take HTTP requests just extending a module and call the HTTP request method in your class/module
  * Set before and after hooks to handle your requests, responses, and errors
  * Handle all requests, responses, and errors in the same way
  * Log the request, response, and errors
  * Set general request timeout and open connection timeout
  * Raise errors in failed requests
  * Spend more time coding your API integrations instead defining and testing HTTP settings and clients

This gem is supported for Ruby 2.6+ applications.

## Table of Contents
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Supported HTTP Methods](#supported-http-methods)
  - [How to take a request](#how-to-take-a-request)
  - [Request options](#request-options)
    - [Available Request options](#available-request-options)
  - [Services](#services)
    - [How a service works](#how-a-service-works)
  - [Request](#request)
  - [Response](#response)
  - [Errors](#errors)
  - [Examples](#examples)
    - [Complete integrations](#complete-integrations)
    - [Hooks](#hooks)
    - [Timeout](#timeout)
    - [Logging](#logging)
- [Why use Eezee instead Faraday](#why-use-eezee-instead-faraday)
- [Contributing](#contributing)
- [License](#license)

## Getting started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'eezee'
```

If you're on Rails you can run this line below to create the initializer:

```shell
rails generator eezee:install
```

### Supported HTTP Methods

Eezee supports these HTTP methods:

- GET
- POST
- PATCH
- PUT
- DELETE

And here are the corresponding Eezee's HTTP methods:

- get(request_options)
- post(request_options)
- patch(request_options)
- put(request_options)
- delete(request_options)

OBS: The param `request_options` is optional.

### How to take a request

To take a request using any of these methods you just have to call the HTTP method, and if you want, you can pass the options.

```ruby
module RickMorty::Resource::Character
  extend Eezee::Client

  def self.index
    get(url: 'rickandmortyapi.com/api', protocol: :https, path: 'character')
  end

  def self.find(id)
    get(
      url: 'rickandmortyapi.com/api',
      protocol: :https,
      path: 'character/:character_id',
      params: { character_id: id }
    )
  end

  def self.create(payload)
    post(
      url: 'rickandmortyapi.com/api',
      protocol: :https,
      path: 'character',
      payload: payload
    )
  end

  def self.update(id, payload)
    post(
      url: 'rickandmortyapi.com/api',
      protocol: :https,
      path: 'character/:character_id',
      params: { character_id: id }
      payload: payload
    )
  end

  def self.destroy(id)
    delete(
      url: 'rickandmortyapi.com/api',
      protocol: :https,
      path: 'character/:character_id',
      params: { character_id: id }
    )
  end
```

### Request options

Request options are the request settings. They can be used to define services, request options and as a param when you take the HTTP request. For example:

```ruby
module RickMorty::Resource::Character
  extend Eezee::Client

  eezee_request_options protocol: :https,
                             url: 'rickandmortyapi.com/api'
                             path: 'character/:character_id'

  def self.index
    get
  end

  def self.find(id)
    get(params: { character_id: id })
  end

  def self.update(id, payload)
    put(
      params: { character_id: id },
      payload: payload,
      after: ->(_req, res) { do_something!(res) }
    )
  end
end
```

The method `eezee_request_options` can receive all of [Available Request options](#available-request-options).

When the HTTP methods were called, Eezee has created a Request setting with the options defined in the module and merge with the options passed as a param in the HTTP methods.

#### Available Request options

Here are the list of available options and about them:

| Option | Required | Default | What is it? | Example |
|--------|----------|---------|-------------|---------|
| `url` | Yes | `nil` | The request's url | `"rickandmortyapi.com/api"` |
| `protocol` | No | `nil` | The request's protocol | `:https` |
| `path` | No | `nil` | The resource's path | `"characters\:characted_id\addresses"` |
| `headers` | No | `{}` | The request's headers. | `{ Token: "Bearer 1a8then..." }` |
| `params` | No | `{}` | The query params. If the url or path has a nested param like `:character_id` and you pass it in the hash, this value will be replaced. In the opposite, the value will be concatenated in the url like `...?character_id=10&...`| `{ character_id: 10 }`|
| `payload` | No | `{}` | The request's payload | `{ name: "Linqueta", gender: "male" }` |
| `before` | No | `nil` | It's the before hook. You can pass Proc or Lambda to handle the request settings. See more in [Hooks](#hooks).  | `->(req) { merge_new_headers! }` |
| `after` | No | `nil` | It's the after hook. You can pass Proc or Lambda to handle the request settings, response or error after the request. If it returns a valid value (different of false or `nil`) and the request raises an error, the error won't be raised to your application. See more in [Hooks](#hooks). | `->(req, res, err) { do_something! }` |
| `timeout` | No | `nil` | If it exceeds this timeout to make whole request Eezee will raise the error `Eezee::TimeoutError` | `5` |
| `open_timeout` | No | `nil` | If it exceed this timeout to open a connection Eezee will raise the error `Eezee::TimeoutError` | `2` |
| `raise_error` | No | `false` | If you want that Eezee raises an error if the request has wasn't successful. See more in [Errors](#errors) | `true` |
| `logger` | No | `false` | If you want to log the request, response, and error | `true` |

### Services

It's common your app has integrations with many external services and this gem has a feature to organize in one file the settings of these external service integrations and it provides an easy way to get these settings.

For example, I will integrate with [Rick and Morty Api](https://rickandmortyapi.com/api/) using a service:

- I'll declare it in an initializer file:

```ruby
Eezee.configure do |config|
  config.add_service :rick_morty_api,
                     protocol: :https,
                     url: 'rickandmortyapi.com/api'
end
```

- In my resource, I'll catch the service and pass other settings:

```ruby
module RickMorty::Resource::Character
  extend Eezee::Client

  eezee_service :rick_morty_api
  eezee_request_options path: 'character/:character_id'

  def self.index
    get
  end

  def self.find(id)
    get(params: { character_id: id })
  end
end
```

#### How a service works

When Ruby loads a class/module and it has the method `eezee_service` declared with a service's name, by default, Eezee will try load the service and create a request base for the class/module, so, when the class/module takes a request, Eezee will create the final request instance based on request base to take the HTTP request. You can turn it lazy setting the option `lazy: true`, therefore, the final request will be created just in the HTTP request. If the service doesn't exist when Eezee search about it, it will be raised the error `Eezee::Client::UnknownServiceError`.

About the method `add_service`, you can pass all of [Available Request options](#available-request-options). The meaning of this part is to organize in one way the external services integrations.

### Request

In [Hooks](#hooks), you always receive the param request and it is an instance of `Eezee::Request`. [Available Request options](#available-request-options) are the accessors of `Eezee::Request`, just call for the name, like:

```ruby
request.protocol
# => :https

request.url
# => "rickandmortyapi.com/api"
```

### Response

In [Hooks](#hooks) and the return of the request you have an instance of `Eezee::Response`. This class can be used for successful and failed requests. Here are all methods you can call from a response:

| Name | Type | What is it? |
|------|------|-------------|
| `original` | `Faraday::Response`, `Faraday::Error`, `Faraday::TimeoutError`, `Faraday::ConnectionFailed` or `Net::ReadTimeout` | The instance that made the `Eezee::Response`. |
| `body` | `Hash` | The body response. It always is an instance of Hash (symbolized). If the response doesn't have a body response, the value will be `{}`. |
| `success?` | Boolean (`TrueClass` or `FalseClass`) | If the request had a timeout error or response has the code 400+ the value will be `false`, else, the value will be `true`. |
| `code` | `Integer` or `NilClass` | If the request had a timeout error the value will be `nil`, else, the value will be an integer. |
| `timeout?` | Boolean (`TrueClass` or `FalseClass`) | If the request had a timeout error. |

### Errors

Eezee can raise errors in some situations:
  - When the specified service is unknown
  - When the request got a timeout
  - When the request got a failure response

#### When the specified service is unknown
  - `Eezee::Client::UnknownServiceError`

#### When the request got a timeout
  - `Eezee::TimeoutError`

**Important**: This case happens just if the request option `raise_error` is `true`.

#### When the request got a failure response
  - `Eezee::RequestError` for all errors (ancestor of all below)
  - `Eezee::BadRequestError` for code equals 400
  - `Eezee::UnauthorizedError` for code equals 401
  - `Eezee::ForbiddenError` for code equals 403
  - `Eezee::ResourceNotFoundError` for code equals 404
  - `Eezee::UnprocessableEntityError` for code equals 422
  - `Eezee::ClientError` for code between 400 and 499
  - `Eezee::InternalServerError` for code equals 500
  - `Eezee::ServiceUnavailableError` for code equals 503
  - `Eezee::ServerError` for code between 500 and 599

All of `Eezee::RequestError` has the accessor `@response` with an instace of `Eezee::Response`.

**Important**: This case happens just if the request option `raise_error` is `true`.

### Examples

Here are some examples:

#### Complete integrations

Coming soon...

#### Hooks

Coming soon...

#### Timeout

Coming soon...

#### Logging

Coming soon...

## Why use Eezee instead Faraday

Coming soon...

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License][mit_license_page].

[gem_page]: https://github.com/linqueta/eezee
[code_of_conduct_page]: https://github.com/linqueta/eezee/blob/master/CODE_OF_CONDUCT.md
[mit_license_page]: https://opensource.org/licenses/MIT
[contributor_convenant_page]: http://contributor-covenant.org
[travis_status_image]: https://travis-ci.org/linqueta/eezee.svg?branch=master
[travis_page]: https://travis-ci.org/linqueta/eezee
[code_climate_maintainability_image]: https://api.codeclimate.com/v1/badges/b5ec73de9875a4675b5a/maintainability
[code_climate_maintainability_page]: https://codeclimate.com/github/linqueta/eezee/maintainability
[code_climate_test_coverage_image]: https://api.codeclimate.com/v1/badges/b5ec73de9875a4675b5a/test_coverage
[code_climate_test_coverage_page]: https://codeclimate.com/github/linqueta/eezee/test_coverage
[gem_version_image]: https://badge.fury.io/rb/eezee.svg
[gem_version_page]: https://rubygems.org/gems/eezee
