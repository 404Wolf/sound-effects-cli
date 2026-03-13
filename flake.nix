{
  description = "Simple CLI to play sound effects from a media folder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        sound-effects = pkgs.writeShellApplication {
          name = "sound-effects";
          runtimeInputs = [ pkgs.mpv pkgs.findutils ];
          text = ''
            MEDIA_DIR="${./media}"

            cmd="''${1:?Usage: sound-effects <play_NAME>}"
            name="''${cmd#play_}"

            file=$(find "$MEDIA_DIR" -maxdepth 1 -name "''${name}.*" -o -name "''${name}" | head -n1)

            if [[ -z "$file" ]]; then
              echo "No sound effect found for: $name" >&2
              exit 1
            fi

            exec mpv --no-video --really-quiet "$file"
          '';
        };
      in
      {
        packages = {
          default = sound-effects;
          sound-effects = sound-effects;
        };
      }
    );
}
