{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-69d62f69-3daa-4d4a-803e-8a52f3bb9bd8".device = "/dev/disk/by-uuid/69d62f69-3daa-4d4a-803e-8a52f3bb9bd8";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-481504a0-8ec1-409d-b9e4-4ab5660cfd43".keyFile = "/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-69d62f69-3daa-4d4a-803e-8a52f3bb9bd8".keyFile = "/crypto_keyfile.bin";
  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  #Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  #Garbage colector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jer = {
    isNormalUser = true;
    description = "jer";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    discord
    chromium
    signal-desktop
    signal-cli
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jer";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.hyprland.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc

    alsa-lib
    alsa-utils
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cudatoolkit
    cups
    curl
    dbus
    expat
    openssl
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    icu
    libGL
    libappindicator-gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    pango
    pipewire
    pkg-config
    systemd
    udev
    vulkan-loader
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    xdg-utils
    zlib
  ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Essential Utilities
    alacritty    # Terminal emulator
    bat          # Enhanced cat command
    delta        # Git diff viewer
    du-dust      # du + rust, like `du` but betterererer
    eza          # Modern ls command
    fd           # User-friendly find command
    ffmpeg       # Multimedia framework
    fish         # Friendly interactive shell
    git          # Version control system
    gh           # Official Github CLI tool
    helix        # Text editor
    lsd          # Modern ls command
    neofetch     # System information tool
    ripgrep      # more modern grep
    starship     # Shell prompt
    tailscale    # VPN service
    wget         # Network downloader
    zoxide       # Directory jumper
    bash         # coz you need it..
    btop         # sexier system monitor

    # Development Tools
    alsa-lib             # ALSA sound library
    alsa-utils
    binutils             # Binary tools
    catatonit            # Container init system
    curl                  
    clang                # a C/C++ compiler
    direnv               # Directory based $ENV shitfuckery
    docker-compose       # Docker container management
    dunst                # Notification daemon
    fontconfig
    gcc                  # a C compiler
    gnumake              # Build automation tool
    lazydocker           # Docker UI
    libGL
    libxkbcommon         # X keyboard description library
    lld                  # LLVM linker
    mesa
    mold                 # A faster linker
    nodejs               # JavaScript runtime
    openssl              # You know what this is..
    pkg-config           # Package configuration tool
    podman               # Container engine
    protobuf             # Google's data interchange format
    sqlite               # SQL database engine
    systemd
    udev
    udev.dev             # Device manager

    #GOPHERIT
    go                   # Programming language

    # The Lord's language
    rustup               # Rust toolchain installer
    rustc                # Rust compiler
    cargo                # Rust package manager
    cargo-nextest
    
    # Python 3.11 and associated tools
    pyenv                # Python version manager
    poetry               # Dependency management & Packaging
    python311Full
    python311Packages.pynvml
    python311Packages.pip
    python311Packages.setuptools
    python311Packages.wheel
    python311Packages.rope

    python312Full
    python312Packages.pip
    python312Packages.setuptools
    python312Packages.wheel
    ruff-lsp             # Python LSP
    mypy                 # Static typing for python
    pipx                 # Isolated installs

    # Normy stuf
    typescript           # JavaScript superset
    vscode               # Emergency editor #PUKE
    sublime4     # Text editor

    # GNOME Extensions
    gnome.gnome-tweaks   # GNOME tweaking tool
    gnomeExtensions.pop-shell # GNOME tiling window extension

    # Fonts
    nerdfonts            # Patched developer fonts

    # Gaming
    lutris               # Gaming platform
    steam                # Why not I say...

    # Vulkan Dependencies
    vulkan-headers       # Vulkan API headers
    vulkan-loader        # Vulkan API loader
    vulkan-tools         # Vulkan tools
    vulkan-validation-layers # Vulkan validation layers
    vulkan-utility-libraries # Vulkan utility libraries

    # Wayland & Xorg
    grim                 # Grab images from a Wayland compositor
    slurp                # Select a region of a Wayland compositor
    waybar               # Status bar for Wayland
    xwayland             # XWayland shitfuckery.
    xwaylandvideobridge  # The bridge between good and evil..
    wayland              # Wayland display server
    wofi                 # Application launcher for Wayland
    wpaperd              # Wallpaper daemon for Wayland
    wl-clipboard         # command-line copy/paste utils for Wayland
    xorg.libXcursor      # Xorg cursor library
    xorg.libXi           # Xorg input library
    xorg.libXrandr       # Xorg RandR extension


    # Additional utilities and tools
    nil                  # Nix lsp
    nixfmt-classic       # ... if we're gonna have a lot of .nix files...
    taplo                # format toml
    patchelf             # Patch the linkers on ELF executables

    # WGSL & wgpu-stuff
    wgpu-utils           # Utilities for WGPU
    # wgsl_analyzer is cargo only :(

    # GpGPU
    cudaPackages.cuda_nvml_dev # CUDA NVML headers
    cudaPackages.cudatoolkit   # Compiler, maths libraries, tools
    #
  ];

  environment.variables = {
    EDITOR = "${pkgs.helix}/bin/hx";
    SUDO_EDITOR = "${pkgs.helix}/bin/hx";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # Enable services.
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.envfs.enable = true;


  # Podman (AINC WORK STUFF)
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?


# Auto Update
  system.autoUpgrade = {
    enable = true;
    # flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" 
    ];
    dates = "09:00";
    randomizedDelaySec = "45min";
  };


}
