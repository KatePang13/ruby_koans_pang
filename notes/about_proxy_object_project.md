### [ruby koan] about_proxy_object_project  对象代理

#### 前置知识

ruby类方法的调用有2种方式，假设obj的类有一个方法 method()

- obj.method()           直接方法调用，常规情况下使用
- obj.send(:method) 发送消息，当需要在运行时灵活地构造方法名时使用
- 当消息(方法)未定义时，可以使用 method_missing 进行捕获并优雅地处理。

#### 目标

实现一个对象代理类 Proxy

- 可以使用任意的对象来初始化 Proxy Object
- 任意发送给 Proxy Object 的消息都会转发给目标对象(被代理的对象)
- Proxy 要记录每个消息发送的次数

#### 细节

- 需要添加一个 method_missing ,用以 捕获消息 并 转发
- 需要支持的其他方法
  - messages  获取 已接收到的消息列表
  - called?(msg)    查询某个消息是否发送过
  - number_of_times_called(msg) 查询某个消息被调用的次数



实现

```ruby
class Proxy
  def initialize(object)
    @object = object
    @msgMap = {}
    @msgMap.default = 0
  end

  def messages
    @msgMap.keys
  end

  def called?(msg)
    @msgMap.keys.include?(msg)
  end

  def number_of_times_called(msg)
    @msgMap[msg]
  end

  def method_missing(msg, *args, &block)
    # 累计捕获到的消息，并记录次数
    @msgMap[msg] += 1
    # 消息转发给 @object  
    @object.send(msg, *args, &block)
  end
end
```

