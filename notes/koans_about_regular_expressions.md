# koans_about_regular_expressions

**Regexp  是 ruby 的一个类**, 声明形式是  `/pattern/`

```ruby
assert_equal Regexp, /pattern/.class
```

**Regexp的 基本用法**   `"text"[/pattern/]`

1. 匹配成功，返回匹配到的字符串
2. 匹配失败，返回nil

```ruby
assert_equal "match", "some matching content"[/match/]
```

```ruby
assert_equal nil, "some matching content"[/missing/]
```

**正则表达式特殊符号**

1. `?` 表示可选
2. `+` 表示一个或多个
3. `*`表示零个或多个

```ruby
  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/]
    assert_equal "a", "abbcccddddeeeee"[/az?/]
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/]
```

**[Think]   When would * fail to match?**

​	Never.

**[Think]   We say that the repetition operators above are "greedy." Why?**

```ruby
assert_equal "abb", "abbcccddddeeeee"[/ab*/]  
# * means zero or more,  "a" match, "ab" match, "abb" match, the result is "abb",so the repetition operators above are greedy.
# 贪心算法， 能装下多少就装下多少， 最后匹配结果才是  abb
```



**[Think]  Explain the difference between a character class ([...]) and alternation (|).**

```
The patterns in your question match the same text. In terms of implementation, they correspond to different automata and side effects (i.e., whether they capture substrings).

In a comment below, Garrett Albright points out a subtle distinction. Whereas (.|\n) matches any character, [.\n] matches either a literal dot or a newline. Although dot is no longer special inside a character class, other characters such as -, ^, and ] along with sequences such as [:lower:] take special meanings inside a character class. Care is necessary to preserve special semantics from one context to the other, but sometimes it isn’t possible such as in the case of \1 as an archaic way of writing $1 outside a character class. Inside a character class, \1 always matches the character SOH.

Character classes ([...]) are optimized for matching one out of some set of characters, and alternatives (x|y) allow for more general choices of varying lengths. You will tend to see better performance if you keep these design principles in mind. Regex implementations transform source code such as /[abc]/ into finite-state automata, usually NFAs. What we think of as regex engines are more-or-less bookkeepers that assist execution of those target state machines. The sufficiently smart regex compiler will generate the same machine code for equivalent regexes, but this is difficult and expensive in the general case because of the lurking exponential complexity.

For an accessible introduction to the theory behind regexes, read “How Regexes Work” by Mark Dominus. For deeper study, consider An Introduction to Formal Languages and Automata by Peter Linz.
```





