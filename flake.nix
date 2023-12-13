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
        }
  );
}
