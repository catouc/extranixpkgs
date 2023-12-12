{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem ( system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        build = pkgs.python3Packages.buildPythonPackage rec {
          pname = "ytdl_sub";
          version = "2023.10.28";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/6e/c4/3182e5c1aa9246f0d3146b7d1aee00870b6135133165754bbffe2e3317c6/ytdl_sub-2023.10.28-py3-none-any.whl";
            hash = "sha256-SHF0F1qSPF97f1s3NC52OkuzxB9o51m7glB7/mnZSxk=";
          };
          doCheck = false;
          propagatedBuildInputs = [
            pkgs.argparse
            pkgs.python3Packages.colorama
            pkgs.python3Packages.mediafile
            pkgs.python3Packages.mergedeep
            pkgs.python3Packages.pyyaml
            pkgs.python3Packages.yt-dlp
          ];

          postInstall = ''
            wrapProgram $out/bin/ytdl-sub --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ffmpeg ]}
          '';
        };
      in
        rec {
          packages = {
            ytdl-sub = build;
            default = build;
          };

          nixosModules."services.ytdl-sub" = import "./nixos-module.nix";
        }
    );

}
