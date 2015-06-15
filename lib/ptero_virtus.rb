module PteroVirtus

  def self.included(klass)
    klass.extend(PteroVirtus::ClassMethods)
    klass.include(PteroVirtus::InstanceMethods)
  end
end

require_relative 'ptero_virtus/class_methods'
require_relative 'ptero_virtus/instance_methods'
