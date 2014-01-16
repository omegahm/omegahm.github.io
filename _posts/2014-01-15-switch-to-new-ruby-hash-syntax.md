---
layout: post
title:  "Switch to New Ruby Hash Syntax"
tags: ruby sublimetext regex
last_modified_at: 2014-01-16
---

When working on old Ruby code, you'll see the old (<= 1.9) hash syntax:

{% highlight ruby %}
{
  :name     => "Mads",
  :age      => "25",
  :position => "Lead developer"
}
{% endhighlight %}

However, often in new projects you'll want to use the new:

{% highlight ruby %}
{
  name:     "Mads",
  age:      "25",
  position: "Lead developer"
}
{% endhighlight %}

I try to convert to the new, and thus, when editing old files, I tend to replace the old with the new syntax.
This is a tiresome job, and therefore I wrote a Regex to do it:

{% highlight bash %}
s/([^:]):(\w+)\s*=>/\1\2:/g
{% endhighlight %}

It would be nice, if you didn't have to put this into SublimeText 2 every time you wanted to switch the old for the new syntax.
I found [RegReplace](https://github.com/facelessuser/RegReplace) for SublimeText 2, which will allow you to create Regex replacements.
It will also allow you to create SublimeText commands which can be bound to keyboard shortcuts (hurray!).

To get a shortcut to replace the old syntax with the new do the following:

  * Install `RegReplace`
  * Edit your `reg_replace.sublime-settings`-file with:

{% highlight json %}
{
  "replacements": {
    "favor_new_hash_syntax": {
      "find": "([^:]):(\\w+)\\s*=>",
      "replace": "\\1\\2:",
      "greedy": true,
      "case": false
    }
  }
}
{% endhighlight %}

  * Add a shortcut to the default `sublime-keymap`-file:

{% highlight json %}
[
  ...
  { "keys": ["super+shift+x"], "command": "reg_replace", "args": { "replacements": ["favor_new_hash_syntax"] } },
  ...
]
{% endhighlight %}

Now you can just press "⌘+⇧+x" and replace the old with the new.


---

#### Edit: 2014-01-16

There's a couple of shortcomings in the above regex.
It will match these inside strings!
Really doesn't matter for my use case.

It will also _not_ retain the indention.
That is, the example I gave at the top, will not work as shown.
Rather, this:

{% highlight ruby %}
{
  :name     => "Mads",
  :age      => "25",
  :position => "Lead developer"
}
{% endhighlight %}

will become this:

{% highlight ruby %}
{
  name: "Mads",
  age: "25",
  position: "Lead developer"
}
{% endhighlight %}

That really will not do, so we change the regex to:

{% highlight bash %}
s/:(\\w+)\\s?(\\s*)=>\\s?(\\s*)/\1: \2\3/g
{% endhighlight %}

This will retain the indention and make sure that we will get:

{% highlight ruby %}
{
  name:     "Mads",
  age:      "25",
  position: "Lead developer"
}
{% endhighlight %}

The RegReplacer regex will now be:

{% highlight json %}
{
  "replacements": {
    "favor_new_hash_syntax": {
      "find": ":(\\w+)\\s?(\\s*)=>\\s?(\\s*)",
      "replace": "\\1: \\2\\3",
      "greedy": true,
      "case": false
    }
  }
}
{% endhighlight %}

