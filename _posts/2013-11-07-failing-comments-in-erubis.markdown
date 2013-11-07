---
layout: post
title:  "Failing comments in erubis"
tags: ruby erb
---

I'm doing a lot of back-end work in Ruby and in Rails.
Lately we hired a full-time front-end developer, and I wanted to give him some pointers in the `index.html.erb`-file in the `/app/views/home`-dir (front page of our site).
I started writing some comments in the file, in a branch, which he could then take and improve on, get to know some of the models (stats shown on the front page) and view-helpers.

I wrote my comments on a separate line from anything else like so

{% highlight ruby %}
STUFF BEFORE
<% # comment %>
STUFF AFTER
{% endhighlight %}

I sometimes, out of habit I guess, saved the file and reloaded the page.
Everything still worked.

Then I came to a section, were I wrote the comment on the same line, at the end of it, like so

{% highlight ruby %}
STUFF BEFORE <% # comment %>
STUFF AFTER
{% endhighlight %}

I wrote some more and then, again out of habit, I reloaded the page.
All hell broke loose.

I got an weird error, which looked something like this

{% highlight ruby %}
/Users/ohm/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/erubis-2.7.0/lib/erubis/evaluator.rb:65:in `eval': (erubis:2: syntax error, unexpected tCONSTANT, expecting end-of-input (SyntaxError)
'; _buf << 'STUFF AFTER
                 ^
  from /Users/ohm/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/erubis-2.7.0/lib/erubis/evaluator.rb:65:in `result'
  from test.rb:2:in `<main>'
{% endhighlight %}

(Ruby 1.9.3 which I was working on didn't give the place where the error was)

"`SyntaxError`"? But all I did was insert some comments!

I cmd+Z'ed a couple of times, and reloaded again.
Nothing.
I went forward a couple of times.
There it was again, but all I did was insert a comment at the end of the line.

I tried deleting white space and adding it again.
I had previously had some errors with weird white space characters.
This did nothing.
I began digging deeper into it, forgetting about the comments, and just concentrating on this weird `SyntaxError`.

It never occurred if the comment was on its own line.
White space didn't matter.
However as soon and some other content was on the same line as the comment, it broke.
Both before and after

{% highlight ruby %}
STUFF BEFORE <% # comment %>
STUFF AFTER

STUFF BEFORE
<% # comment %>STUFF AFTER
{% endhighlight %}

Thinking this was very weird, I began searching our existing code for comments on the same line as content.
They were everywhere.
Why did these work?
Why didn't mine?

I tried to isolate the problem.
I wrote a small helper file `test.rb`

{% highlight ruby %}
require 'erubis'
puts Erubis::Eruby.new(File.read('example.eruby')).result
{% endhighlight %}

and then in `exaxmple.eruby` I put

{% highlight ruby %}
STUFF BEFORE<% # comment %>
STUFF AFTER
{% endhighlight %}

As you can see from the error from Ruby 2.0, it actually tried to interpret `STUFF` as a constant.
Then it hit me!
`<% # comment %>` actually means "space and then a comment" not just "comment".
erubis was trying very hard to make sense of the space and had put it as part of its abstract syntax tree (AST).

Removing the space, and only having `<%# comment %>` makes everything a comment, thus erubis will not make it part of the AST.
That is, the following will of course all work

{% highlight ruby %}
STUFF BEFORE<%# comment %>
STUFF AFTER

STUFF BEFORE
<%# comment %>
STUFF AFTER

STUFF BEFORE
<%# comment %>STUFF AFTER
{% endhighlight %}

The lesson here is: Always use `<%#` for `erb` comments!

I would really like to look at the erubis code and fix this problem, however erubis is not on Github or any other source control platform that I could find!
I might just poke around in the file that `gem` installs when installing the `erubis` gem, but I haven't gotten to that point yet.

<small>(PS: I wrote the erubis guys back in April about this problem)</small>
