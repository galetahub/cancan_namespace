# encoding: utf-8
module CancanNamespace
  module Version
    MAJOR = 0
    MINOR = 2
    RELEASE = 0

    def self.dup
      "#{MAJOR}.#{MINOR}.#{RELEASE}"
    end
  end
end
