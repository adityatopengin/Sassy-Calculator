# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"
  
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
    pkgs.unzip
    # This magically installs Flutter for you!
    pkgs.flutter
  ];

  # Sets environment variables in the workspace
  env = {};

  idx = {
    # Extensions you want installed in your cloud editor automatically
    extensions = [
      "dart-code.flutter"
      "dart-code.dart-code"
    ];

    # This tells the cloud how to show your app on the right side of your tablet screen
    previews = {
      enable = true;
      previews = {
        # This creates a live Web preview
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        # This creates a live Android Emulator preview right in your browser
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
      };
    };
    
    # Run these commands when the workspace is first created
    workspace = {
      onCreate = {
        build-flutter = "flutter pub get";
      };
    };
  };
}

