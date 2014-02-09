---
layout: post
title:  "Pluck vs. map and select"
tags: ruby rails optimise
last_modified_at: 2014-02-09
---

Just a quick look at `pluck` vs. `map` and `select` in Rails.

Lets say we have a `User` with an active and a balance field on him.
The `active` field is a boolean and the `balance` field is float.
Now, we want to select the balance of all our active users.
We can of course do this in several ways.
We start by defining a scope for finding the active users:

{% highlight ruby %}
scope :active, -> { where active: true }
{% endhighlight %}

Now we can grab all active users with:

{% highlight ruby %}
User.active
{% endhighlight %}

We want to find each their balance, so something like this might come natural to most:

{% highlight ruby %}
User.active.map(&:balance)
{% endhighlight %}

The SQL generated here will actually be:

{% highlight sql %}
SELECT "users".* 
FROM "users" 
WHERE "users"."active" = 't'
{% endhighlight %}

This means that we will grab every field on the `User` model and instantiate that object, and then, with `.map(&:balance)` grab the balance from each object.

We want to do all this in the SQL, as we are just tossing all the other data, we do not need to actually fetch it from the database.
We could do something like this, to not get all the unneeded fields:

{% highlight ruby %}
User.active.select(:balance).map(&:balance)
{% endhighlight %}

This will generate this SQL instead:

{% highlight sql %}
SELECT "users"."balance"
FROM "users" 
WHERE "users"."active" = 't'
{% endhighlight %}

and then only provide us with dummy `User` objects with the balances.
Mapping over these, will yield the exact same result as above, however this time, we do not have to toss any data as we only fetch the balances.

Oh, but we mentioned `balance` twice in the above ruby code.
That's not very nice, can't we have some sugar for that?
Well, of course we can.
`pluck` to the rescue.

To do a combined `select` and `map` we can do:

{% highlight ruby %}
User.active.pluck(:balance)
{% endhighlight %}

which yield the exact same SQL:

{% highlight sql %}
SELECT "users"."balance"
FROM "users" 
WHERE "users"."active" = 't'
{% endhighlight %}

We'll end up with an array of balances, but this time we only had to tell it once about the `balance` field.

Conclusion: Always use `pluck` in favour of `select` and then `map`.
