{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.bash = {
    enable = true;
    shellAliases = {
      h = "dbus-launch --exit-with-session Hyprland";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "${pkgs.eza}/bin/eza -aF --icons --color=auto --group-directories-first --git";
      ll = "${pkgs.eza}/bin/eza -alF --icons --color=auto --group-directories-first --git";
    };
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" ];
    };
    plugins = [
      { name = "powerlevel10k"; src = pkgs.zsh-powerlevel10k; file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme"; }
      { name = "fzf-tab"; src = pkgs.zsh-fzf-tab; file = "share/fzf-tab/fzf-tab.zsh.theme"; }
    ];
    initExtra = ''
      source ~/.p10k.zsh
      export SSH_ENV="$HOME/.ssh/agent-environment.zsh"
      start_agent() {
        echo "Initializing new SSH agent..."
        ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
        echo succeeded
        chmod 600 "$SSH_ENV"
        source "$SSH_ENV"
        ssh-add
      }
      
      if [ -f "$SSH_ENV" ]; then
        source "$SSH_ENV"
        ps -ef | grep $SSH_AGENT_PID | grep -e 'ssh-agent$' > /dev/null || start_agent
      else
        start_agent
      fi
      '';
  };

  programs.git = {
    enable = true;
    userName = "Brian H. Ward";
    userEmail = "glyphrider@gmail.com";
    signing = {
      key = "A1268F7E5E7EBFDF";
      signByDefault = true;
    };
    aliases = {
      lol = "log --pretty=oneline --abbrerv-commit --graph --decorate";
      los = "log --show-signature";
    };
    extraConfig = {
      pull = { rebase = "false"; };
      init = { defaultBranch = "main"; };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" "gists.github.com" ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    awscli2
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
    eza
    ffmpeg
    firefox
    fortune
    git
    gh # github cli
    gimp
    gnome3.adwaita-icon-theme
    google-chrome
    grim
    htop
    kitty
    lollypop
    lutris
    neofetch
    neovim
    nerdfonts
    newsboat
    obs-studio
    pavucontrol # pipewire -> pulseaudio
    rebar3 # build tool for erlang; needed for erlang-ls in neovim
    rustup # used to install a version of rust
    signify # verify package signatures, like for GrapheneOS
    slurp
    steam
    swappy
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
    wl-clipboard
    # wlogout # a good idea, if we ever decide to use a desktop manager (e.g. sddm, gdm)
    wofi # Wayland graphical launcher (like rofi, but Waylandified)
    xdg-user-dirs
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    ".config/tmux/tmux.conf".source = ./tmux.conf;
    ".emacs".source = ./emacs;
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/waybar-config.jsonc".source = ./waybar-config.jsonc;
    ".config/hypr/waybar-style.css".source = ./waybar-style.css;
    ".config/swaylock/config".source = ./swaylock.conf;
    ".config/wofi/config".source = ./wofi.conf;
    ".config/wofi/style.css".source = ./wofi-style.css;
    # ".gitconfig".source = ./gitconfig;

    ".config/kitty/kitty.conf".text = ''
      background_opacity 0.6
      font_family FiraCode Nerd Font
      shell env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.zsh}/bin/zsh
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
        word_wrap $= no
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
      echo '> installing tmux plugin manager (via git)'
      "${pkgs.git}/bin/git" clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
      echo '> tmux plugin manager already installed'
    fi
    '';
  home.activation.asdf = ''
    if [ ! -d ~/.asdf ]; then
      echo '> installing asdf version manager (via git)'
      "${pkgs.git}/bin/git" clone https://github.com/asdf-vm/asdf.git ~/.asdf
    else
      echo '> asdf version manager already installed'
    fi
    '';
  home.activation.ssh = ''
    if [ ! -d ~/.ssh ]; then
      echo '> creating an ssh directory'
      mkdir ~/.ssh
    else
      echo '> user ssh directory already created'
    fi
    chmod 700 ~/.ssh
    '';
  home.activation.nvim = ''
    if [ ! -d ~/.config/nvim ]; then
      echo '> installing nvchad for neovim'
      "${pkgs.git}/bin/git" clone --depth=1 https://github.com/nvchad/nvchad.git ~/.config/nvim
    else
      echo '> nvim config exists; if you need to, rm -rf ~/.config/nvim and rerun home-manager switch'
    fi
    '';
  home.activation.xdg = ''
    echo '> using xdg-user-dirs to ensure "standard" folders exist in home'
    "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update"
    '';

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
