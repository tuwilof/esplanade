# Esplanade

<a href="https://funbox.ru">
  <img src="https://funbox.ru/badges/sponsored_by_funbox.svg" alt="Sponsored by FunBox" width=250 />
</a>

[![Gem Version](https://badge.fury.io/rb/esplanade.svg)](https://badge.fury.io/rb/esplanade)
[![Build Status](https://travis-ci.org/funbox/esplanade.svg?branch=master)](https://travis-ci.org/funbox/esplanade)

This gem will help you validation and sinhronize your API in strict accordance to the documentation in
[API Blueprint](https://apiblueprint.org/) format.
To do this it automatically searches received requestes and responses in the documentation and run validates
json-schemas.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'esplanade'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install esplanade

## Usage

Example:

`middlewares/your_middleware.rb`

```ruby
class YourMiddleware < Esplanade::Middleware
  def call(env)
    request = Esplanade::Request.new(@documentation, env)
    request.validation.valid!

    status, headers, body = @app.call(env)

    response = Esplanade::Response.new(request, status, body)
    response.validation.valid!

    [status, headers, body]
  rescue Esplanade::Error => e
    your_render_error(e)
  end
end
```

`config/application.rb`

```ruby
require 'esplanade'
Esplanade.configure do |config|
  config.apib_path = 'doc/backend.apib'
end

require_relative '../middlewares/your_middleware'
config.middleware.use YourMiddleware
```

## Esplanade::Error

From him the `Esplanade::Request::Error` and `Esplanade::Response::Error` are inherited.

### Esplanade::Request::Error

From him the `Esplanade::Request::PrefixNotMatch`, `Esplanade::Request::NotDocumented`, `Esplanade::Request::BodyIsNotJson` and `Esplanade::Request::Invalid` are inherited.

#### Esplanade::Request::PrefixNotMatch

Error message: `{:method=>"method", :path=>"path"}`.

#### Esplanade::Request::NotDocumented

Error message: `{:method=>"method", :path=>"path"}`.

#### Esplanade::Request::BodyIsNotJson

Only if the documentation for this request indicates that `Content-Type: application/json`.

Error message: `{:method=>"method", :path=>"path", :body=>"{\"state\": 1"}`.

#### Esplanade::Request::Invalid

Error message: `{:method=>"method", :path=>"path", :body=>"body", :error=>["error"]}`.

### Esplanade::Response::Error

From him the `Esplanade::Response::NotDocumented`, `Esplanade::Response::BodyIsNotJson` and `Esplanade::Response::Invalid` are inherited.

#### Esplanade::Response::NotDocumented

Error message: `{:request=>{:method=>"method", :path=>"path"}, :status=>"status"}`.

#### Esplanade::Response::BodyIsNotJson

Only if the documentation for all the responses of one request indicates that `Content-Type: application/json`.

Error message: `{:request=>{:method=>"method", :path=>"path"}, :status=>"status", :body=>"body"}`.

#### Esplanade::Response::Invalid

Error message: `{:request=>{:method=>"method", :path=>"path"}, :status=>"status", :body=>"body", :error=>["error"]}`.

## Config

### apib_path

Path to API Blueprint documentation. There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### drafter_yaml_path

Path to API Blueprint documentation pre-parsed with `drafter` and saved to a YAML file.

### prefix

Prefix of API requests. Example: `'/api'`. The prefix is added to the requests in the documentation.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
