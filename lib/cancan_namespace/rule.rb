module CanCanNamespace
  # This class is used internally and should only be called through Ability.
  # it holds the information about a "can" call made on Ability and provides
  # helpful methods to determine permission checking and conditions hash generation.
  class Rule < ::CanCan::Rule
    # The first argument when initializing is the base_behavior which is a true/false
    # value. True for "can" and false for "cannot". The next two arguments are the action
    # and subject respectively (such as :read, @project). The third argument is a hash
    # of conditions and the last one is the block passed to the "can" call.
    def initialize(base_behavior, action, subject, conditions, block)
      super
      @contexts = has_conditions? && @conditions.has_key?(:context) ? [@conditions.delete(:context)].flatten.map(&:to_s) : []
    end
    
    def has_conditions?
      !conditions_empty? && @conditions.kind_of?(Hash)
    end
    
    # Matches both the subject and action, not necessarily the conditions
    def relevant?(action, subject, context = nil)
      subject = subject.values.first if subject.kind_of? Hash
      @match_all || (matches_action?(action) && matches_subject?(subject) && matches_context(context))
    end
    
    def matches_context(context)
      (context.nil? && @contexts.empty?) || (context && @contexts.include?(context.to_s))
    end
  end
end
