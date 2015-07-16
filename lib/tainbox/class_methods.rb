require_relative 'attribute_definer'
require_relative 'extensions'

module Tainbox::ClassMethods

  def inherited(subclass)
    subclass.tainbox_attributes = tainbox_attributes.dup
  end

  def tainbox_initializer_suppressed?
    !!tainbox_initializer_suppressed
  end

  private

  attr_accessor :tainbox_initializer_suppressed

  def attribute(name, type = nil, **args)
    args = args.dup
    readonly, writeonly = args.delete(:writeonly), args.delete(:readonly)
    definer = Tainbox::AttributeDefiner.new(self, name, type, args)
    definer.define_getter unless writeonly
    definer.define_setter unless readonly
  end

  def suppress_tainbox_initializer!
    self.tainbox_initializer_suppressed = true
  end
end
