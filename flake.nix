{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    build = pkgs.python3Packages.buildPythonPackage {
      pname = "ytdl_sub";
      version = "2023.10.28";
      format = "wheel";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d7/31/e54f74f566c93b0088fdd5895e876d369b8384016747ee2898701458488f/ytdl_sub-2023.11.25-py3-none-any.whl";
        hash = "sha256-iah45MLJZwwfEYgCGLxu0WdT+85B2+NdG/TNPbp+C4U=";
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
    };
    in {
      packages.x86_64-linux.ytdl-sub = build;
      nixosModules."ytdl-sub" = import ./nixos-module.nix;
  };
}
