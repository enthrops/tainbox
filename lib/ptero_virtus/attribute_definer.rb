require 'active_support/core_ext/object/deep_dup'

require_relative 'type_converter'
require_relative 'class_extensions'

class PteroVirtus::AttributeDefiner

  def initialize(klass, attribute_name, requested_type, args)
    @klass = klass
    @attribute_name = attribute_name.to_sym
    @requested_type = requested_type
    @args = args

    if klass.virtus_layer
      @layer = klass.virtus_layer
    else
      @layer = Module.new
      klass.include(layer)
    end
  end

  def define_getter
    attribute = attribute_name
    layer.instance_eval do
      define_method(attribute) do
        instance_variable_get(:"@#{attribute}")
      end
    end
  end

  def define_setter
    klass.virtus_writable_attributes << attribute_name
    klass.virtus_writable_attributes.uniq!

    attribute = attribute_name
    default = args[:default]
    type = requested_type

    layer.instance_eval do
      
      define_method("#{attribute}=") do |value|
        value = PteroVirtus::TypeConverter.new(type, value).convert if type && !value.nil?
        instance_variable_set(:"@#{attribute}", value)
      end

      define_method("set_virtus_default_#{attribute}") do
        instance_variable_set(:"@#{attribute}", default.deep_dup)
      end
    end
  end

  private

  attr_reader :klass
  attr_reader :attribute_name
  attr_reader :requested_type
  attr_reader :args
  attr_reader :layer
  attr_reader :args
end
