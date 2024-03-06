{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.zsh.enable = true;

  # home.allowUnfree = true;
  home.packages = with pkgs; [
    bitwarden
    brave
    cmatrix
    cmus
    cowsay
    discord
    dunst
    elixir
    emacs
    erlang
    firefox
    fortune
    fzf
    gh # github cli
    gnome3.adwaita-icon-theme
    google-chrome
    htop
    kitty
    lollypop
    lutris
    neofetch
    neovim
    newsboat
    obs-studio
    pavucontrol # pipewire -> pulseaudio
    rebar3 # build tool for erlang; needed for erlang-ls in neovim
    rustup # used to install a version of rust
    signify # verify package signatures, like for GrapheneOS
    steam
    swaylock-effects # a tired ol' version of swaylock, but it works
    swww # wallpaper management for Wayland/Hyprland
    tela-circle-icon-theme 
    tmux
    tor
    unzip # needed for the elixir-ls in neovim
    vivaldi
    waybar # my bar of choice for Hyprland
    wineWowPackages.stable # both 64-bit and 32-bit wine(s)
    wireshark # wireshark seems to need both the package *and* the programs.wireshark.enable = true
    # wlogout # a good idea, if we ever decide to use a desktop manager (e.g. sddm, gdm)
    wofi # Wayland graphical launcher (like rofi, but Waylandified)
    xdg-user-dirs
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

    ".config/kitty/kitty.conf".text = ''
      background_opacity 0.6
      font_family FiraCode Nerd Font
      '';
    ".config/dunst/dunstrc".text = ''
      [global]
        frame_width = 1
        frame_color = "#000000"
        font = Arimo Nerd Font Propo 10;
        markup = yes
        format = "<big><b>%s</b></big> %p\n%b"
        sort = yes
        indicate_hidden = yes
        alignment = left
        show_age_threshold = 60
        word_wrap = no
        ignore_newline = no
        height = 256
        width = (384, 512)
        offset = 32x32
        shrink = no
        transparency = 15
        corner_radius = 7
        idle_threshold = 120
        monitor = 0
        follow = keyboard
        sticky_history = yes
        history_length = 20
        show_indicators = yes
        line_height = 0
        padding = 8
        horizontal_padding = 10
        icon_position = left
        icon_path = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/16/actions/:${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/16/panel/:"
        max_icon_size = 128
      
      [urgency_low]
        background = "#000000"
        foreground = "#808080"
        timeout = 15
        # icon = bell
      
      [urgency_normal]
        background = "#141003"
        foreground = "#e1c564"
        timeout = 15
        icon = bell
      
      [urgency_critical]
        frame_color = "#ff0000"
        background = "#fff8dc"
        foreground = "#ff0000"
        timeout = 0
        icon = firewall-applet-panic
      '';
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
  };

  programs.home-manager.enable = true;
}
