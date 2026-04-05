{
  lib,
  self,
  buildGoModule,
  git,
  pkgs,
  ...
}:
buildGoModule {
  pname = "beads";
  version = "1.0.0";

  src = self;

  # Point to the main Go package
  subPackages = [ "cmd/bd" ];
  doCheck = false;

  # Go module dependencies hash - if build fails with hash mismatch, update with the "got:" value
  vendorHash = "sha256-7DJgqJX2HDa9gcGD8fLNHLIXvGAEivYeDYx3snCUyCE=";

  # Relax go.mod version for Nix: nixpkgs Go may lag behind the latest
  # patch release, and GOTOOLCHAIN=auto can't download in the Nix sandbox.
  postPatch = ''
    goVer="$(go env GOVERSION | sed 's/^go//')"
    go mod edit -go="$goVer"
  '';

  # Allow patch-level toolchain upgrades when a dependency's minimum Go patch
  # version is newer than nixpkgs' bundled patch version.
  env.GOTOOLCHAIN = "auto";

  buildInputs = [ pkgs.icu ];

  # Git is required for tests
  nativeBuildInputs = [ git ];

  meta = with lib; {
    description = "beads (bd) - An issue tracker designed for AI-supervised coding workflows";
    homepage = "https://github.com/steveyegge/beads";
    license = licenses.mit;
    mainProgram = "bd";
    maintainers = [ ];
  };
}
