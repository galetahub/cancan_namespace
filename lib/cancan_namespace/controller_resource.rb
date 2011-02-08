module CanCanNamespace
  # Handle the load and authorization controller logic so we don't clutter up all controllers with non-interface methods.
  # This class is used internally, so you do not need to call methods directly on it.
  module ControllerResource # :nodoc:
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :extend,  ClassMethods
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def authorize_resource
        unless skip?(:authorize)
          options = { :context => module_from_controller }
          @controller.authorize!(authorization_action, resource_instance || resource_class_with_parent, options)
        end
      end
      
      private
      
        def module_from_controller
          @params[:controller].sub("Controller", "").underscore.split('/').first.singularize
        end
    end
  end
end

if defined? CanCan::ControllerResource
  CanCan::ControllerResource.class_eval do
    include CanCanNamespace::ControllerResource
  end
end
