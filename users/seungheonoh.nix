{ config, pkgs, ...}:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "a7cdfaa32585fce404cf8890bae099348e53e0ad";
    ref = "master";
  };

  shellInit = ''
    # Envs
    export XRDM_DIR=$HOME/.Xresource.d
    export XRDM_FONT_DIR=$XRDM_DIR/fonts
    export XRDM_COLOR_DIR=$XRDM_DIR/colors
    export XRDM_PRESET_DIR=$XRDM_DIR/presets
    export XRDM_PROGRAM_DIR=$XRDM_DIR/programs

    export PATH=$PATH:$HOME/bin
    export EDITOR="vim"
    export GOPATH=~/go
  '';

  generalFont = "IBM Plex Sans 12";
in
{
  imports = [ "${home-manager}/nixos" ];

  users.users.seungheonoh = {
    name = "seungheonoh";
    isNormalUser = true;
    home = "/home/seungheonoh";
    extraGroups = [ "wheel" "audio" "networkmanager" "video" "tty"];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home-manager.users.seungheonoh = {
    # Custom homemanager modules
    imports = [
      ./modules/ksh.nix
    ];
    home.packages = with pkgs; [
      # Text editor
      ed # The standard text editor

      ksh

      # GUI
      firefox

      vitetris # Best Arcade
    ];

    home.sessionVariables = {
      XRDM_UPDATE = "Y";
      EDITOR = "vim";
      VISUAL = "vim";
      MANPAGER = "less";
      GOPATH = "$HOME/go";
    };

    programs = {
      neovim = {
        enable = true;
        vimAlias = true;
        extraConfig = ''
          set t_Co=0;
          set t_ut=
          let g:seoul256_background = 233
          "syntax on
          highlight Comment cterm=italic
          highlight String cterm=italic
          highlight Constant cterm=bold,italic
          set tabstop=2 shiftwidth=2 expandtab
          set softtabstop=2
          set smarttab
          set nu
          set autoindent
          set ruler
          set encoding=UTF-8
          set noshowmode
          let mapleader=" "
          nnoremap NT :NERDTreeToggle<cr>
          nnoremap <leader>nt :NERDTreeToggle<cr>
          nnoremap <leader>tb :TagbarToggle<cr>
          xmap     ga <Plug>(EasyAlign)
          tnoremap <ESC> <C-\><C-n>
          nnoremap <leader>// :let @/ = ""<cr>
          nnoremap <leader>ff :FZF <cr>
          nnoremap <leader>ag :Ag<cr>
          nnoremap <F1> gg"+yG
        '';
        plugins = with pkgs.vimPlugins; [
          # Syntax
          vim-go
          vim-nix

          # Util
          nerdtree
          nerdcommenter
          tagbar
          fzf-vim
          fzfWrapper
          goyo

          # Colorscheme
          seoul256-vim
        ];
      };

      chromium = {
        enable = true;
      };

      fzf = {
        enable = true;
      };

      ksh = {
        enable = true;
        initExtra = shellInit;
      };

      bash = {
        enable = true;
        shellAliases = {
          v = "nvim";
          c = "cd";
          ns = "nix-shell";
          nsp = "nix-shell -p";
          nor = "sudo nixos-rebuild switch";
        };
        initExtra = shellInit;
        bashrcExtra = ''
          # Prompt
          declare -a prompts=("λ" "$" "±" "Δ")
          get_prompt_char() {
            echo ''${prompts[((''$RANDOM % ''${#prompts[@]}))]}
          }
          #export PS1='\[\e[1;32m\]$(get_prompt_char)\[\e[0m\] ( \W ) '
          export PS1='[ \W ]$ '
          bind 'TAB:menu-complete'
          bind 'set show-all-if-ambiguous on'
          source xrdm
        '';
      };

      tmux = {
        enable = true;

        keyMode = "vi";
        customPaneNavigationAndResize = true;
        reverseSplit = true;
        shortcut = "a";
        plugins = with pkgs; [
          tmuxPlugins.cpu
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '15' # minutes
            '';
          }
        ];
        extraConfig = ''
          set -g allow-rename off

          bind-key p command-prompt -p "join pane from: " "join-pane -s '%%'"
          bind-key p command-prompt -p "send pane to: " "join-pane -t '%%'"

          # mouse behavior
          setw -g mouse on

          bind-key : command-prompt
          bind-key r refresh-client
          bind-key L clear-history

          bind-key space next-window
          bind-key bspace previous-window
          bind-key enter next-layout
        '';
      };

      rofi = {
        enable = true;
        extraConfig = ''
          * {font: ${generalFont};background-color: #000000;text-color: #FFFFFF;spacing: 0;width: 30%;}
          inputbar {children: [prompt,entry];}
          prompt {padding: 16px;}
          textbox {background-color: #2e343f;padding: 8px 16px;}
          entry {padding: 16px;}
          listview {cycle: true;margin: 0 0 -1px 0;}
          element {padding: 16px;}
          element selected {background-color: #FFFFFF;text-color: #000000;}
        '';
      };
    };

    services = {
      dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            geometry = "300x60-20+48";
            indicate_hidden = "yes";
            shrink = "no";
            separator_height = 0;
            padding = 32;
            horizontal_padding = 32;
            frame_width = 2;
            sort = "no";
            idle_threshold = 120;
            font = "${generalFont}";
            line_height = 4;
            markup = "full";
            format = "%s\n%b";
            alignment = "left";
            show_age_threshold = 60;
            word_wrap = "yes";
            ignore_newline = "no";
            stack_duplicates = false;
            hide_duplicate_count = "yes";
            show_indicators = "no";
            icon_position = "off";
            sticky_history = "yes";
            history_length = 20;
            always_run_script = true;
            title = "Dunst";
            class = "Dunst";
          };

          shortcuts = {
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
            history = "ctrl+grave";
            context = "ctrl+shift+period";
          };

          urgency_low = {
            timeout = 4;
            background = "#141c21";
            foreground = "#93a1a1";
            frame_color = "#8bc34a";
          };

          urgency_normal = {
            timeout = 8;
            background = "#141c21";
            foreground = "#93a1a1";
            frame_color = "#ba68c8";
          };

          urgency_critical = {
            timeout = 0;
            background = "#141c21";
            foreground = "#93a1a1";
            frame_color = "#ff7043";
          };
        };
      };
      sxhkd = {
        enable = true;
        keybindings = {
          "super + Return" = ''sh -c "urxvt & exit"'';
          "super + q" =  "xkill -id $(pfw)";
          "super + d" = "rofi -show run";
          "super + f" =  "fullscreen full $(pfw)";
          "super + s" = "session_menu";

          "alt + Return" = ''sh -c "urxvt & exit"'';
          "alt + q" =  "xkill -id $(pfw)";
          "alt + d" = "rofi -show run";
          "alt + f" =  "fullscreen full $(pfw)";
          "alt + s" = "session_menu";
          
          "Print" = "screenshot Area";
          "ctrl + Print" = "screenshot Window";
        };
      };
    };
  };
}
