{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
  in {
    packages.x86_64-linux.ytdl-sub = pkgs.callPackage ./packages/ytdl-sub.nix { };
    packages.x86_64-linux.firefly-iii = pkgs.callPackage ./packages/firefly-iii.nix { };
    nixosModules."ytdl-sub" = import ./nixos-module.nix;
  };
}
