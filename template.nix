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

  src =
    let
      lessonsFilter = path: type: !(lib.hasPrefix "${toString ./.}/lessons" path);
    in
    lib.cleanSourceWith {
      src = ./.;
      filter =
        path: type:
        builtins.all (f: f path type) [
          lib.cleanSourceFilter
          lessonsFilter
        ];
    };

  buildPhase = ''
    python template.py
  '';

  installPhase = ''
    mkdir -p $out
    cp out/* $out
  '';
}
