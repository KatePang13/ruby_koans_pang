###  about_sandwich_code

什么是 三明治风格的代码？先来看看下面这段代码

```ruby
  def count_lines(file_name)
    file = open(file_name)
    count = 0
    while file.gets
      count += 1
    end
    count
  ensure
    file.close if file
  end

  def test_counting_lines
    assert_equal 4, count_lines("example_file.txt")
  end

  # ------------------------------------------------------------------

  def find_line(file_name)
    file = open(file_name)
    while line = file.gets
      return line if line.match(/e/)
    end
  ensure
    file.close if file
  end

  def test_finding_lines
    assert_equal "test\n", find_line("example_file.txt")
  end
```

count_lines 和 find_line 这2个函数，很相似，只有少许的差别，都是遵循三明治代码的范式。

三明治代码由三部分组成

- 第一部分，上层面包
- 第二部分，肉
- 第三部分，下层面包

上下层面包基本都是类似的，而肉部分总是在变化的

由于三明治代码变化的部分是在中间位置，对于很多语言来说，将上下层代码抽象成一个库是很困难的一件事。

对于C++来说, 一种有效的方法是将上层面包放在构造函数，将下层面包放在析构函数

原文是： Aside for C++ programmers: The idiom of capturing allocated pointers in a smart pointer constructor is an attempt to deal with the problem of sandwich code for resource allocation.

上面的代码可以将第一第三部分抽象成一个方法

```ruby
  def file_sandwich(file_name)
    file = open(file_name)
    yield(file)
  ensure
    file.close if file
  end
```

count_lines 和 find_line 就可以改写成

```ruby
  def count_lines2(file_name)
    file_sandwich(file_name) do |file|
      count = 0
      while file.gets
        count += 1
      end
      count
    end
  end

  def test_counting_lines2
    assert_equal 4, count_lines2("example_file.txt")
  end

  # ------------------------------------------------------------------

  def find_line2(file_name)
    # Rewrite find_line using the file_sandwich library function.
    file_sandwich(file_name) do |file|
      while line = file.gets
        return line if line.match(/e/)
      end
    end
  end

  def test_finding_lines2
    assert_equal "test\n", find_line2("example_file.txt")
  end
```

