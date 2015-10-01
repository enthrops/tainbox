class Class

  attr_writer :tainbox_attributes

  def tainbox_layer
    unless @tainbox_layer
      @tainbox_layer = Module.new
      include(@tainbox_layer)
    end
    @tainbox_layer
  end

  def tainbox_attributes
    @tainbox_attributes ||= []
  end

  def tainbox_register_attribute(attribute)
    tainbox_attributes << attribute
    tainbox_attributes.uniq!
  end
end

class Object

  private

  def tainbox_provided_attributes
    @tainbox_provided_attributes ||= []
  end

  def tainbox_register_attribute_provided(attribute)
    tainbox_provided_attributes << attribute
    tainbox_provided_attributes.uniq!
  end

  def tainbox_unregister_attribute_provided(attribute)
    tainbox_provided_attributes.delete(attribute)
  end
end
