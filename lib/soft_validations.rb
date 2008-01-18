require File.dirname(__FILE__) + '/soft_validations/extensions'

class ActiveRecord::Base
  include SoftValidations::Validations
end