# Change log

### 1.4.1 - 2020-04-07

* improvements
  * updated dependenses
  * fixed warnings on ruby 2.7

### 1.4.0 - 2019-08-19

* features
  * add details for Esplanade::Response::Error

### 1.3.0 - 2018-03-16

* features
  * add Esplanade::Request::ContentTypeIsNotJson error
  * add reduced version message about request body

### 1.2.1 - 2018-02-20

* features
  * more information about the invalid request

### 1.2.0 - 2018-02-15

* features
  * add safe and dangerous middleware
  * add middleware for check custom response
* deprecations
  * configure
  * Esplanade::Middleware

### 1.1.2 - 2018-02-14

* fixes
  * add rewind rack.input

### 1.1.1 - 2018-02-13

* fixes
  * read body if Content-Type application/json

### 1.1.0 - 2017-10-18

* features
  * add an error Esplanade::Request::PrefixNotMatch

### 1.0.1 - 2017-10-09

* fixes
  * allow request body to be nil
