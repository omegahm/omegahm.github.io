---
layout: post
title:  "✔ as a shortcut"
tags: bash macosx
---

I've been going crazy over that Mac OS X has a shortcut for `√` (Square root sign) but not for `✔` (Check mark).

The shortcut is `⌥+v`.

Today I learned that you can change the default keybindings for such things, and it works in almost all applications. You only need to create the file `DefaultKeyBinding.dict` in `~/Library/KeyBindings` (You might have to create that folder as well) and fill it with:

{% highlight bash %}
{
  "~v" = (insertText:, "✔");
}
{% endhighlight %}

Voilà - you can now use `⌥+v` to create `✔`.

Of course you can do much more than just adding a shortcut for `✔` as seen in this article from Harvard: [Usable Selectors for Cocoa Key Bindings](http://www.hcs.harvard.edu/~jrus/Site/selectors.html)
