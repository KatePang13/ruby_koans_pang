require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutMessagePassing < Neo::Koan

  class MessageCatcher
    def caught?
      true
    end
  end

  # 方法可以直接调用
  def test_methods_can_be_called_directly
    mc = MessageCatcher.new

    assert mc.caught?
  end

  # 也可以用发送消息的方式调用
  def test_methods_can_be_invoked_by_sending_the_message
    mc = MessageCatcher.new

    assert mc.send(:caught?)
  end

  # 使用发送消息的方式，可以更灵活地调用方法（使用字符串拼接方法名）
  def test_methods_can_be_invoked_more_dynamically
    mc = MessageCatcher.new

    assert mc.send("caught?")
    assert mc.send("caught" + "?" )    # What do you need to add to the first string?
    assert mc.send("CAUGHT?".downcase )      # What would you need to do to the string?
  end
  # send()  __send__()  都可以发送消息
  def test_send_with_underscores_will_also_send_messages
    mc = MessageCatcher.new

    assert_equal true, mc.__send__(:caught?)

    # THINK ABOUT IT:
    #
    # Why does Ruby provide both send and __send__ ?
    # Reference: https://stackoverflow.com/questions/4658269/ruby-send-vs-send
    # 一些类可能会定义自己的send, __send__ 以备不时之需;
  end

  # 可以 查询 class 是否支持 响应某个消息  obj.respend_to?(:msg)
  def test_classes_can_be_asked_if_they_know_how_to_respond
    mc = MessageCatcher.new

    # MessageCatcher 定义了 caught? 方法，没有定义  does_not_exist 方法
    assert_equal true, mc.respond_to?(:caught?)
    assert_equal false, mc.respond_to?(:does_not_exist)
  end

  # ------------------------------------------------------------------

  class MessageCatcher
    def add_a_payload(*args)
      args
    end
  end

  # 发送 带参数 的 message ; 等价于 带参数调用 方法
  def test_sending_a_message_with_arguments
    mc = MessageCatcher.new

    assert_equal [], mc.add_a_payload
    assert_equal [], mc.send(:add_a_payload)

    assert_equal [3, 4, nil, 6], mc.add_a_payload(3, 4, nil, 6)
    assert_equal [3, 4, nil, 6], mc.send(:add_a_payload, 3, 4, nil, 6)
  end

  # NOTE:
  #
  # Both obj.msg and obj.send(:msg) sends the message named :msg to
  # the object. We use "send" when the name of the message can vary
  # dynamically (e.g. calculated at run time), but by far the most
  # common way of sending a message is just to say: obj.msg.
  # bj.msg和obj.send（：msg）都将名为：msg的消息发送到对象。
  # 消息名称需要在运行的时候生成的情况下，使用 obj.send(:msg)
  # 正常情况下，请使用 bj.msg

  # ------------------------------------------------------------------

  class TypicalObject
  end

  # 给一个 对象 发送未定义的 消息，相当于调用未定义的方法， 报错  NoMethodError
  def test_sending_undefined_messages_to_a_typical_object_results_in_errors
    typical = TypicalObject.new

    exception = assert_raise(NoMethodError) do
      typical.foobar
    end
    assert_match(/foobar/, exception.message)
  end

  def test_calling_method_missing_causes_the_no_method_error
    typical = TypicalObject.new

    exception = assert_raise(NoMethodError) do
      typical.method_missing(:foobar)
    end
    assert_match(/foobar/, exception.message)

    # THINK ABOUT IT:
    #
    # If the method :method_missing causes the NoMethodError, then
    # what would happen if we redefine method_missing?
    # 当 :method_missing方法 产生NoMethodError 时，将陷入无限递归
    # Reference: https://joromir.eu/blog/2019/11/27/method-missing-explained/
    # NOTE:
    #
    # In Ruby 1.8 the method_missing method is public and can be
    # called as shown above. However, in Ruby 1.9 (and later versions)
    # the method_missing method is private. We explicitly made it
    # public in the testing framework so this example works in both
    # versions of Ruby. Just keep in mind you can't call
    # method_missing like that after Ruby 1.9 normally.
    # method_missing 在 Ruby 1.9 之前是 public， 1.9 开始 是 private
    # 本工程中做了处理，所有版本都可以使用method_missing, 现实开发中需要注意;
    #
    # Thanks.  We now return you to your regularly scheduled Ruby
    # Koans.
  end

  # ------------------------------------------------------------------

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

  # ------------------------------------------------------------------
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

  # ------------------------------------------------------------------

  # (note: just reopening class from above)
  # 这里 重开了 class WellBehavedFooCatcher
  # 对 foo为前缀的消息，respond_to? true,即支持响应
  # 其他消息，照常判断
  class WellBehavedFooCatcher
    def respond_to?(method_name)
      if method_name.to_s[0,3] == "foo"
        true
      else
        super(method_name)
      end
    end
  end

  def test_explicitly_implementing_respond_to_lets_objects_tell_the_truth
    catcher = WellBehavedFooCatcher.new

    assert_equal true, catcher.respond_to?(:foo_bar)
    assert_equal false, catcher.respond_to?(:something_else)
  end

end
