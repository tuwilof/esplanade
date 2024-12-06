# Change log

### 1.8.3 - 2024-12-06

* patch
  * fix the non-json check of the request body if the schema is less than one
  * delete homepage for fix

### 1.8.2 - 2024-04-03

* patch
  * change home page

### 1.8.1 - 2023-10-06

* patch
  * add home page

### 1.8.0 - 2021-09-29

* patch
  * remove multi_json

### 1.7.1 - 2021-02-10

* setting
  * improve gemspec dependency for tomograph

### 1.7.0 - 2020-12-22

* improvements
  * changed middleware arguments

### 1.6.0 - 2020-10-12

* features
  * in the errors write not only a documented path but also a raw [#11](https://github.com/funbox/esplanade/issues/11)
  * write in the documentation that the body is empty and nil is skipped [#13](https://github.com/funbox/esplanade/issues/13)
  * redefine error PrefixNotMatch for response [#17](https://github.com/funbox/esplanade/issues/17)
  * content-type can contain additional parameters [#21](https://github.com/funbox/esplanade/issues/21)
  * update esplanade for the new tomograph [#29](https://github.com/funbox/esplanade/issues/29)

### 1.5.0 - 2020-04-07

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
