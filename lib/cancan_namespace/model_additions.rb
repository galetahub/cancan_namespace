module CanCanNamespace
  module ModelAdditions
    module ClassMethods
      def accessible_by(ability, action = :index, context = nil)
        ability.model_adapter(self, action, context).database_records
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
