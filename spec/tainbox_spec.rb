require 'spec_helper'

describe Tainbox do

  it 'works' do

    person = Class.new do
      include Tainbox
      attribute :name, default: 'Oliver'
      attribute :age, Integer

      def name
        super.strip
      end
    end

    person = person.new(name: ' John ', 'age' => '24')
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
    expect(person.as_json(only: :name)).to eq('name' => 'Oliver')
    expect(person.as_json(except: :name)).to eq('age' => 10)
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
end
