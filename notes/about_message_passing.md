### [ruby koan] about_message_passing  消息传递

**向对象发送消息**

当你给一个对象发消息时，对象从 它的方法查询表 [method lookup path](http://phrogz.net/RubyLibs/RubyMethodLookupFlow.pdf)  中查找第一个名字匹配的方法，并执行该方法；

如果未找到匹配的方法

- 产生 `NoMethodError ` 异常；

- 除非你为对象提供了 `method_missing` 方法；`method_missing` 接收 三个参数：
  - 未定义方法的 symbol
  - 原始调用的参数列表 args
  - 传递给原始调用的任意代码块  block

`method_missing` 在某种程度上是一个安全层  ：它为您提供了一种拦截无法响应的消息并优雅地处理它们的方法。

```ruby
class Dummy  
  def method_missing(m, *args, &block)  
    puts "There's no method called #{m} here -- please try again."  
  end  
end  
Dummy.new.anything
```

```shell
>ruby p012zmm.rb  
There's no method called anything here -- please try again.  
>Exit code: 0  
```

Reference:   http://rubylearning.com/satishtalim/ruby_method_missing.html

**类方法的2种调用方式**

- 直接调用
- 发送消息调用
  - 发消息调用的好处是，可以更动态地生成要调用的方法名
  - 两个方法： `send(msg)`  和 `__send__(msg)`
    - 为什么ruby要定义2个方法：因为很多类会自定义 send, 第二个方法备不时之需
  - 与直接调用是等价的
    - 可以传递参数
    - 未定义时，也报错  `NoMethodError`
  - respond_to?(:methodName) 查询是否支持响应methodName

```ruby
class MessageCatcher
    def caught?
      true
    end
  end

  mc = MessageCatcher.new
  
  #直接调用
  mc.caught?
  #发消息调用
  mc.send(:caught?)
  # 发消息调用的灵活使用示例:
  mc.send("caught?")
  mc.send("caught" + "?" )
  mc.send("CAUGHT?".downcase ) 
```

**消息捕获**

- 重写 `method_missing(method_name, *args, &block)`  捕获发给本对象的送来消息
  - 所有消息都会被 `method_missing` 捕获
  - 可以 使用 if  else super(...) 对部分消息做处理
- 注意：如果  `method_missing`  产生 NoMethodError，会陷入无限递归

```ruby
class AllMessageCatcher
    def method_missing(method_name, *args, &block)
      "Someone called #{method_name} with <#{args.join(", ")}>"
    end
  end

  # 所有的消息都能被捕捉
  def test_all_messages_are_caught
    catcher = AllMessageCatcher.new

    assert_equal "Someone called foobar with <>", catcher.foobar
    assert_equal "Someone called foobaz with <1>", catcher.foobaz(1)
    assert_equal "Someone called sum with <1, 2, 3, 4, 5, 6>", catcher.sum(1,2,3,4,5,6)
  end

  # 捕捉消息，制造  respond_to 谎言
  def test_catching_messages_makes_respond_to_lie
    catcher = AllMessageCatcher.new

    assert_nothing_raised do
      catcher.any_method
    end
    assert_equal false, catcher.respond_to?(:any_method)
  end
```

```ruby
# 捕捉 以foo为前缀 的 消息
  # 不是 以foo为前缀的消息，照常判断，不存在则报 NoMethodError
  class WellBehavedFooCatcher
    def method_missing(method_name, *args, &block)
      if method_name.to_s[0,3] == "foo"
        "Foo to you too"
      else
        super(method_name, *args, &block)
      end
    end
  end

  def test_foo_method_are_caught
    catcher = WellBehavedFooCatcher.new

    assert_equal "Foo to you too", catcher.foo_bar
    assert_equal "Foo to you too", catcher.foo_baz
  end

  def test_non_foo_messages_are_treated_normally
    catcher = WellBehavedFooCatcher.new

    assert_raise(NoMethodError) do
      catcher.normal_undefined_method
    end
  end
```

