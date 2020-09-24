# Esplanade

[![Gem Version](https://badge.fury.io/rb/esplanade.svg)](https://badge.fury.io/rb/esplanade)
[![Build Status](https://travis-ci.org/funbox/esplanade.svg?branch=master)](https://travis-ci.org/funbox/esplanade)

This gem helps you to validate and synchronize your API in strict accordance to the documentation in
[API Blueprint](https://apiblueprint.org/) format.
To do this it automatically searches received requests and responses in the documentation and run
JSON-schemas validators.

## Contents

- [Installation](#installation)
- [Usage](#usage)
- [Middlewares](#middlewares)
  - [Esplanade::SafeMiddleware](#esplanadesafemiddleware)
  - [Esplanade::DangerousMiddleware](#esplanadedangerousmiddleware)
  - [Esplanade::CheckCustomResponseMiddleware](#esplanadecheckcustomresponsemiddleware)
- [Esplanade::Error](#esplanadeerror)
  - [Esplanade::Request::Error](#esplanaderequesterror)
    - [Esplanade::Request::PrefixNotMatch](#esplanaderequestprefixnotmatch)
    - [Esplanade::Request::NotDocumented](#esplanaderequestnotdocumented)
    - [Esplanade::Request::ContentTypeIsNotJson](#esplanaderequestcontenttypeisnotjson)
    - [Esplanade::Request::BodyIsNotJson](#esplanaderequestbodyisnotjson)
    - [Esplanade::Request::Invalid](#esplanaderequestinvalid)
  - [Esplanade::Response::Error](#esplanaderesponseerror)
    - [Esplanade::Response::NotDocumented](#esplanaderesponsenotdocumented)
    - [Esplanade::Response::BodyIsNotJson](#esplanaderesponsebodyisnotjson)
    - [Esplanade::Response::Invalid](#esplanaderesponseinvalid)
- [Middleware args](#middleware-args)
  - [`apib_path`](#apib_path)
  - [`drafter_yaml_path`](#drafter_yaml_path)
  - [`prefix`](#prefix)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'esplanade'
```

After that execute:

```bash
$ bundle
```

Or install the gem by yourself:

```bash
$ gem install esplanade
```

## Usage

`config/application.rb`:

```ruby
config.middleware.use Esplanade::SafeMiddleware, apib_path: 'doc.apib'
```

## Middlewares

### Esplanade::SafeMiddleware

Debug logger.

### Esplanade::DangerousMiddleware

It throws errors, so you should add your own middleware for processing.

```ruby
config.middleware.use YourMiddleware
config.middleware.use Esplanade::DangerousMiddleware, apib_path: 'doc.apib'
```

### Esplanade::CheckCustomResponseMiddleware

Use it if you want to be sure that you have documented new custom responses.

```ruby
config.middleware.use Esplanade::CheckCustomResponseMiddleware, apib_path: 'doc.apib'
config.middleware.use YourMiddleware
config.middleware.use Esplanade::DangerousMiddleware, apib_path: 'doc.apib'
```

## Esplanade::Error

Parent class for those described below.

### Esplanade::Request::Error

Parent class for those described below. Inherited from `Esplanade::Error`.

#### Esplanade::Request::PrefixNotMatch

Error message format: 

```ruby
{
  :method => "method", 
  :path => "path", 
  :content_type => "content_type"
}
```

#### Esplanade::Request::NotDocumented

Error message format:

```ruby
{
  :method => "method",
  :path => "path",
  :content_type => "content_type"
}
```

#### Esplanade::Request::ContentTypeIsNotJson

Error message format:

```ruby
{
  :method => "method",
  :path => "path",
  :content_type => "content_type"
}
```

#### Esplanade::Request::BodyIsNotJson

Throws an error also when the body is empty and equal nil.

Error message format:

```ruby
{
  :method => "method",
  :path => "path",
  :content_type => "content_type",
  :body => "body"
}
```

#### Esplanade::Request::Invalid

Error message format:

```ruby
{
  :method => "method",
  :path => "path",
  :content_type => "content_type",
  :body => "body",
  :error => ["error"]
}
```

### Esplanade::Response::Error

Parent class for those described below. Inherited from `Esplanade::Error`.

#### Esplanade::Response::NotDocumented

Error message format:

```ruby
{
  :request => {
    :method => "method",
    :path => "path"
  },
  :status => "status"
}
```

#### Esplanade::Response::BodyIsNotJson

It's thrown when expected response to request isn't JSON (not `Content-Type: application/json`) and there's no non-JSON responses documented for the endpoint.

Error message format:

```ruby
{
  :request => {
    :method => "method",
    :path => "path"
  },
  :status => "status",
  :body => "body"
}
```

#### Esplanade::Response::Invalid

Error message format:

```ruby
{
  :request => {
    :method => "method",
    :path => "path"
  },
  :status => "status",
  :body => "body",
  :error => ["error"]
}
```

## Middleware args

### `apib_path`

Path to API Blueprint documentation. There must be an installed [drafter](https://github.com/apiaryio/drafter) to parse it.

### `drafter_yaml_path`

Path to API Blueprint documentation pre-parsed with `drafter` and saved to a YAML file.

### `prefix`

Prefix for API requests. Example: `'/api'`. The prefix is added to the requests in the documentation.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![Sponsored by FunBox](https://funbox.ru/badges/sponsored_by_funbox_centered.svg)](https://funbox.ru)
