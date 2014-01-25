---
layout: post
title:  "New .bashrc-file"
tags: scripts bash shell
last_modified_at: 2013-11-04
---

Previously I wrote about `functions` and `aliases`, however I just swtiched back to `bash` from `zsh` and thought I'd share some of my `.bashrc`-file. I also switched from TotalTerminal to iTerm 2.

LSCOLORS
--------
Bored with the orignial colors in your bash? Try these:

{% highlight bash %}
export LSCOLORS=gxfxcxdxCxegedabagacad
{% endhighlight %}

This will set the following up:

{% highlight bash %}
# LSCOLORS are written as one string where each
# index (two chars) is a type from the following:
# 1.   directory
# 2.   symbolic link
# 3.   socket
# 4.   pipe
# 5.   executable
# 6.   block special
# 7.   character special
# 8.   executable with setuid bit set
# 9.   executable with setgid bit set
# 10.  directory writable to others, with sticky bit
# 11.  directory writable to others, without sticky bit
#
# Colors are defined by
# a    black
# b    red
# c    green
# d    brown
# e    blue
# f    magenta
# g    cyan
# h    light grey
# A    bold black, usually shows up as dark grey
# B    bold red
# C    bold green
# D    bold brown, usually shows up as yellow
# E    bold blue
# F    bold magenta
# G    bold cyan
# H    bold light grey; looks like bright white
# x    default foreground or background
{% endhighlight %}

COLORS
------

Before we defined our `PS1` we define the colors we need. Note the `RESET` color, which resets the `PS1` to default color.

{% highlight bash %}
# COLORS
RESET='\e[0m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
{% endhighlight %}

PROMPT_COMMAND
--------------

The `PROMPT_COMMAND` will be run after each command. Here we can create the dynamic `PS1`.

<small>Note that the `PS1` is actually on one line, but wraps here</small>

{% highlight bash %}
export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
  local EXIT="$?"
  SCRIPTS_DIR="$HOME/.dotfiles/scripts"
  GIT_PROMPT=$SCRIPTS_DIR/git_prompt.rb

  PS1="\[${YELLOW}\]\u\[${RESET}\]@\[${CYAN}\]\H\[${RESET}\]
  \[${YELLOW}\] \$(\$GIT_PROMPT) \[${WHITE}\]\w\[${RESET}\]
  (\[${GREEN}\]\t\[${RESET}\])\n→ "

  if [ $EXIT != 0 ]; then
    PS1+="\[${RED}\]ಠ_ಠ\[${RESET}\] "
  fi
}
{% endhighlight %}

The `git_prompt.rb` script is "stolen" directly from [vigo's .dotfiles repository](https://github.com/vigo/dotfiles-bash/blob/master/scripts/git_prompt.rb).

Note the Look of Disaproval (`ಠ_ಠ`) when the exit status isn't `0`.

Behold the bash
---------------

When all is done, it will look something like this:

![My helpful screenshot]({{ site.url }}/img/2013-11-04-bash.png)
