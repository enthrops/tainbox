module PteroVirtus::InstanceMethods

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes
    self.class.virtus_readable_attributes.map do |attribute|
      [attribute, send(attribute)] if respond_to?(attribute, true)
    end.compact.to_h
  end

  def attributes=(attributes)
    self.class.virtus_writable_attributes.each do |attribute|
      given = attributes.has_key?(attribute) || attributes.has_key?(attribute.to_s)

      if given
        value = attributes[attribute] || attributes[attribute.to_s]
        method_name = "#{attribute}="
        send(method_name, value) if respond_to?(method_name, true)

      else
        method_name = "set_virtus_default_#{attribute}"
        send(method_name) if respond_to?(method_name, true)
      end
    end
  end
end
