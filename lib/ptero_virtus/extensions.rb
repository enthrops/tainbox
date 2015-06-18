class Class

  attr_writer :virtus_attributes

  def virtus_layer
    unless @virtus_layer
      @virtus_layer = Module.new
      include(@virtus_layer)
    end
    @virtus_layer
  end

  def virtus_attributes
    @virtus_attributes ||= []
  end

  def virtus_register_attribute(attribute)
    virtus_attributes << attribute
    virtus_attributes.uniq!
  end
end

class Object

  private

  def virtus_provided_attributes
    @virtus_provided_attributes ||= []
  end

  def virtus_register_attribute_provided(attribute)
    virtus_provided_attributes << attribute
    virtus_provided_attributes.uniq!
  end
end
