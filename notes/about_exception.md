### [ruby koan] about_exception

**exception 继承体系**

- MySpecialError < RuntimeError < StandardError < Exception < Object

```ruby
  class MySpecialError < RuntimeError
  end
  # MySpecialError < RuntimeError < StandardError < Exception < Object
  def test_exceptions_inherit_from_Exception
    assert_equal RuntimeError, MySpecialError.ancestors[1]
    assert_equal StandardError, MySpecialError.ancestors[2]
    assert_equal Exception, MySpecialError.ancestors[3]
    assert_equal Object, MySpecialError.ancestors[4]
  end
```

**exception使用示例**

- 产生异常
  - `fail  exMsg`
  - `raise exType, exMsg`
- 捕获异常
  - `rescue exType=> ex`
    - `ex.is_a?(StandardError)`
    - `ex.message`
- 总会执行的代码段
  - `ensure`

```ruby
  def test_rescue_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result

    assert_equal true, ex.is_a?(StandardError), "Should be a Standard Error"
    assert_equal true, ex.is_a?(RuntimeError),  "Should be a Runtime Error"

    assert RuntimeError.ancestors.include?(StandardError),
      "RuntimeError is a subclass of StandardError"

    assert_equal "Oops", ex.message
  end

  def test_raising_a_particular_error
    result = nil
    begin
      # 'raise' and 'fail' are synonyms
      raise MySpecialError, "My Message"
    rescue MySpecialError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result
    assert_equal "My Message", ex.message
  end

  def test_ensure_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError
      # no code here
    ensure
      result = :always_run
    end

    assert_equal :always_run, result
  end

  # Sometimes, we must know about the unknown
  def test_asserting_an_error_is_raised
    # A do-end is a block, a topic to explore more later
    assert_raise(MySpecialError) do
      raise MySpecialError.new("New instances can be raised directly.")
    end
  end
```

