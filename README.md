# Tainbox

Tainbox is a utility gem that can be used to inject attributes into ruby objects. It is similar to <a href="https://github.com/solnic/virtus">Virtus</a>, but works a bit more sensibly (hopefully) and throws in some additional features.

## But we already have attr_accessor!

Consider this code:

``` ruby
class Person
  include Tainbox
  attribute :name, default: -> { "person_#{age}" }
  attribute :age, Integer, default: 20
end
```

Here are the basic features you get:

``` ruby
person = Person.new(name: 'John', age: '30')
person.attributes # => { :name => "John", :age => 30 }
person.age = 50
person.age # => 50
person.attributes = {}
person.attributes # => { :name => "person_20", :age => 20 }
```

## Additional features

### Method overrides

Tainbox attributes can be freely overriden:

``` ruby
def name
  super.strip
end
```

``` ruby
def name=(value)
  super('Stupid example')
end
```

### #attribute_provided?

Attribute is considered provided if its setter was explicitly invoked via a setter, `.new`, or `#attributes=` or it has a default value.

``` ruby
class Person
  include Tainbox
  attribute :name, default: 'John'
  attribute :age
end

person = Person.new
person.attribute_provided?(:age) # => false
person.attribute_provided?(:name) # => true
```

### readonly and writeonly attributes

Speaks for itself:

``` ruby
class Person
  include Tainbox
  attribute :name, writeonly: true
  attribute :age, readonly: true
end
```

### Built-in type converters

All converters return nil if conversion could not be made.

- Integer
- Float
- String
- Symbol
- Time
- Boolean

### Custom type converters

You can define a custom type converter like so:

``` ruby
# value and options are automatically available in scope
Tainbox.define_converter(MyType) do
  # Do whatever you want with value
  options[:strict] ? MyType.convert!(value) : MyType.convert(value)
end
```
