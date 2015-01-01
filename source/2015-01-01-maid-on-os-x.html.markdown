---
title: Maid as a Daemon on OS X
date: 2015-01-01 21:00 UTC
tags: OS X, Maid, Hazel
---

## What is Maid?
According to the [project's](https://github.com/benjaminoakes/maid) README:

>  Maid keeps files from sitting around too long, untouched. Many of the downloads and temporary files you collect can easily be categorized and handled appropriately by rules you define. Let the maid in your computer take care of the easy stuff, so you can spend more of your time on what matters.

## An example: Automatically uploading screenshots
A while ago I contributed [watch and repeat functionality](https://github.com/benjaminoakes/maid/pull/126) that is available in the just released v0.6. This means that Maid can now listen to filesystem changes (like [Hazel](http://www.noodlesoft.com/hazel.php)), and run tasks periodically like cron.
This is realized using the [Listen](https://github.com/guard/listen) and [Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler) gems.

This functionality can be used to do things like this (an exerpt from [my rules.rb](https://github.com/jurriaan/dotfiles/blob/master/maid/rules.rb)):

~~~ruby
Maid.rules do
  repeat '1h' do
    rule 'Remove old screenshots' do
      dir('~/Desktop/Screen Shot *').each do |path|
        if 2.hours.since?(accessed_at(path))
          move(path, '~/Desktop/Old/')
        end
      end
    end
  end

  watch('~/Desktop') do
    rule 'Move screenshots to server' do |modified, added, removed|
      added.select {|f| f =~ /Desktop\/Screen Shot.*\.png$/ }.each do |file|
        filename = upload_screenshot(file)
        system "terminal-notifier -message '#{filename}' -open '#{filename}' "\
               "-title '💻  Screenshot uploaded'"
        system "echo '#{filename}' | pbcopy"
      end
    end
  end
end
~~~

Which will automatically upload your screenshots to an external server and copies the URL to your clipboard.
And if the screenshots are older than 2 hours they will be moved to the `Old` directory so your desktop stays uncluttered.

## Launch Agent

In order to make this more useful you'll want to run Maid as an OS X Launch Agent.

Launchd is a service that is used in OS X to manage processes.
You can create your own Launch Agents that `launchd` will run on login.

The best way to get Maid running on login is to use a Launch Agent.
A Launch Agent is a .plist file that describes how `launchd` should run the program.

Put the following code in `~/Library/LaunchAgents/ninja.jurriaan.maid.plist` (assuming you use chruby and fish-shell):

~~~plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
          "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>ninja.jurriaan.maid</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/fish</string>
      <string>-l</string>
      <string>-c</string>
      <string>chruby 2.2.0; and maid daemon</string>
    </array>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>
~~~

Load the daemon using `launchctl load ~/Library/LaunchAgents/ninja.jurriaan.maid.plist` so you don't have to logout for it to start.

