# Esplanade

This gem helps you validate the request and response documentation API Blueprint.


If the request to the server will be invalid tomogram, it will return a response with a 400 status and the body of the error.
If the server's response will be invalid tomogram, it will return a response with 500 status and the body of the error.

An example of an error body

```ruby
{
  "error": [
      "The property '#/' did not contain a required property of 'login' in schema deee53ed-f917-5f2f-bccf-0b8af3b749c7",
      "The property '#/' did not contain a required property of 'password' in schema deee53ed-f917-5f2f-bccf-0b8af3b749c7"
    ]
}
```

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

### Rails

config/application.rb

```ruby
require 'esplanade'
```

### Rake

config/application.rb

```ruby
require 'esplanade'
config.middleware.use Esplanade::Middleware
```

## Config

### tomogram

This gem takes a simplified format json convert from API Blueprint which we have called API Tomogram.

If in your project you are using the gem tomograph, then define the configuration you are not required.

```ruby
Esplanade.configure do |config|
  config.tomogram = 'tomogram.json'
end
```

### skip_not_documented

Default true.

### validation_requests

Default true.

### validation_response

Default true.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
