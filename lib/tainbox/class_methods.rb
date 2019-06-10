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
    name = name.to_s
    args = args.dup

    if name.end_with?('?')
      name.chop!
      type = :Boolean
    end

    definer = Tainbox::AttributeDefiner.new(self, name, type, args)
    definer.define_getter if args.fetch(:reader, true)
    definer.define_setter if args.fetch(:writer, true)
  end

  def suppress_tainbox_initializer!
    self.tainbox_initializer_suppressed = true
  end
end
