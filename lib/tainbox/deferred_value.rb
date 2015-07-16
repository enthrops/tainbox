class Tainbox::DeferredValue

  attr_reader :proc

  def initialize(proc)
    @proc = proc
  end
end
