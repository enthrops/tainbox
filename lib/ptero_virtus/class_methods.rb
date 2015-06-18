require_relative 'attribute_definer'
require_relative 'extensions'

module PteroVirtus::ClassMethods

  def inherited(subclass)
    subclass.virtus_attributes = virtus_attributes.dup
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
