## [ruby koans] about_constants  常量

http://www.rubykoans.com/

https://github.com/KatePang13/ruby_koans_pang.git

**对同名常量的访问**

- 内层常量会屏蔽外层常量
- 可以通过 `::constantName` 来强制访问 外层 常量
- 可以通过 `className::constantName` 来强制访问某个类中的常量

```ruby
C = "top level"

class AboutConstants < Neo::Koan

  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal "nested", C
  end

  def test_top_level_constants_are_referenced_by_double_colons
    assert_equal "top level", ::C
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal "nested", AboutConstants::C
    assert_equal "nested", ::AboutConstants::C
  end
```

**常量的继承**

- 嵌套类可继承外层类的常量
- 子类可继承父类的常量
- **当词法范围和继承层次有同名常量时，以哪个为准？**
  - 参考：https://stackoverflow.com/questions/5464811/ruby-koans-explicit-scoping-on-a-class-definition-part-2
  - 在代码注释中给出了参考的解释

```ruby
  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end
```



```ruby
  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal 4, Reptile.new.legs_in_reptile
  end
```



```ruby
  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?
#在定义Oyster时，您已经进入了MyAnimals的范围，因此ruby知道LEGS指的是MyAnimals :: LEGS（2）而不是Animal :: LEGS

  # ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?
#当您定义MyAnimals :: Oyster时，您仍处于全局scope内，因此ruby不了解MyAnimals中将LEGS值设置为2的知识，因为您实际上从未处于MyAnimals的scope内
end
```

