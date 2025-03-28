{
  acl,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    tag = "v${version}";
    hash = "sha256-fToxRAcZOZvuuzaaWSjweqEwdUu3K2EKXY0K2Qixqpo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-i5wsS7y65sIvICfgViVIAbQU9f1E0EmspX+YVKDSKOU=";

  postPatch = ''
    # Upstream started to redirect aarch64-unknown-linux-gnu to aarch64-linux-gnu-gcc
    # for their CI which breaks compiling on aarch64 in nixpkgs:
    #  error: linker `aarch64-linux-gnu-gcc` not found
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilylange ];
    platforms = platforms.linux;
  };
}
