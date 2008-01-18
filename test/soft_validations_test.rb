require File.dirname(__FILE__) + '/test_helper'

class Employee < ActiveRecord::Base; end
class SoftValidationsTest < Test::Unit::TestCase
  
  def setup
    Employee.send :write_inheritable_attribute, :soft_validate, nil
    assert_nil soft_validate_set
  end
  
  def soft_validate_set
    Employee.send :read_inheritable_attribute, :soft_validate
  end
  
  def test_soft_validate_with_method
    Employee.soft_validate :recommend_first_name_not_blank
    
    assert_equal 1, soft_validate_set.length
    assert_equal [:recommend_first_name_not_blank], soft_validate_set
    
    Employee.soft_validate :recommend_hire_date_not_blank
    
    assert_equal 2, soft_validate_set.length
    assert_equal [:recommend_first_name_not_blank, :recommend_hire_date_not_blank], soft_validate_set
  end
  
  def test_soft_validate_with_block
    Employee.soft_validate { |e| e.warnings.add_to_base("This is a warning!") }
    assert_equal Proc, soft_validate_set[0].class
  end
  
  def test_complete?
    e = Employee.create
    assert e.complete?
    
    Employee.soft_validate { |e| e.warnings.add_to_base("This is a warning!") }
    assert !e.complete?
  end
  
  def test_warnings
    e = Employee.create
    assert_equal 0, e.warnings.length
    
    Employee.soft_validate { |e| e.warnings.add_to_base("This is a warning!") }
    e.complete?
    assert_equal 1, e.warnings.length
    assert_equal "This is a warning!", e.warnings.on(:base)
  end  
  
  def test_soft_validate_with_method_recommend_first_name_not_blank
    Employee.soft_validate(:recommend_first_name_not_blank)
  
    e = Employee.create(:last_name => "Gahan")
    e.instance_eval do
      def recommend_first_name_not_blank
        warnings.add(:first_name, "shouldn't be blank") unless attribute_present?(:first_name)
      end
    end
  
    assert e.valid?, "Should be valid"
    assert !e.complete?, "Shouldn't be complete"
    assert_equal "shouldn't be blank", e.warnings.on(:first_name)
  
    e.first_name = "Dave"
    assert e.complete?, "Should be complete"
  end
  
  def test_soft_validate_with_block_should_have_something
    Employee.soft_validate do |e|
      e.warnings.add_to_base("Should have something") if !e.attribute_present?(:last_name) && !e.attribute_present?(:first_name)
    end
  
    e = Employee.create
    assert e.valid?, "Should be valid"
    assert !e.complete?, "Shouldn't be complete"
    assert_equal "Should have something", e.warnings.on(:base)
  
    e.last_name = "Gahan"
    assert e.complete?, "Should be complete"
  end
end
