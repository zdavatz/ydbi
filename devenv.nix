{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.git pkgs.libyaml pkgs.nodejs];

  enterShell = ''
    echo This is the devenv shell for oddb2xml
    git --version
    ruby --version
  '';

  env.FREEDESKTOP_MIME_TYPES_PATH = "${pkgs.shared-mime-info}/share/mime/packages/freedesktop.org.xml";

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  languages.ruby.enable = true;
  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;
  # uncomment one of the following to lines to define the ruby version
  languages.ruby.versionFile = ./.ruby-version;
  # languages.ruby.package = pkgs.ruby_3_2;

  services.postgres = {
    enable = true;
    package = pkgs.postgresql_16;
    listen_addresses = "0.0.0.0";
    port = 5439;

    # please keep the definitions in sync between test/ts_dbd.rb and devenv.nix!
    initialDatabases = [
      { name = "ydbi_pg"; }
    ];
    initialScript = ''
      create role ydbi_pg superuser login password null;
    '';

    initdbArgs =
      [
        "--locale=C"
        "--encoding=UTF8"
      ];

  };


  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
