module PteroVirtus

  def self.included(klass)
    klass.extend(PteroVirtus::ClassMethods)
    klass.include(PteroVirtus::InstanceMethods)
  end

  def self.define_converter(type, &block)
    PteroVirtus::TypeConverter.define_converter(type, block)
  end
end

require_relative 'ptero_virtus/class_methods'
require_relative 'ptero_virtus/instance_methods'
require_relative 'ptero_virtus/type_converter'
