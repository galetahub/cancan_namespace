module CanCanNamespace
  # Handle the load and authorization controller logic so we don't clutter up all controllers with non-interface methods.
  # This class is used internally, so you do not need to call methods directly on it.
  module ControllerResource # :nodoc:
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :extend,  ClassMethods
    end
    
    module ClassMethods
      def self.extended(base)
        base.class_eval do
          alias_method :authorize_resource, :authorize_resource_with_context
        end
      end
    end
    
    module InstanceMethods
      def authorize_resource_with_context
        unless skip?(:authorize)
          options = { :context => module_from_controller }
          @controller.authorize!(authorization_action, resource_instance || resource_class_with_parent, options)
        end
      end
      
      private
      
        def module_from_controller
          modules = @params[:controller].sub("Controller", "").underscore.split('/')
          if modules.size > 1
            modules.first.singularize
          else
            return nil
          end
        end
    end
  end
end

if defined? CanCan::ControllerResource
  CanCan::ControllerResource.send(:include, CanCanNamespace::ControllerResource)
end
