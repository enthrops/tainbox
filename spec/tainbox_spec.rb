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

  describe 'defining getter' do
    let(:person) do
      Class.new do
        include Tainbox
        attribute :name, default: 'Julyan', writer: false
      end.new
    end

    it 'read the default value' do
      expect(person.name).to eq('Julyan')
    end

    it 'does not allow to change the attribute value' do
      expect { person.name = 'Adele' }.to raise_exception(NoMethodError)
    end
  end

  describe 'defining setter' do
    let(:person) do
      Class.new do
        include Tainbox
        attribute :name, default: 'Julyan', reader: false
      end.new
    end

    it 'has the default value' do
      expect(person.send(:name)).to eq('Julyan')
    end

    it 'allows to change the attribute value' do
      person.name = 'Adele'
      expect(person.send(:name)).to eq('Adele')
    end

    describe '#attributes' do
      it "doesn't contain defined attribute" do
        expect(person.attributes).not_to have_key(:name)
      end
    end
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
