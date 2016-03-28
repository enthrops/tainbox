require 'spec_helper'

describe Tainbox do

  Person = Class.new do
    include Tainbox
    attribute :name, default: 'Oliver'
    attribute :age, Integer

    def name
      super.strip
    end
  end

  it 'works' do
    person = Person.new(name: ' John ', 'age' => '24')
    expect(person.name).to eq('John')
    expect(person.age).to eq(24)
    expect(person.attribute_provided?(:name)).to be_truthy
    expect(person.attribute_provided?(:age)).to be_truthy

    person.attributes = {}
    expect(person.name).to eq('Oliver')
    expect(person.age).to be_nil
    expect(person.attribute_provided?(:name)).to be_truthy
    expect(person.attribute_provided?(:age)).to be_falsey

    expect(person.attributes).to eq(name: 'Oliver', age: nil)

    person.age = 10
    expect(person.age).to eq(10)
    expect(person.attribute_provided?(:age)).to be_truthy

    expect(person.as_json).to eq('name' => 'Oliver', 'age' => 10)
  end
end
