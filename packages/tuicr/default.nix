{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tuicr";
  version = "0.24.0";

  src = fetchurl {
    url = "https://github.com/agavra/tuicr/releases/download/v${finalAttrs.version}/tuicr-${finalAttrs.version}-aarch64-apple-darwin.tar.gz";
    hash = "sha256-JWMXmAM6ZDT2BCxvUbM6bOkYhA4VyrKQ6ZL/3pqHie4=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 tuicr "$out/bin/tuicr"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    test "$("$out/bin/tuicr" --version)" = "tuicr ${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "Code review TUI with Vim keybindings";
    homepage = "https://github.com/agavra/tuicr";
    license = lib.licenses.mit;
    mainProgram = "tuicr";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
