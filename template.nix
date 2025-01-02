{
  stdenvNoCC,
  lib,
  python312,
  python312Packages,
}:
stdenvNoCC.mkDerivation {
  name = "lessons";

  nativeBuildInputs = [
    python312
    python312Packages.jinja2
  ];

  src = lib.cleanSource ./.;

  buildPhase = ''
    python template.py
  '';

  installPhase = ''
    mkdir -p $out
    cp out/* $out
  '';
}
