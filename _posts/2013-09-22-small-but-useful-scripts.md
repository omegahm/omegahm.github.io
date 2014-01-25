---
layout: post
title:  "Small, but useful script"
tags: zsh scripts shell
last_modified_at: 2013-09-22
---

We all have those small lines of code that we write again and again and again. Why not write a script to do it for you?

I just thought I'd share some of mine:

be
--

First a little alias, which reduces the number of letters written each day by 99%:

{% highlight bash %}
alias be="bundle exec"
{% endhighlight %}

what\_is\_not\_deployed\_yet
----------------------------
Having committed something you need live asap, this comes in handy, when trying to figure out exactly how much stuff will go live

{% highlight bash %}
function what_is_not_deployed_yet {
  cd /Users/ohm/Work/autobutler;
  set `git ls-remote heroku-production`;
  open "https://github.com/autobutler/autobutler/compare/$1...master?w=1";
}
{% endhighlight %}

Note that it is very hardcoded to fit my needs, which is exactly why it works. Also note the `?w=1` at the end which tells Github to be quiet about whitespace changes.

console-production
------------------

{% highlight bash %}
alias console-production="heroku run console --app autobutler-production"
{% endhighlight %}

pfl
---

Working with LocaleApp, we often want to pull new locale files for our project. This removes the old one and then pulls the new ones.

`pfl` was chosen to mean "pull from localeapp".

{% highlight bash %}
function pfl {
  cd /Users/ohm/Work/autobutler;
  rm config/locales/*.yml
  localeapp pull
}
{% endhighlight %}

deploydeploydeploy
------------------

Want to deploy? Why not just yell it?

This will also grab new code and push to staging.

{% highlight bash %}
function deploydeploydeploy {
  cd /Users/ohm/Work/autobutler;
  git pull;
  git push heroku-production;
  git push -f heroku-staging > /dev/null 2>&1 &
}
{% endhighlight %}
