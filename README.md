# Esplanade

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

## Config

### apib_path

Path to API Blueprint documentation. There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### drafter_yaml_path

Path to API Blueprint documentation pre-parsed with `drafter` and saved to a YAML file.

### prefix

Prefix of API requests. Example: `'/api'`. The prefix is added to the requests in the documentation.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
