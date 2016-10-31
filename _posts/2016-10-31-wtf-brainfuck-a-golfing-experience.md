---
layout: post
title:  "WTF Brainfuck? A golfing experience"
tags: programming fun
last_modified_at: 2016-10-31
---

I did a talk at the Copenhagen Ruby Brigade (Ruby Meetup Group based in Copenhagen) about my way to have fun whilst programming.

The topic at hand was "WTF Brainfuck? A golfing experience".

These are my notes from that talk.

---

Imagine an endless stream of buckets.

<i class="fa fa-trash" style="font-size: 10.0em;"></i>
<i class="fa fa-trash" style="font-size:  9.0em;"></i>
<i class="fa fa-trash" style="font-size:  8.0em;"></i>
<i class="fa fa-trash" style="font-size:  7.0em;"></i>
<i class="fa fa-trash" style="font-size:  6.0em;"></i>
<i class="fa fa-trash" style="font-size:  5.0em;"></i>
<i class="fa fa-trash" style="font-size:  4.0em;"></i>
<i class="fa fa-trash" style="font-size:  3.0em;"></i>
<i class="fa fa-trash" style="font-size:  2.0em;"></i>
<i class="fa fa-trash" style="font-size:  1.0em;"></i>

We can add, subtract, read, and write to each bucket.

The entire spec for the Brainfuck language is as follows:

{% highlight brainfuck %}
+ # => Add one to current bucket
- # => Subtract one from current bucket
< # => Move "bucket-pointer" to the left
> # => Move "bucket-pointer" to the right
. # => Write byte from current bucket to STDOUT
, # => Read one byte from STDIN into current bucket
[ # => If current bucket is zero, go to matching ]
] # => If current bucket is non-zero, go back to matching [

# Everything else is comments.
{% endhighlight %}

The `"Hello world!\n"` program is thus written:

{% highlight brainfuck %}
>++++++++[-<+++++++++>]<.                  # H  ( 72)
>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----. # e  (101)
>->+++.                                    # l  (108)
.                                          # l  (108)
+++.                                       # o  (111)
>-.                                        #    ( 32)
<<+[>[+>+]>>]<--------------.              # w  (119)
>>.                                        # o  (111)
+++.                                       # r  (114)
------.                                    # l  (108)
--------.                                  # d  (100)
>+.                                        # !  ( 33)
>+.                                        # \n ( 10)
{% endhighlight %}

If we wanted, we could easily write a Brainfuck interpreter in Ruby :gem:.

We start, by having it load the Brainfuck program from a file:

{% highlight ruby %}
program = File.read(ARGV.first)
{% endhighlight %}

Now we can run it with

{% highlight bash %}
$ ruby bf.rb input.bf
{% endhighlight %}

With this it's easy to go on, implementing each of the instructions from the spec above.
The only problem is `[` and `]`, where we need a depth counter, to count nested loops, and then move over these in a correct manner.

{% highlight ruby %}
program = File.read(ARGV.first)
pc = 0
bp = 0
buckets = [0]
depth = 0
direction = 1

while pc < program.size
  case program[pc]
  when ">"
    bp += 1
    buckets[bp] ||= 0
  when "<"
    bp -= 1
  when "+"
    buckets[bp] += 1
  when "-"
    buckets[bp] -= 1
  when "."
    STDOUT.putc buckets[bp].chr
  when ","
    buckets[bp] = STDIN.getc.ord
  when "["
    if buckets[bp] == 0
      depth, direction = 1, 1
    end
  when "]"
    if buckets[bp] != 0
      depth, direction = 1, -1
    end
  end

  while depth > 0
    pc += direction
    depth += direction if program[pc] == "["
    depth -= direction if program[pc] == "]"
  end

  pc += 1
end
{% endhighlight %}

We end up with this 40 lines (650 bytes) program.

Now lets go golfing!

<blockquote>
<p>Code golf is a type of recreational computer programming competition in which participants strive to achieve the shortest possible source code that implements a certain algorithm.</p>
<footer><cite><a href="https://en.wikipedia.org/wiki/Code_golf">https://en.wikipedia.org/wiki/Code_golf</a></cite></footer>
</blockquote>

**DISCLAIMER**:
Don't do this to your production code.
This is for fun and learning _only_!

We can mess alot around with different stuff, learning a lot doing so.
Did you know that `$<.read` will read the file contents of a file given as argument?
Did you also know that `$><<"hello"` will print `"hello"`?
Or that `t[?+]` will return `"+"` if `t` is `"+"` and `nil` otherwise? (Thus enabling us to short circuit our statements)

When we are done goofing around, our Brainfuck interpreter will look something like this (only 234 bytes):

{% highlight ruby %}
a,*b=$<.read,c=d=n=0
(t,m=a[d],-1
t[?>]&&b[c-=m]||=n
t[?<]&&c+=m
t[?+]&&b[c]-=m
t[?-]&&b[c]+=m
t[?.]&&$><<b[c].chr
t[?,]&&b[c]=STDIN.getc.ord
n==b[c]?t[?[]&&n=m=1:t[?]]&&n=1
(a[d+=m][?[]&&n+=m
a[d][?]]&&n-=m)until n<1
d+=1)while a[d]
{% endhighlight %}

This is indeed a Brainfuck! :smile:

<small>And it messes up the syntax highlighter... Brilliant!</small>
