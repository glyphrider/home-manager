{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.zsh.enable = true;

  # home.allowUnfree = true;
  home.packages = with pkgs; [
    gh
    git
    hyprland
    swaylock-effects
    waybar
    tmux
    neovim
    wofi
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    ".config/tmux/tmux.conf".source = ./tmux.conf;
    ".zshrc".source = ./zshrc;
    ".emacs".source = ./emacs;
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/waybar-config.jsonc".source = ./waybar-config.jsonc;
    ".config/hypr/waybar-style.css".source = ./waybar-style.css;
    ".config/swaylock/config".source = ./swaylock.conf;
    ".config/wofi/config".source = ./wofi.conf;
    ".config/wofi/style.css".source = ./wofi-style.css;
    ".gitconfig".source = ./gitconfig;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = '' org.gradle.console=verbose org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.activation.tpm = ''
    if [ ! -d ~/.tmux/plugins/tpm ]; then
      "${pkgs.git}/bin/git" clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
      echo '> tmux plugin manager already installed'
    fi
    '';
  home.activation.asdf = ''
    if [ ! -d ~/.asdf ]; then
      "${pkgs.git}/bin/git" clone https://github.com/asdf-vm/asdf.git ~/.asdf
    else
      echo '> asdf version manager already installed'
    fi
    '';
  home.activation.ssh = ''
    if [ ! -d ~/.ssh ]; then
      mkdir ~/.ssh
    else
      echo '> user ssh directory already created'
    fi
    chmod 700 ~/.ssh
    '';
  home.activation.nvim = ''
    if [ ! -d ~/.config/nvim ]; then
      "${pkgs.git}/bin/git" clone --depth=1 https://github.com/nvchad/nvchad.git ~/.config/nvim
    else
      echo '> nvim config exists; if you need to, rm -rf ~/.config/nvim and rerun home-manager switch'
    fi
    '';
  home.activation.xdg = ''
    "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update"
    '';

  home.sessionVariables = {
    EDITOR = "vim";
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
