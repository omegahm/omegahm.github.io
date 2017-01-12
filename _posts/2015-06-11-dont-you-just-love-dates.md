---
layout: post
title:  "Don't you just love dates?"
tags: ruby dates
last_modified_at: 2015-06-11
---

Hahaha, dates, you're so funny.

Did you know that the Swedes have actually had a [February 30th](https://en.wikipedia.org/wiki/February_30)?

Did you also know that because of all the switching back and forth between calendars that all the countries have been doing, April 23, 1616 isn't the same day everywhere?
It's not even the same weekday!

Have a look at this Ruby code:

{% highlight ruby %}
irb(main):001:0> DateTime.iso8601('1616-04-23', Date::ENGLAND).to_s
=> "1616-04-23T00:00:00+00:00"
irb(main):002:0> DateTime.iso8601('1616-04-23', Date::ITALY).to_s
=> "1616-04-23T00:00:00+00:00"
irb(main):003:0> DateTime.iso8601('1616-04-23', Date::ENGLAND).tuesday?
=> true
irb(main):004:0> DateTime.iso8601('1616-04-23', Date::ITALY).tuesday?
=> false
irb(main):005:0> DateTime.iso8601('1616-04-23', Date::ENGLAND).httpdate
=> "Tue, 23 Apr 1616 00:00:00 GMT"
irb(main):006:0> DateTime.iso8601('1616-04-23', Date::ITALY).httpdate
=> "Sat, 23 Apr 1616 00:00:00 GMT"
{% endhighlight %}

So even though that they have the same string representation (`#to_s`) they are clearly different dates.

One is in fact from the Julian calendar while the other is Gregorian:

{% highlight ruby %}
irb(main):007:0> DateTime.iso8601('1616-04-23', Date::ENGLAND).julian?
=> true
irb(main):008:0> DateTime.iso8601('1616-04-23', Date::ITALY).gregorian?
=> true
{% endhighlight %}

Oh my god! I have working with dates so much!

![Pulling hair out](http://ivanglima.com/wp-content/uploads/2012/03/PullingHairOut.jpeg)
