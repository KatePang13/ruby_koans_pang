##  Learn Ruby with the edgecase ruby koans about_methods

http://www.rubykoans.com/

https://github.com/KatePang13/ruby_koans_pang.git

**函数声明**

```ruby
def my_global_method(a,b)
  a + b
end
```

**函数调用**

```ruby
#calling_global_methods  调用 全局方法
my_global_method(2,3)
#calling_global_methods_without_parentheses  不使用括号调用全局方法
result = my_global_method 2, 3
# 不带括号的调用方式会引入混淆，只能用于赋值给变量的情况，如下的场景只能带括号来调用
eval "assert_equal 5, my_global_method(2, 3)"
```

**带变量初始值的函数**

```ruby
  def method_with_defaults(a, b=:default_value)
    [a, b]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end
```

**使用`args`的函数**

`args` 是一个 `Array` 对象，用于函数的不定长参数列表

```ruby
  def method_with_var_args(*args)
    args
  end

  def test_calling_with_variable_arguments
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal [:one, :two], method_with_var_args(:one, :two)
  end
```

**显示返回值和隐式返回值**

```ruby
  # ------------------------------------------------------------------

  def method_with_explicit_return
    :a_non_return_value
    return :return_value
    :another_non_return_value
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end

  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end
```

**类内调用方法**

- 对于 非 private 方法，可以 使用 self 作为方法接收者，也可以省略
- 对于 private 方法，不能使用 self 作为方法接收者

```ruby
  def my_method_in_the_same_class(a, b)
    a * b
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3,4)
  end

  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, self.my_method_in_the_same_class(3,4)
  end
```

```ruby
  def my_private_method
    "a secret"
  end
  private :my_private_method

  def test_calling_private_methods_without_receiver
    assert_equal "a secret", my_private_method
  end

  if before_ruby_version("2.7")   # https://github.com/edgecase/ruby_koans/issues/12
    def test_calling_private_methods_with_an_explicit_receiver
      exception = assert_raise(NoMethodError) do
        self.my_private_method
      end
      assert_match /private method `my_private_method' called for/, exception.message
    end
  end
```

**调用其他类的方法**

- 调用其他类的 非 private 方法 ，必须使用 对象作为方法接收者
- 禁止调用其他类的 private 方法

```ruby
  class Dog
    def name
      "Fido"
    end

    private

    def tail
      "tail"
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal "Fido", rover.name
  end

  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end
  end
end
```

