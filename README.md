# Esplanade

[![Build Status](https://travis-ci.org/funbox/esplanade.svg?branch=master)](https://travis-ci.org/funbox/esplanade)

This gem will help you validation your API in strict accordance to the documentation in
[API Blueprint](https://apiblueprint.org/) format.
To do this, when you run your application, it automatically searches for the corresponding json-schemas in the
documentation and then validates requests and responses with them.

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

For example, analysis using a [Sentry](https://sentry.io/).

`middlewares/sentry_esplanade_middleware.rb`

```ruby
class SentryEsplanadeMiddleware < Esplanade::Middleware
  def call(env)
    status, headers, body = @app.call(env)
    sentry(Esplanade::Response.new(Esplanade::Request.new(@documentation, env), status, body))
    [status, headers, body]
  end

  def sentry(response)
    response.request.validation.valid!
    response.validation.valid!
  rescue Esplanade::Error => e
    Raven.capture_exception(e)
  end
end
```

`config/application.rb`

```ruby
require 'esplanade'

Esplanade.configure do |config|
  config.apib_path = 'doc/backend.apib'
end

require 'middlewares/sentry_esplanade_middleware'
config.middleware.use SentryEsplanadeMiddleware
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
