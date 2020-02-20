---
title: "Make Bash/Zsh Faster With Temporary Amnesia"
---

In my persistent pursuit to make new shell sessions load faster, sub-20ms, on all of my machines one thing I've noticed is that a very long scroll back/history can cause startup slowness. This could be a by-product of me running [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) but I have yet to be willing to give up it's niceties in this mission.

There is an eventual limit to how relevant an old command being available in my history-based autocomplete is, but I've also been bit when it comes to running things like `cert-bot` where I'm scrounging around as to how I made the call prior to just throw away N number commands.

So I added a tiny startup call and function to my zsh profile to help keep my Zsh aware history small but allow me to quickly search the archives.

```sh
# History Cleaner
if [[ $(wc -l < ~/.zsh_history) -ge 1000 ]]
then
  mkdir -p ~/.zsh_histories/
  mv ~/.zsh_history ~/.zsh_histories/$(date +%s).zsh_history
fi

# Search Zsh Histories
function zshh() {
  if [ -n "$1" ]; then
    grep -rwh ~/.zsh_histories ~/.zsh_history -e $1
  fi
}
```

The `# History Cleaner` section above checks the default `.zsh_history` file and if the number of lines is over 1000, it moves it to a timestamped file under `~/.zsh_histories/`.

The `# Search Zsh Histories` is where the real magic lies. If I can't find a command in my history, I can quickly search the archives by running `zshh the-command`. Hint, `zshh` is short for "Zsh H(istory)". Because it uses `grep` it's pretty fast, requires no additional plugins/installations, and solves it's purpose for me. I've seen other implementations that use a SQLite DB but that was too heavy handed in my opinion, much less very portable.

This can be adopted to `bash` as well:

```sh
# History Cleaner
if [[ $(wc -l < ~/.bash_history) -ge 1000 ]]
then
  mkdir -p ~/.bash_histories/
  mv ~/.bash_history ~/.bash_histories/$(date +%s).bash_history
fi

# Search Bash Histories
function bashh() {
  if [ -n "$1" ]; then
    grep -rwh ~/.bash_histories ~/.bash_history -e $1
  fi
}
```

The nice part is that this also searches anywhere in the command that was called so it can be helpful if you don't remember the exact syntax you ran before:

```sh
~
➜ zshh go
...
: 1570823071:0;brew install go
: 1570823199:0;go build
: 1570823203:0;which go
: 1570823317:0;go build
: 1570823385:0;go get github.com/hashicorp/terraform-plugin-sdk/plugin
: 1570823493:0;mkdir -p ~/Workspace/go
: 1570824778:0;go get -v github.com/hashicorp/terraform-plugin-sdk/plugin
: 1570824901:0;go get github.com/hashicorp/go-cleanhttp
: 1570824965:0;go build
...
```

Some future improvements would be to allow for a rolling history where lines beyond 1000 would be moved into the archives. I can be quite jarring when the rollover happens but for my workflows it hasn't been an issue. The rollover happens on any new session so as long as the same session is open you will still be able to access commands prior.