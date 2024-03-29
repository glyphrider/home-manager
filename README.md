# Bootstrapping my home-manager configuration

## Intro

I run home-manager in the Standalone configuration, because I feel like tying my home configuration to the system configuration is very un-unix-like.
So what follows are the steps I take to install my home config on a new machine

## The Magic

Login as _the unprivileged user_ and execute the following:

```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

At this point, for whatever reason, you will need to logout and back in.
Somewhere there's some magic that loads the new channel into your session and I have yet to find it. 
After you've done that continue as follows:

```
nix-shell '<home-manager>' -A install
rm -rf ~/.config/home-manager
clone https://github.com/glyphrider/home-manager ~/.config/home-manager
```

If you are borrowing this and want to use your own username (a reasonable ask), you will want to change a couple of things:
* change `home.username = "brian"` in home.nix
* change `home.homeDirectory = "/home/brian"` in home.nix
* change `homeConfigurations."brian"` in flake.nix

```
home-manager switch
```
