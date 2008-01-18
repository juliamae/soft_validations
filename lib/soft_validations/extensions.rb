module SoftValidations
  module Validations
    def self.included(base)
      base.extend ClassMethods
    end
  
    # Returns true if there are no messages in the warnings collection. 
    def complete?
      warnings.clear
      run_validations :soft_validate
      warnings.empty?
    end
  
    # Returns the warnings collection, an instance of Errors. The warnings collection is a
    # different object than the errors collection. However, you can interact with the warnings 
    # collection in the same way that you interact with errors. For example:
    # 
    #   employee.warnings.on(:first_name)
    # 
    # A record can have errors and return false for valid? and yet
    # at the same time have no warnings and return true for complete?. 
    def warnings
      @warnings ||= ActiveRecord::Errors.new(self)
    end
  
    module ClassMethods
    
      # Adds a soft_validation method or block to the class. This provides a
      # descriptive declaration of the object's desired state in order to be  
      # considered complete. The methods or block passed to 
      # soft_validate should add a message to the class's warning collection.
      #
      # Example with a symbol pointing to a method:
      #
      #   class Employee < ActiveRecord::Base
      #     soft_validate :should_have_first_name
      #
      #     def should_have_first_name
      #       warnings.add(:first_name, "shouldn't be blank") unless attribute_present?(:first_name)
      #     end
      #   end
      #
      # Or with a block:
      #
      #   class Employee < ActiveRecord::Base
      #     soft_validate do |e|
      #       e.warnings.add(:first_name, "shouldn't be blank") unless e.attribute_present?(:first_name)
      #     end
      #   end
      def soft_validate(*methods, &block)
        methods << block if block_given?
        write_inheritable_set(:soft_validate, methods)
      end
    end
  end
end