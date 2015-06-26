require 'active_support/core_ext/hash/keys'

require_relative 'extensions'

module Tainbox::InstanceMethods

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes
    self.class.tainbox_attributes.map do |attribute|
      [attribute, send(attribute)] if respond_to?(attribute, true)
    end.compact.to_h
  end

  # TODO Reset attributes that are missing in parameter hash
  def attributes=(attributes)
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
end
