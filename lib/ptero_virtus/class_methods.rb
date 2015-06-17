require_relative 'attribute_definer'

module PteroVirtus::ClassMethods

  attr_writer :virtus_writable_attributes
  attr_writer :virtus_readable_attributes

  def inherited(subclass)
    subclass.virtus_writable_attributes = virtus_writable_attributes.dup
    subclass.virtus_readable_attributes = virtus_readable_attributes.dup
  end

  def virtus_writable_attributes
    @virtus_writable_attributes ||= []
  end
  
  def virtus_readable_attributes
    @virtus_readable_attributes ||= []
  end

  private

  def attribute(name, type = nil, **args)
    args = args.dup
    readonly, writeonly = args.delete(:writeonly), args.delete(:readonly)
    definer = PteroVirtus::AttributeDefiner.new(self, name, type, args)
    definer.define_getter unless writeonly
    definer.define_setter unless readonly
  end
end
