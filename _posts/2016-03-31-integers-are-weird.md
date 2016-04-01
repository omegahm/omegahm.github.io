---
layout: post
title:  "Integers are weird"
tags: phd math
last_modified_at: 2016-03-31
extra_script_url: https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML
---

I'm currently trying to teach Bohrium that `a+1+1` is the same as `a+2`.
This was an somewhat easy task.

What were really doing is merging chains of Bohrium byte-code, whenever possible, say in the following Python program:

{% highlight python %}
import numpy as np
z = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

z -= 5
z += 1
z += 1
z += 1
z += 1
z += 1

z = z + 2
z += 8

print z
{% endhighlight %}

Here we should be able to combine all the additions and subtractions and simply add 10 to `z`.

The same should be possible in the following:

{% highlight python %}
import numpy as np
z = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

z *= 5
z /= 1
z /= 2
z *= 2

print z
{% endhighlight %}

This should be just multiplying with 5, however Python gives the following result, when running the above:

{% highlight python %}
[[ 4 10 14]
 [20 24 30]
 [34 40 44]]
{% endhighlight %}

This is of course because of the order of operations, even though they do not matter in this case, and the fact that my `z` array may only hold integers.

When the left-side can only hold integers, the following is unfortunately true:

$$
\frac{\frac{z \cdot 5}{1} \cdot 2}{2} \not= \frac{\frac{r \cdot 5}{1} \cdot 2}{2} for\ z \in \mathbb{Z},\ r \in \mathbb{R}\ and\ z \equiv r
$$

:cry:
