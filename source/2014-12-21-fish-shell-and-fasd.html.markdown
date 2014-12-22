---
title: Fish Shell and Fasd
date: 2014-12-21 14:58 UTC
tags: Fish
---

Recently I switched to the [friendly interactive shell](http://fishshell.com) after being a ZSH user for a few years.
While ZSH is a big improvement over Bash it's also a lot slower and requires quite some configuration to get it to work the way you want to.
In search for a better alternative I found out about the fish shell. I was immediately hooked.

Fish is a lot faster and provided a lot of functionality out of the box (auto completion, syntax highlighting and a lot more).
The most impressing feature is the way it autocompletes commands while you type. This is a big improvement over the history search I was using in ZSH.

Fish's configuration is stored in `~/.config/fish/config.fish`. You can of course edit this file using your favorite editor,
but you can also use the `fish_config` command which spawns a fancy angular based web interface where you can edit your settings,
change your bindings and even inspect your command history.

## Fasd

One thing that I was missing from my ZSH setup was [Fasd](https://github.com/clvv/fasd). Fasd is a tool to quickly jump to recently used files or directories (similar to [autojump](https://github.com/joelthelion/autojump) and [z](https://github.com/rupa/z)).
It turns out that I was in luck, because they quite recently added [the necessary interface](https://github.com/fish-shell/fish-shell/commit/646d9ab431f102588dfbc90e1c54ff879d164a8a) that was needed to port Fasd to fish.

To use fasd with fish you have to add the following lines to your [`config.fish`](https://github.com/jurriaan/dotfiles/blob/master/config/fish/config.fish):

~~~bash
function -e fish_preexec _run_fasd
  fasd --proc (fasd --sanitize "$argv") > "/dev/null" 2>&1
end

function j
  cd (fasd -d -e 'printf %s' "$argv")
end
~~~

And upgrade to the git master version of fish shell using `brew install --HEAD fish`.

You can now use the `j` command to quickly jump to directories using fuzzy matching. You can also create functions to for example edit/view files. See the [Fasd README](https://github.com/clvv/fasd/blob/master/README.md) for more details.

I'm quite happy with my current configuration, it's fast and productive.
