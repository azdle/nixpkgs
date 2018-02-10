{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "cobalt-${version}";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "0ry64jvnalkklb8ppg7yzbljm6m9lwc8sallzm0v3gs0d5r6g9cc";
  };

  cargoSha256 = "1d6s01gmyfzb0vdf7flq6nvlapwcgbj0mzcprzyg4nj5gjkvznrn";
  depsSha256 = "1d6s01gmyfzb0vdf7flq6nvlapwcgbj0mzcprzyg4nj5gjkvznrn";

  preFixup = ''
    mkdir -p "$out/man/man1"
    cp "$src/doc/rg.1" "$out/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "A straightforward static site generator written in Rust.";
    homepage = https://github.com/cobalt-org/cobalt.rs;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ azdle ];
    platforms = platforms.all;
  };
}
