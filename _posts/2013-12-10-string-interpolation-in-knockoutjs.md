---
layout: post
title:  "String Interpolation in Knockout"
tags: javascript ruby rails knockout
last_modified_at: 2013-12-10
---

At [autobutler.dk](https://www.autobutler.dk) we are currently developing a new flow for car owners to enter.
This flow is based on a data-driven API.
The new flow will be a front-end client of this API.

We are using [Knockout](http://knockoutjs.com/) as our front-end framework.

One of the hurdles we encounted was string interpolation.
We normally use Ruby and Rails for everything.

In Ruby string interpolation is easy, just `"this #{var} that"` will replace `var` with the content of the `var`-variable.
When using it together with `I18n`s `t` method, we use `%{var}` instead of `#{var}`.

If we had a header called with `<%= t('.header', var: 'MY VAR') -%>` and this had a `%{var}` in it, we would replace it.
Our prolem here is that the value of the variable isn't known until the client gets to work.

One solution to this is to have the string split into several strings, that you can concatinate:

{% highlight javascript %}
var s = "MY VAR";
var string = "<%= t('.header1') -%> " + s + " <%= t('.header2') -%>";
{% endhighlight %}

... really not a solution.

This is why we introduced the following code in our global Knockout scope:

{% highlight javascript %}
ko.bindingHandlers.t = {
  init: function(element, valueAccessor) {
    var obj = valueAccessor() || {};
    var text = $(element).text();

    // Collect options
    var options = [];
    for(var key in obj) {
      if (key !== 'text') {
        options.push(key)
      }
    }

    // Match all properties
    var re;
    $.each(options, function(index, elem) {
      re = new RegExp("\%\{" + elem + "\}", "g");
      text = text.replace(re, obj[elem]);
    });

    $(element).html(text);
  }
};
{% endhighlight %}

This lets us interpolate Javsacript or Knockout variables into our strings.
We can thus do the following:

{% highlight html %}
<span data-bind="text: '<%= t('.header') -%>', t: { email: my_email_var }"></span>
{% endhighlight %}

And have `%{email}` in the translation replaced with the contents of `my_email_var`.
