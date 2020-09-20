### [ruby koan] about_open_classes

**open class**

- ruby允许打开一个已存在的类，并添加新的方法
- 内建的类也可以打开并添加新的方法

```ruby
  class Dog
    def bark
      "WOOF"
    end
  end

  def test_as_defined_dogs_do_bark
    fido = Dog.new
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  # Open the existing Dog class and add a new method.
  class Dog
    def wag
      "HAPPY"
    end
  end

  def test_after_reopening_dogs_can_both_wag_and_bark
    fido = Dog.new
    assert_equal "HAPPY", fido.wag
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  class ::Integer
    def even?
      (self % 2) == 0
    end
  end

  def test_even_existing_built_in_classes_can_be_reopened
    assert_equal false, 1.even?
    assert_equal true, 2.even?
  end

  # NOTE: To understand why we need the :: before Integer, you need to
  # become enlightened about scope.
```

**重开Integer为什么需要写成 `::Integer`**

**指定常量的查找路径**

- ruby 默认检索常量是按照 scope 的顺序层层向外，最后才会顺着继承顺序向上查找。

- `::` 指定是从顶层开始查找，如果没有 `::` 就从当前域查找；需不需要 `::` 取决于当前域有没有同名常量

```ruby
class A1
end
class A2 < A1
end
class A3 < A2
  class B1
  end
  class B2 < B1
  end
  class B3 < B2
    class C1
    end
    class C2 < C1
    end
    class C3 < C2
      p(Const)
    end
  end
end
```

这里的 查找顺序是 C3-B3-A3-TOPLEVEL-C2-C1, 

C3 ->  B3 -> A3 -> TOPLEVEL是按照  scope 层层向外

->C2->C1  然后才是集成关系层层向上  

参考：https://www.ruby-china.org/topics/22569

