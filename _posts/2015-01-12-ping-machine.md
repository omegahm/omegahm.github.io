---
layout: post
title:  "Ping Machine"
tags: ruby heroku
last_modified_at: 2015-01-12
---

First of I'd like to say: "Sorry Heroku".

If you guys want me to take this down again, or if this is against your terms of use, I'll gladly do so.

---

I've just pushed my evil [`PingMachine` to Github](https://github.com/omegahm/ping-machine). :smiling_imp:

`PingMachine` is a (very) simple Rack application, which, given `SITES` as a comma-separated string, will fetch each of the sites every 10 seconds or so.

Why is this evil? Well, Heroku will sleep your application if it hasn't been active for a while (if you only have one (free) dyno). I don't want this for my free applications, so I setup yet another Heroku app just to ping the others.

`PingMachine` does so, by first sleeping 10 seconds and then spawning a thread for each site. These threads will fetch the page via `curb` and just throw away the result. Whilst it's `curb`ing away, it'll return `200 OK` and a list of the sites back to you. An important note here, is that the `PingMachine` itself is on this list, resulting in it doing it all over again... and again... and again...

Now all my sleepy Heroku app have been awaken - and will stay awake until `PingMachine` dies (or is rebooted and forgotten, in which `PingMachine` itself will fall asleep :dizzy_face:)
