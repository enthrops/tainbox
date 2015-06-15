require_relative 'attribute_definer'

module PteroVirtus::ClassMethods

  attr_accessor :virtus_writable_attributes

  private

  def attribute(name, type = nil, **args)
    args = args.dup
    readonly, writeonly = args.delete(:writeonly), args.delete(:readonly)
    definer = PteroVirtus::AttributeDefiner.new(self, name, type, args)
    definer.define_getter unless writeonly
    definer.define_setter unless readonly
  end
end
