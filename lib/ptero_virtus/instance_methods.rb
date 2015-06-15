module PteroVirtus::InstanceMethods

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes=(attributes)
    attributes.each do |attribute, value|
      attribute = attribute.to_sym
      method_name = "#{attribute}="
      virtus_setter = self.class.virtus_writable_attributes.include?(attribute.to_sym)
      public_send(method_name, value) if virtus_setter && respond_to?(method_name)
    end
  end
end
