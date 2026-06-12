{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "willow-voice";
  version = "2.0.15";

  src = fetchurl {
    url = "https://willow-mac-download.s3.amazonaws.com/latest/Willow.Installer.dmg";
    hash = "sha256-7yCYQh2uUEG8QBlQXLoc8HDfouayod+ZGmysOg2UDqU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R "Willow Voice.app" "$out/Applications/Willow Voice.app"

    runHook postInstall
  '';

  dontFixup = true;

  meta = {
    description = "Voice dictation app for macOS";
    homepage = "https://willowvoice.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
