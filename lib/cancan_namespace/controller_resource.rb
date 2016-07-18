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
          alias_method :initial_attributes, :initial_attributes_with_context
        end
      end
    end
    
    module InstanceMethods
      def authorize_resource_with_context
        unless skip?(:authorize)
          @controller.authorize!(authorization_action, resource_instance || resource_class_with_parent, context: context)
        end
      end

      protected

      def load_collection_with_context?
        resource_base.respond_to?(:accessible_by) && !current_ability.has_block?(authorization_action, resource_class, context)
      end

      def load_collection_with_context
        resource_base.accessible_by(current_ability, authorization_action, context)
      end

      def initial_attributes_with_context
        current_ability.attributes_for(@params[:action].to_sym, resource_class, context).delete_if do |key, value|
          resource_params && resource_params.include?(key)
        end
      end

      def context
        @options.fetch(:context, @controller.get_context)
      end
    end
  end
end

if defined? CanCan::ControllerResource
  CanCan::ControllerResource.send(:include, CanCanNamespace::ControllerResource)
end
