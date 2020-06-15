{ stdenv, xorg, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "Wind";
  version = "1.2";

  src = fetchFromGitHub {
    owner  = "SeungheonOh";
    repo   = "Wind";
    rev    = "1.2";
    sha256 = "0501hlfis5yr1fcv41w4hwp1d1xlaqrsag8lq6ww6rn3fz18vrr7";
  };

  buildInputs = with xorg; [
   libX11
   libXext
  ];

  buildFlags = ''PREFIX=$(out)'';

  installFlags = ''PREFIX=$(out)'';

  meta = {
    description = "Non-bloat window manager";
    homepage = https://github.com/SeungheonOh/Wind/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ "Seungheon Oh  dan.oh0721@gmail.com" ];
  };
}
