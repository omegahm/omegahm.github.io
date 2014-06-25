---
layout: post
title:  "Rake task for Github comparison"
tags: git github ruby rake heroku
last_modified_at: 2014-06-25
---

"What's going to production?"

"Can I deploy the current master?"

"What the hell is going on here?"

Sounds familiar? Why not just have a rake task that could tell you?

{% highlight ruby %}
namespace :git do
  task compare: :environment do
    server = ENV['SERVER']
    server ||= 'beerclub'

    git_commit = `heroku releases -a #{server} | grep 'Deploy' | sort | tail -1 | cut -d ' ' -f 4`.chomp
    if $CHILD_STATUS.success?
      `open "https://github.com/omegahm/beerclub/compare/#{git_commit}...master?w=1"`
    else
      puts "Couldn't get git commit for #{server}."
    end
  end
end
{% endhighlight %}

The above rake task will look for the server passed via `ENV['SERVER']` (or use a default) and grab the last deploy status from it's Heroku releases.
It'll then open the default browser with the compare url from Github, showing you all the files and commits that have been made between last deploy and current master.

The above can be run with

{% highlight bash %}
bundle exec rake git:compare
{% endhighlight %}
