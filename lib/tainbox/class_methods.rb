require_relative 'attribute_definer'
require_relative 'extensions'

module Tainbox::ClassMethods

  def inherited(subclass)
    subclass.tainbox_attributes = tainbox_attributes.dup
    subclass.tainbox_initializer_suppressed = tainbox_initializer_suppressed
  end

  def tainbox_initializer_suppressed?
    !!tainbox_initializer_suppressed
  end

  protected

  attr_writer :tainbox_initializer_suppressed

  private

  attr_reader :tainbox_initializer_suppressed

  def attribute(name, type = nil, **args)
    args = args.dup
    readonly, writeonly = args.delete(:readonly), args.delete(:writeonly)
    definer = Tainbox::AttributeDefiner.new(self, name, type, args)
    definer.define_getter unless writeonly
    definer.define_setter unless readonly
  end

  def suppress_tainbox_initializer!
    self.tainbox_initializer_suppressed = true
  end
end
