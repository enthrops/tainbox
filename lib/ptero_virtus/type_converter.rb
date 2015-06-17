require 'active_support/values/time_zone'

class PteroVirtus::TypeConverter

  def self.define_converter(type, block)
    method_name = conversion_method_name_for(type)
    raise "Converter for #{type} already exists" if instance_methods.include?(method_name)
    define_method(method_name, block)
  end

  def self.conversion_method_name_for(type)
    "convert_to_#{type.to_s.downcase}".to_sym
  end

  def initialize(type, value, options: {})
    @type = type
    @value = value
    @options = options
  end

  def convert
    method_name = self.class.conversion_method_name_for(type)
    raise "Type not supported: #{type}" unless respond_to?(method_name)
    send(method_name)
  end

  private

  attr_reader :type
  attr_reader :value
  attr_reader :options
end

PteroVirtus.define_converter(Integer) do
  Integer(value) rescue nil
end

PteroVirtus.define_converter(Float) do
  Float(value) rescue nil
end

PteroVirtus.define_converter(String) do
  value.to_s
end

PteroVirtus.define_converter(Symbol) do
  value.to_sym rescue nil
end

PteroVirtus.define_converter(Time) do
  value.is_a?(Time) ? value : (Time.zone.parse(value) rescue nil)
end

PteroVirtus.define_converter(:Boolean) do
  strict = options.fetch(:strict, true)
  if !strict && %w(true on 1).include?(value)
    true
  elsif !strict && %w(false off 0).include?(value)
    false
  else
    !!value
  end
end
