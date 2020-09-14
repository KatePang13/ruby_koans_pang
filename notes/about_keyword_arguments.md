## about_keyword_arguments

**键值对参数**

- 方法中用键来访问对应的参数，参数可以有缺省值
- 没有缺省值的参数，必须传参，否则会抛出 `ArgumentError`

```ruby
  def method_with_keyword_arguments(one: 1, two: 'two')
    [one, two]
  end

  def test_keyword_arguments
    assert_equal Array, method_with_keyword_arguments.class
    assert_equal [1, 'two'], method_with_keyword_arguments
    assert_equal ['one','two'], method_with_keyword_arguments(one: 'one')
    assert_equal [1, 2], method_with_keyword_arguments(two: 2)
  end

  def method_with_keyword_arguments_with_mandatory_argument(one, two: 2, three: 3)
    [one, two, three]
  end

  def test_keyword_arguments_with_wrong_number_of_arguments
    exception = assert_raise (ArgumentError) do
      method_with_keyword_arguments_with_mandatory_argument
    end
    assert_match(/given 0, expected 1/, exception.message)
  end
```

**[Think about it] Keyword arguments always have a default value, making them optional to the caller**

建议所有的 keyword 参数 都有缺省值，对调用者来说，这些参数就是可选的



