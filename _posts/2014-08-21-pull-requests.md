---
layout: post
title:  "Threading the pull-requests"
tags: ruby github
last_modified_at: 2014-08-21
---

I've seen myself go through the my Github organisations pull-requests pages one by one, to see if anything was up, but no more.

I created the below script (also here: [https://github.com/omegahm/pull-orgs](https://github.com/omegahm/pull-orgs)), which takes an organisation as an argument, then loops through all of the repositories, printing out a nice, colourised table with the currently open pull-requests and who they belong to.

![get-pulls in actions]({{ site.url }}/img/2014-08-21-get-pulls.png)

It needs an `GITHUB_ACCESS_TOKEN` set in the environment as well.
This you can get by accessing your Github account, venturing into settings and then applications and here clicking on "Generate new token".
Remember that these tokens are only shown once, so copy it into some secret dotfile or something.

{% highlight ruby %}
#!/usr/bin/env ruby
require 'octokit'
require 'faraday-http-cache'
require 'colorize'
require 'terminal-table'

def fetch_pulls(client, repo)
  print '.'

  pull_requests = client.pull_requests(repo.id, state: 'open')
  return [] if pull_requests.size == 0

  header = ["#{repo.name} (#{pull_requests.size})".blue, '', '']
  pull_requests.inject([header]) do |rs, pr|
    rs << [pr.title, pr.user.login.red, pr.html_url.underline]
  end
end

# Setup
stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
client.auto_paginate = true

# Parse argument
org = ARGV.shift || 'lokalebasen'

# Spawn threads
threads = client.org_repos(org).collect do |repo|
  Thread.new { fetch_pulls(client, repo) }
end

# Create table
table = Terminal::Table.new(headings: ['title', 'user', 'url']) do |tab|
  threads.each_with_index do |t, j|
    Array(t.value).each_with_index do |row, i|
      tab.add_separator if i == 0 && j != 0
      tab.add_row row
    end
  end
end

print "\r"
puts table
{% endhighlight %}
