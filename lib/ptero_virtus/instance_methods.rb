module PteroVirtus::InstanceMethods

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes=(attributes)
    self.class.virtus_writable_attributes.each do |attribute|
      given = attributes.has_key?(attribute) || attributes.has_key?(attribute.to_s)

      if given
        value = attributes[attribute] || attributes[attribute.to_s]
        method_name = "#{attribute}="
        public_send(method_name, value) if respond_to?(method_name)

      else
        method_name = "set_virtus_default_#{attribute}"
        public_send(method_name) if respond_to?(method_name)
      end
    end
  end
end
