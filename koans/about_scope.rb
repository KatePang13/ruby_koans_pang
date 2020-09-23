require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutScope < Neo::Koan
  module Jims
    class Dog
      def identify
        :jims_dog
      end
    end
  end

  module Joes
    class Dog
      def identify
        :joes_dog
      end
    end
  end

  def test_dog_is_not_available_in_the_current_scope
    assert_raise(NameError) do
      Dog.new
    end
  end

  def test_you_can_reference_nested_classes_using_the_scope_operator
    fido = Jims::Dog.new
    rover = Joes::Dog.new
    assert_equal :jims_dog, fido.identify
    assert_equal :joes_dog, rover.identify

    assert_equal true, fido.class != rover.class
    assert_equal true, Jims::Dog != Joes::Dog
  end

  # ------------------------------------------------------------------

  class String
  end

  # ClassName, 默认为当前 scope 的定义
  def test_bare_bones_class_names_assume_the_current_scope
    assert_equal true, AboutScope::String == String
  end

  # ClassName, 默认为当前 scope 的定义
  # "HI", 是一个 系统自建的 String 实例
  def test_nested_string_is_not_the_same_as_the_system_string
    assert_equal false, String == "HI".class
  end

  # ::ClassName,指定为 全局 scope
  def test_use_the_prefix_scope_operator_to_force_the_global_scope
    assert_equal true, ::String == "HI".class
  end

  # ------------------------------------------------------------------

  PI = 3.1416

  # 常量 定义为 首字母大写的名字
  def test_constants_are_defined_with_an_initial_uppercase_letter
    assert_equal 3.1416, PI
  end

  # ------------------------------------------------------------------

  MyString = ::String

  # ClassName 就是 常量
  def test_class_names_are_just_constants
    assert_equal true, MyString == ::String
    assert_equal true, MyString == "HI".class
  end

  # 常量可以显式地查找  scope.const_get(strName)
  def test_constants_can_be_looked_up_explicitly
    assert_equal true, PI == AboutScope.const_get("PI")
    assert_equal true, MyString == AboutScope.const_get("MyString")
  end

  # 可以获取 指定类或模块的 常量列表
  def test_you_can_get_a_list_of_constants_for_any_class_or_module
    assert_equal [:Dog], Jims.constants
    assert Object.constants.size > 1
  end
end
