class PteroVirtus::AttributeDefiner

  def initialize(klass, attribute, type, args)
    @klass = klass
    @attribute = attribute.to_sym
    @type = type
    @args = args
    @layer = Module.new
    @klass.include(@layer)
  end

  def define_getter
    attribute = @attribute
    layer.instance_eval do
      define_method(attribute) do
        instance_variable_get(:"@#{attribute}")
      end
    end
  end

  def define_setter
    klass.virtus_writable_attributes ||= []
    klass.virtus_writable_attributes << @attribute
    klass.virtus_writable_attributes.uniq!

    attribute = @attribute
    layer.instance_eval do
      define_method("#{attribute}=") do |value|
        instance_variable_set(:"@#{attribute}", value)
      end
    end
  end

  private

  attr_reader :layer
  attr_reader :klass
end
