require 'virtus'
#require 'virtus_extensions/deep_hash'
#require 'virtus_extensions/updater'

module ModelExtensions
  def self.included base
    base.send :extend,  ActiveModel::Naming
    base.send :include, ActiveModel::Conversion
    base.send :include, ActiveModel::Serializers::JSON
    base.send :include, ActiveModel::Validations
    base.send :include, ActiveModel::SerializerSupport
    base.send :include, Virtus.model
    #base.send :include, VirtusExtensions::Updater
    #base.send :include, VirtusExtensions::DeepHash
    base.send :include, InstanceMethods
  end

  module InstanceMethods
  end
end