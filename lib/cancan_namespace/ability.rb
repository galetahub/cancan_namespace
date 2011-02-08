module CanCanNamespace

  # This module is designed to be included into an Ability class. This will
  # provide the "can" methods for defining and checking abilities.
  #
  #   class Ability
  #     include CanCan::Ability
  #
  #     def initialize(user)
  #       if user.admin?
  #         can :manage, :all
  #       else
  #         can :read, :all
  #       end
  #     end
  #   end
  #
  module Ability
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :extend,  ClassMethods
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def can?(action, subject, *extra_args)
        context = nil
        if extra_args.last.kind_of?(Hash) && extra_args.last.has_key?(:context)
          context = extra_args.pop[:context]
        end
        
        match = relevant_rules_for_match(action, subject, context).detect do |rule|
          rule.matches_conditions?(action, subject, extra_args)
        end
        match ? match.base_behavior : false
      end
      
      private
      
        # Returns an array of Rule instances which match the action and subject
        # This does not take into consideration any hash conditions or block statements
        def relevant_rules(action, subject, context = nil)
          rules.reverse.select do |rule|
            rule.expanded_actions = expand_actions(rule.actions)
            rule.relevant? action, subject, context
          end
        end
      
        def relevant_rules_for_match(action, subject, context = nil)
          relevant_rules(action, subject, context).each do |rule|
            if rule.only_raw_sql?
              raise Error, "The can? and cannot? call cannot be used with a raw sql 'can' definition. The checking code cannot be determined for #{action.inspect} #{subject.inspect}"
            end
          end
        end
    end
    
  end
end

if defined? CanCan::Ability
  CanCan::Ability.class_eval do
    include CanCanNamespace::Ability
  end
end
