module CanCanNamespace
  module ControllerAdditions
    def can?(*args)
      super(*inject_context(args))
    end

    def cannot?(*args)
      super(*inject_context(args))
    end

    def get_context
      modules = params[:controller].sub("Controller", "").underscore.split('/')
      if modules.size > 1
        modules[0..-2].map(&:singularize).join('__')
      else
        return nil
      end
    end

    private

    def inject_context(args)
      args[2] ||= {}
      args[2].reverse_merge!(context: get_context) if args[2].kind_of?(Hash)
      args
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include CanCanNamespace::ControllerAdditions
  end
end
