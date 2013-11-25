---
layout: post
title:  "Even more failing comments"
tags: ruby erb
last_modified_at: 2013-11-15
---

So I took my `erubis` for another spin.

I might try to fix this error myself later on, but for now, all I can do is pointing stuff out.
I can't find a contribute link anywhere anyway.

Using my small `ruby`-script from earlier:

{% highlight ruby %}
require 'erubis'
puts Erubis::Eruby.new(File.read('example.eruby')).result
{% endhighlight %}

I can do `erubis` stuff.
What I wanted to try was another bug I encountered while working.
If the very last line is a printing statement (`<%=`) and it ends with a comment, it will break with the same syntax error as last time.

That is, this won't work:

{% highlight ruby %}
<%= "the string" # yes, the string %>
{% endhighlight %}

However, this will not:

{% highlight ruby %}
<% var = "the string" # yes, the string %>
<%= var %>
{% endhighlight %}

And as last time, this will *not* break:

{% highlight ruby %}
<% # comment %>
{% endhighlight %}

But this *will*:

{% highlight ruby %}
Something <% # comment %>
{% endhighlight %}
