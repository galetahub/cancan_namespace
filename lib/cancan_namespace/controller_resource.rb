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
          alias_method :load_collection?, :load_collection_with_context?
          alias_method :load_collection, :load_collection_with_context
        end
      end
    end
    
    module InstanceMethods
      def authorize_resource_with_context
        unless skip?(:authorize)
          options = { :context => (@options[:context] || module_from_controller) }
          @controller.authorize!(authorization_action, resource_instance || resource_class_with_parent, options)
        end
      end

      protected

      def load_collection_with_context?
        resource_base.respond_to?(:accessible_by) && !current_ability.has_block?(authorization_action, resource_class, @options[:context] || module_from_controller)
      end

      def load_collection_with_context
        resource_base.accessible_by(current_ability, authorization_action, @options[:context] || module_from_controller)
      end
      
      private
      
        def module_from_controller
          modules = @params[:controller].sub("Controller", "").underscore.split('/')
          if modules.size > 1
            modules[0..-2].map(&:singularize).join('__')
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
