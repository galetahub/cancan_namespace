require 'cancan'
require 'cancan_namespace/ability'
require 'cancan_namespace/rule'
require 'cancan_namespace/controller_resource'
require 'cancan_namespace/controller_additions'
require 'cancan_namespace/model_additions'
require 'cancan_namespace/version'

require 'cancan_namespace/model_adapters/active_record_adapter' if defined? ActiveRecord
