# Esplanade

[![Build Status](https://travis-ci.org/funbox/esplanade.svg?branch=master)](https://travis-ci.org/funbox/esplanade)

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

config/application.rb

```ruby
require 'esplanade'
config.middleware.use YourMiddleware
```

Example:
```ruby
class YourMiddleware < Esplanade::Middleware
  def call(env)
    request = Esplanade::Request.new(env, @tomogram)
    check_request(request)
    status, headers, body = @app.call(env)
    response = Esplanade::Response.new(status, body, request)
    check_response(response)
    [status, headers, body]
  end

  def check_request(request)
    return not_documented_request(request) unless request.documented?
    invalid_request(request) unless request.valid?
  end

  def check_response(response)
    return unless response.request.documented?
    return not_documented_response(response) unless response.documented?
    invalid_response(response) unless response.valid?
  end
end
```

## Config

### apib_path

Path to API Blueprint documentation. There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### drafter_yaml_path

Path to API Blueprint documentation pre-parsed with `drafter` and saved to a YAML file.

### prefix

Prefix of API requests. Example: `'/api'`. Validation will not be performed if the request path does not start with a prefix.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
