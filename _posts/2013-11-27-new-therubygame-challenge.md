---
layout: post
title:  "New TheRubyGame Challenge - Time to golf!"
tags: ruby golf
last_modified_at: 2013-11-27
---

So [TheRubyGame](http://www.therubygame.com/) was just brought back from the dead.
The newest challenge (Challenge #1) is about ducks and fire and ducks on fire.

Actually the newest challenge is a [Fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) challenge.

The fun -- and sometimes educational -- part here is golfing, that is creating the shortest Ruby script that can solve the challenge.
When we count the shortest, we count only the content of the method.
Here the method `fireducker` is given, and thus all of

{% highlight ruby %}
def fireducker(startpos, endpos)
  # content that is actually counted
end
{% endhighlight %}

is given and can't be changed.

One solution, rather short (70 characters), could be

{% highlight ruby %}
a,b,c=[3,5,15].map{|y|(startpos..endpos).count{|x|x%y==0}};[a-c,b-c,c]
{% endhighlight %}

This is the straightforward approach.
For each of `[3,5,15]` change the value to the count of integers between `startpos` and `endpos` where `x%y==0`.
Call the last `c` and remove that count from the two others (all numbers that are in the `c` "bucket" will also be counted towards both the `a` and the `b` bucket)

Lets golf a bit.
It is fairly simple to reach 57 characters.
We refactor a bit and end up with something like (this is [nbaum](https://github.com/nbaum)s original shortest solution)

{% highlight ruby %}
s,e=startpos-1,endpos;c=e/15-s/15;[e/3-s/3-c,e/5-s/5-c,c]
{% endhighlight %}

This can actually be golfed even shorter (56 characters, 1 character shorter)

{% highlight ruby %}
g=->z{endpos/z-(startpos-1)/z};c=g[15];[g[3]-c,g[5]-c,c]
{% endhighlight %}

We refactored the division into a `Proc` and call this with the `#call` shorthand of `[]`.
Can we make it shorter?
Why, yes!
We can take advantage of Ruby returning the value of a variable once we set it.
That is, `c=g[15]` will return `g[15]` and still set `c`.
We can do something like (54 characters):

{% highlight ruby %}
[(g=->z{endpos/z-(startpos-1)/z})[3]-c=g[15],g[5]-c,c]
{% endhighlight %}

I can't get it shorter now, however I can make it even more obfuscated.
Ruby will of course return the last value in the method.
We are suppose to give back an array, however, we can actually give back a variable, which is an array.

Ruby will assign our variable with an array of values, if we do not give enough variables for multi-variable-assignment.

That is, the value of `a` in `a = 1, 2` will be `[1, 2]` and thus we can -- with the help of ✔, Ω, ☃ and ℧ (who needs variable names?) and the fact that Ruby 2.0 is in all unicode -- do (54 characters):

{% highlight ruby %}
✔=(Ω=->☃{endpos/☃-(startpos-1)/☃})[3]-℧=Ω[15],Ω[5]-℧,℧
{% endhighlight %}

<small><sup>Golf clap</sup></small>
