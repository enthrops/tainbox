require 'active_support/core_ext/object/deep_dup'

require_relative 'type_converter'
require_relative 'extensions'

class Tainbox::AttributeDefiner

  def initialize(klass, attribute_name, requested_type, requested_args)
    @klass = klass
    @attribute_name = attribute_name.to_sym
    @requested_type = requested_type
    @requested_args = requested_args
  end

  def define_getter
    klass.tainbox_register_attribute(attribute_name)
    attribute = attribute_name

    klass.tainbox_layer.instance_eval do
      define_method(attribute) do
        instance_variable_get(:"@#{attribute}")
      end
    end
  end

  def define_setter
    klass.tainbox_register_attribute(attribute_name)

    attribute = attribute_name
    args = requested_args
    type = requested_type

    klass.tainbox_layer.instance_eval do

      define_method("#{attribute}=") do |value|
        tainbox_register_attribute_provided(attribute)
        value = Tainbox::TypeConverter.new(type, value, options: args).convert if type
        instance_variable_set(:"@#{attribute}", value)
      end

      define_method("tainbox_set_default_#{attribute}") do
        if args.has_key?(:default)
          tainbox_register_attribute_provided(attribute)
          instance_variable_set(:"@#{attribute}", args[:default].deep_dup)
        end
      end
    end
  end

  private

  attr_reader :klass
  attr_reader :attribute_name
  attr_reader :requested_type
  attr_reader :requested_args
end
