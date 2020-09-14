## [ruby koans] about_condition_statements  条件语句

**if-else 语句用作值**

- 所有的ruby 语句都会返回一个值，ruby 也不例外
- 如果没有分支会执行到，返回的值为 `nil`

---

注：编程语言在 statement 上分为两个阵营，

- 一方将语句分成 **Statement**  ， **Expression**， C/C++, java, python 等大多数主流语言均属于这个阵营

  -   Statement 没有返回值，是一系列的行为描述
  - Expression  有返回值

- 另一方认为  Statement  和 Expression 是没有区别的，比如ruby，

  [composingprograms](http://composingprograms.com/pages/11-getting-started.html)  对这个概念有相关描述，composingprograms 是一个根据 [SICP](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book.html) 改编的课程，SICP 是基于 Lisp ，  composingprograms 是基于 python 

SICP的相关资料：

https://mitpress.mit.edu/sicp/ 

https://github.com/DeathKing/Learning-SICP 

[Structure and Interpretation of Computer Programs, 2e: Top](https://sarabander.github.io/sicp/html/index.xhtml)

[OCW-6-001-structure-and-interpretation-of-computer-programs-spring-2005](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/)

---



```ruby
    value = if false
              :true_value
            else
              :false_value
            end
    assert_equal :false_value, value

    # NOTE: Actually, EVERY statement in Ruby will return a value, not
    # just if statements.
	
	def test_if_statements_with_no_else_with_false_condition_return_value
    value = if false
              :true_value
            end
    assert_equal nil, value
  end
```

**if语句修饰符(if statement modifiers)**

```ruby
  def test_if_statement_modifiers
    result = :default_value
    result = :true_value if true

    assert_equal :true_value, result
  end
```

**unless 语句**

`unless` 也可以用作修饰符，与if类似，只是对条件判断取反

```ruby
  def test_unless_statement
    result = :default_value
    unless false    # same as saying 'if !false', which evaluates as 'if true'
      result = :false_value
    end
    assert_equal :false_value, result
  end

  def test_unless_statement_evaluate_true
    result = :default_value
    unless true    # same as saying 'if !true', which evaluates as 'if false'
      result = :true_value
    end
    assert_equal :default_value, result
  end

  def test_unless_statement_modifier
    result = :default_value
    result = :false_value unless false

    assert_equal :false_value, result
  end
```

**break 语句**

break 语句同样可以返回值

```ruby
  def test_break_statement
    i = 1
    result = 1
    while true
      break unless i <= 10
      result = result * i
      i += 1
    end
    assert_equal 3628800, result
  end

  def test_break_statement_returns_values
    i = 1
    result = while i <= 10
      break i if i % 2 == 0
      i += 1
    end

    assert_equal 2, result
  end
```

**next语句**

- 相当于  C语言中的  `continue` ,表示在循环中跳过这一次
- `next if (condition)` 表示 当条件成立时，跳过这一次

```ruby
  def test_next_statement
    i = 0
    result = []
    while i < 10
      i += 1
      next if (i % 2) == 0
      result << i
    end
    assert_equal [1,3,5,7,9], result
  end
```

**times语句**

 `n*times do something end` 表示动作执行n次

```ruby
  def test_times_statement
    sum = 0
    10.times do
      sum += 1
    end
    assert_equal 10, sum
  end
```



