{
  appimageTools,
  stdenv,
  fetchurl,
  lib,
}:

let
  pname = "yaak";
  version = "2025.1.1";

  source =
    {
      x86_64-linux = {
        name = "${pname}_${version}_amd64";
        hash = "sha256-AkJwoG2rj65pQCno9qL8Tox9KYXAkZjLHRg5NBbe04M=";
      };
    }
    .${stdenv.system} or (throw "${stdenv.system} is unsupported.");
in
appimageTools.wrapType2 rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/mountain-loop/yaak/releases/download/v${version}/${source.name}.AppImage";
    inherit (source) hash;
  };

  contents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/yaak.desktop --replace-fail 'yaak-app' 'yaak'
    '';
  };

  extraInstallCommands = ''
    install -Dm444 ${contents}/yaak.desktop $out/share/applications/yaak.desktop

    for size in "32x32" "128x128" "256x256@2"; do
      install -Dm444 ${contents}/usr/share/icons/hicolor/$size/apps/yaak-app.png $out/share/icons/hicolor/$size/apps/yaak.png
    done
  '';

  meta = {
    description = "Desktop API client for organizing and executing REST, GraphQL, and gRPC requests";
    homepage = "https://yaak.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ syedahkam ];
    mainProgram = "yaak";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
