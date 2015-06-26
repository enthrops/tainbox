module Tainbox

  def self.included(klass)
    klass.extend(Tainbox::ClassMethods)
    klass.include(Tainbox::InstanceMethods)
  end

  def self.define_converter(type, &block)
    Tainbox::TypeConverter.define_converter(type, block)
  end
end

require_relative 'tainbox/class_methods'
require_relative 'tainbox/instance_methods'
require_relative 'tainbox/type_converter'
