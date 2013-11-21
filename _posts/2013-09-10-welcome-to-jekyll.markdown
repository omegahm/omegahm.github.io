---
layout: post
title:  "Welcome to Jekyll! What? Not Rails?"
tags: jekyll ruby rails hosting
---

I must say. Usually I swear to Rails.
"Hey, shouldn't we build this?", "Yeah, of course, lets use Rails!".
However this tends to get out of hand.
You really shouldn't build everything in Rails, just because you can, why not use some frameworks that are built with a specific application in mind, e.g. `jekyll`.

Jekyll it would seem is nothing but `markdown` in some post-files and **BOOM!** you've got yourself a blog.
I didn't even code a single line of Ruby, even though it is run on Ruby.

I figured this blog could just live on GitHub and I might then actually remember to update it once in a while.
Other then that my wish list will be present somewhere.
Once my 1-year-subscription(!) at my hosting provider runs out, I'll move the DNS as well, GitHub is free space, which is nice.

Just to try out some Jekyll features, here is some code: (acutally the solution for the first [Project Euler][euler])

{% highlight ruby %}
puts (1...1000).select {|num| num % 3 == 0 or num % 5 == 0 }.inject(:+) # => 233168
{% endhighlight %}

[euler]: http://projecteuler.net/
