# Changelog

## 0.2.4

* Fix bug where `:readonly` behaved as `:writeonly` and vice versa

## 0.2.5

* `suppress_tainbox_initializer!` is inherited correctly

## 0.2.6

* raise `ArgumentError` if trying to assign a non-hash to `#attributes`

## 0.2.7

* Attribute is always set to nil and marked as not provided when the hash assigned via
`#attributes=` or `#new` does not have that attribute and the attribute does not have a default

## 0.2.8

* Prepend internal variables with 'tainbox\_' to avoid clashes with client code

## 0.3.0

* String converter supports `strip` option to strip values

## 1.0.0

* `as_json` support for tainbox objects

## 1.0.1

* `as_json` implementation does not use `to_hash` to
avoid automatic casting from double star parameters

## 1.1.0

* String converter supports `downcase` option to downcase values

## 1.2.0

* Attributes can be assigned via any object which responds to `to_h`

## 2.0.0

* Replace `readonly` and `writeonly` options with `reader` and `writer` options for better
semantics

## 2.1.0

* Add `patch_attributes` method

## 2.1.1

* Fix `Time` converter
