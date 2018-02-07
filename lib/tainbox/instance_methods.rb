require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/json'

require_relative 'extensions'

module Tainbox::InstanceMethods

  def initialize(*args)
    if self.class.tainbox_initializer_suppressed?
      super
    else
      attributes = (args.length >= 1) ? args.first : {}
      self.attributes = attributes
    end
  end

  def attributes
    self.class.tainbox_attributes.map do |attribute|
      [attribute, send(attribute)] if respond_to?(attribute, true)
    end.compact.to_h
  end

  def attributes=(attributes)
    if attributes.respond_to?(:to_h)
      attributes = attributes.to_h
    else
      raise ArgumentError, 'Attributes can only be assigned via objects which respond to #to_h'
    end

    attributes = attributes.symbolize_keys
    self.class.tainbox_attributes.each do |attribute|

      if attributes.has_key?(attribute)
        method_name = "#{attribute}="
        send(method_name, attributes[attribute]) if respond_to?(method_name, true)

      else
        method_name = "tainbox_set_default_#{attribute}"
        send(method_name) if respond_to?(method_name, true)
      end
    end
  end

  def attribute_provided?(attribute)
    tainbox_provided_attributes.include?(attribute.to_sym)
  end

  def patch_attributes(attributes)
    if attributes.respond_to?(:to_h)
      attributes.to_h.slice(*self.class.tainbox_attributes).each do |key, value|
        send("#{key}=", value) if respond_to?(key)
      end
    else
      raise ArgumentError, 'Attributes can only be assigned via objects which respond to #to_h'
    end
  end

  def as_json(*args)
    attributes.as_json(*args)
  end
end
