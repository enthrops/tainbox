require 'active_support/core_ext/hash/keys'

require_relative 'extensions'

module PteroVirtus::InstanceMethods

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes
    self.class.virtus_attributes.map do |attribute|
      [attribute, send(attribute)] if respond_to?(attribute, true)
    end.compact.to_h
  end

  def attributes=(attributes)
    attributes = attributes.symbolize_keys
    self.class.virtus_attributes.each do |attribute|

      if attributes.has_key?(attribute)
        method_name = "#{attribute}="
        send(method_name, attributes[attribute]) if respond_to?(method_name, true)

      else
        method_name = "virtus_set_default_#{attribute}"
        send(method_name) if respond_to?(method_name, true)
      end
    end
  end

  def attribute_provided?(attribute)
    virtus_provided_attributes.include?(attribute.to_sym)
  end
end
