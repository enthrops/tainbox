require 'spec_helper'

describe Tainbox do

  Person = Class.new do
    include Tainbox
    attribute :name
    attribute :age, Integer
  end

  it 'works' do
    person = Person.new(name: 'John', 'age' => '24')
    expect(person.name).to eq('John')
    expect(person.age).to eq(24)
  end
end
