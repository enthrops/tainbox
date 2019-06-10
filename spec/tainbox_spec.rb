require 'spec_helper'

describe Tainbox do

  it 'works' do

    person = Class.new do
      include Tainbox

      attribute :name, default: 'Anonymous'
      attribute :age, Integer
      attribute :admin?, default: false

      def name
        super.strip
      end
    end

    person = person.new(name: ' John ', 'age' => '24', 'admin' => '1')

    expect(person.name).to eq('John')
    expect(person.attribute_provided?(:name)).to be_truthy

    expect(person.age).to eq(24)
    expect(person.attribute_provided?(:age)).to be_truthy

    expect(person.admin).to eq(true)
    expect(person.admin?).to eq(true)
    expect(person.attribute_provided?(:admin)).to be_truthy

    expect(person.attributes).to eq(name: 'John', age: 24, admin: true)
    expect(person.as_json).to eq('name' => 'John', 'age' => 24, 'admin' => true)

    person.attributes = {}

    expect(person.name).to eq('Anonymous')
    expect(person.attribute_provided?(:name)).to be_truthy

    expect(person.age).to be_nil
    expect(person.attribute_provided?(:age)).to be_falsey

    expect(person.admin).to eq(false)
    expect(person.admin?).to eq(false)
    expect(person.attribute_provided?(:admin)).to be_truthy

    expect(person.attributes).to eq(name: 'Anonymous', age: nil, admin: false)
    expect(person.as_json).to eq('name' => 'Anonymous', 'age' => nil, 'admin' => false)

    person.age = 10

    expect(person.age).to eq(10)
    expect(person.attribute_provided?(:age)).to be_truthy

    expect(person.admin!).to eq(person)

    expect(person.admin).to eq(true)
    expect(person.admin?).to eq(true)
    expect(person.attribute_provided?(:admin)).to be_truthy

    person.name = ' John '

    expect(person.name).to eq('John')
    expect(person.attribute_provided?(:name)).to be_truthy

    expect(person.as_json).to eq('name' => 'John', 'age' => 10, 'admin' => true)
    expect(person.as_json(only: :name)).to eq('name' => 'John')
    expect(person.as_json(except: :name)).to eq('age' => 10, 'admin' => true)
  end

  it 'supports old syntax' do
    person = Class.new do
      include Tainbox

      attribute :admin, :Boolean
    end

    person = person.new('admin' => '1')

    expect(person.admin).to eq(true)
    expect(person.attribute_provided?(:admin)).to be_truthy

    expect(person.attributes).to eq(admin: true)
    expect(person.as_json).to eq('admin' => true)

    person.attributes = {}

    expect(person.admin).to eq(nil)
    expect(person.attribute_provided?(:admin)).to be_falsey

    expect(person.attributes).to eq(admin: nil)
    expect(person.as_json).to eq('admin' => nil)

    person.admin = true

    expect(person.admin).to eq(true)
    expect(person.admin?).to eq(true)
    expect(person.attribute_provided?(:admin)).to be_truthy
  end

  it 'accepts objects which respond to #to_h as attributes' do

    person = Class.new do
      include Tainbox
      attribute :name, default: 'Oliver'
      attribute :age, Integer

      def name
        super.strip
      end
    end

    expect(person.new(name: 'John').name).to eq('John')
    expect(person.new([[:name, 'John']]).name).to eq('John')
    expect(person.new(nil).name).to eq('Oliver')

    exception = 'Attributes can only be assigned via objects which respond to #to_h'
    expect { person.new('Hello world') }.to raise_exception(ArgumentError, exception)
  end

  describe 'string converter options' do

    describe 'no options' do
      let(:person) do
        Class.new do
          include Tainbox
          attribute :name, String
        end
      end

      specify 'no value given' do
        expect(person.new.name).to be_nil
      end

      specify 'nil given' do
        expect(person.new(name: nil).name).to eq('')
      end

      specify 'string given' do
        expect(person.new(name: ' Hello ').name).to eq(' Hello ')
      end
    end

    describe 'strip' do
      let(:person) do
        Class.new do
          include Tainbox
          attribute :name, String, strip: true
        end
      end

      specify 'no value given' do
        expect(person.new.name).to be_nil
      end

      specify 'nil given' do
        expect(person.new(name: nil).name).to eq('')
      end

      specify 'string given' do
        expect(person.new(name: ' Hello ').name).to eq('Hello')
      end
    end

    describe 'downcase' do
      let(:person) do
        Class.new do
          include Tainbox
          attribute :name, String, downcase: true
        end
      end

      specify 'no value given' do
        expect(person.new.name).to be_nil
      end

      specify 'nil given' do
        expect(person.new(name: nil).name).to eq('')
      end

      specify 'string given' do
        expect(person.new(name: ' Hello ').name).to eq(' hello ')
      end
    end

    describe 'strip and downcase' do
      let(:person) do
        Class.new do
          include Tainbox
          attribute :name, String, strip: true, downcase: true
        end
      end

      specify 'no value given' do
        expect(person.new.name).to be_nil
      end

      specify 'nil given' do
        expect(person.new(name: nil).name).to eq('')
      end

      specify 'string given' do
        expect(person.new(name: ' Hello ').name).to eq('hello')
      end
    end
  end

  describe 'patching params' do
    let(:person) do
      Class.new do
        include Tainbox

        attribute :name, default: 'Oliver'
        attribute :age, Integer

        def name
          super.strip
        end
      end
    end

    let(:attributes) { Hash[name: 'John'] }

    it 'changes only provided attributes' do
      oliver = person.new(age: 21)
      expect { oliver.patch_attributes(attributes) }.not_to change { oliver.age }
      expect(oliver.name).to eq('John')
    end
  end
end
