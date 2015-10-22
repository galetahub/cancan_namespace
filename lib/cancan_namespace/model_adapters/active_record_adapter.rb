ActiveRecord::Base.class_eval do
  include CanCanNamespace::ModelAdditions
end
