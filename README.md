# [Katinguele][gem_page]

[![Gem Version][gem_version_image]][gem_version_page]
[![Build Status][travis_status_image]][travis_page]
[![Maintainability][code_climate_maintainability_image]][code_climate_maintainability_page]
[![Test Coverage][code_climate_test_coverage_image]][code_climate_test_coverage_page]

The easiest HTTP client for Ruby

With Katinguele you can do these things:
  * Define external services in an initializer file and use them through a simple method
  * Take HTTP requests just extending a module and call the HTTP request method in your class/module
  * Set before and after hooks to handle your requests, responses, and errors
  * Handle all requests, responses, and errors in the same way
  * Log the request, response, and errors
  * Set general request timeout and open connection timeout
  * Raise errors in failed requests
  * Spend more time coding your API integrations instead defining and testing HTTP settings and clients


## Table of Contents
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Supported HTTP Methods](#supported-http-methods)
  - [How to take a request](#how-to-take-a-request)
  - [Request options](#request-options)
    - [Available Request options](#available-request-options)
  - [Services](#services)
    - [How a service works](#how-a-service-works)
  - [Request](#response)
  - [Response](#response)
  - [Errors](#errors)
  - [Examples](#examples)
    - [Complete integrations](#complete-integrations)
    - [Hooks](#hooks)
    - [Timeout](#timeout)
    - [Logging](#logging)
- [Why use it instead Faraday](#why-use-it-instead-faraday)
- [Contributing](#contributing)
- [License](#license)

## Getting started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'katinguele'
```

If you're on Rails you can run this line below to create the initializer:

```shell
rails generator katinguele:install
```

### Supported HTTP Methods

Katinguele supports these HTTP methods:

- GET
- POST
- PATCH
- PUT
- DELETE

And here are the corresponding Katinguele's HTTP methods:

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
  extend Katinguele::Client

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
  extend Katinguele::Client

  katinguele_request_options protocol: :https,
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

The method `katinguele_request_options` can receive all of [Available Request options](#available-request-options).

When the HTTP methods were called, Katinguele has created a Request setting with the options defined in the module and merge with the options passed as a param in the HTTP methods.

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
| `timeout` | No | `nil` | If it exceeds this timeout to make whole request Katinguele will raise the error `Katinguele::TimeoutError` | `5` |
| `open_timeout` | No | `nil` | If it exceed this timeout to open a connection Katinguele will raise the error `Katinguele::TimeoutError` | `2` |
| `raise_error` | No | `false` | If you want that Katinguele raises an error if the request has wasn't successful. See more in [Errors](#errors) | `true` |
| `logger` | No | `false` | If you want to log the request, response, and error | `true` |

### Services

It's common your app has integrations with many external services and this gem has a feature to organize in one file the settings of these external service integrations and it provides an easy way to get these settings.

For example, I will integrate with [Rick and Morty Api](https://rickandmortyapi.com/api/) using a service:

- I'll declare it in an initializer file:

```ruby
Katinguele.configure do |config|
  config.add_service :rick_morty_api,
                     protocol: :https,
                     url: 'rickandmortyapi.com/api'
end
```

- In my resource, I'll catch the service and pass other settings:

```ruby
module RickMorty::Resource::Character
  extend Katinguele::Client

  katinguele_service :rick_morty_api
  katinguele_request_options path: 'character/:character_id'

  def self.index
    get
  end

  def self.find(id)
    get(params: { character_id: id })
  end
end
```

#### How a service works

When Ruby loads a class/module and it has the method `katinguele_service` declared with a service's name, by default, Katinguele will try load the service and create a request base for the class/module, so, when the class/module takes a request, Katinguele will create the final request instance based on request base to take the HTTP request. You can turn it lazy setting the option `lazy: true`, therefore, the final request will be created just in the HTTP request. If the service doesn't exist when Katinguele search about it, it will be raised the error `Katinguele::Client::UnknownService`.

About the method `add_service`, you can pass all of [Available Request options](#available-request-options). The meaning of this part is to organize in one way the external services integrations.

### Request

Coming soon...

### Response

Coming soon...

### Errors

Coming soon...

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

## Why use it instead Faraday

Coming soon...

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License][mit_license_page].

[gem_page]: https://github.com/linqueta/katinguele
[code_of_conduct_page]: https://github.com/linqueta/katinguele/blob/master/CODE_OF_CONDUCT.md
[mit_license_page]: https://opensource.org/licenses/MIT
[contributor_convenant_page]: http://contributor-covenant.org
[travis_status_image]: https://travis-ci.org/linqueta/katinguele.svg?branch=master
[travis_page]: https://travis-ci.org/linqueta/katinguele
[code_climate_maintainability_image]: https://api.codeclimate.com/v1/badges/b3ae18295c290b6a92a9/maintainability
[code_climate_maintainability_page]: https://codeclimate.com/github/linqueta/katinguele/maintainability
[code_climate_test_coverage_image]: https://api.codeclimate.com/v1/badges/b3ae18295c290b6a92a9/test_coverage
[code_climate_test_coverage_page]: https://codeclimate.com/github/linqueta/katinguele/test_coverage
[gem_version_image]: https://badge.fury.io/rb/katinguele.svg
[gem_version_page]: https://rubygems.org/gems/katinguele
