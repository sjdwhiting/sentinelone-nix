{ stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, zlib
, libelf
, dmidecode
, jq
, gcc-unwrapped
}:
let
  sentinelOnePackage = "SentinelAgent-Linux-22-3-3-11-x86-64-release-22-3-3_linux_v22_3_3_11.deb";
in
stdenv.mkDerivation {
  pname = "sentinelone";
  version = "24.1.2.6";

  src = fetchurl {
    url = "https://sebsec.s3.amazonaws.com/SentinelAgent_linux_v22_4_2_4.deb";
    hash = "sha256-vs1kFD5vHaVur30ebemExTMAfK44f70njvWe03rSpMI=";
  };

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    zlib
    libelf
    dmidecode
    jq
    gcc-unwrapped
  ];

  installPhase = ''
    mkdir -p $out/opt/
    mkdir -p $out/cfg/
    mkdir -p $out/bin/

    cp -r opt/* $out/opt
    
    ln -s $out/opt/sentinelone/bin/sentinelctl $out/bin/sentinelctl
    ln -s $out/opt/sentinelone/bin/sentinelone-agent $out/bin/sentinelone-agent
    ln -s $out/opt/sentinelone/bin/sentinelone-watchdog $out/bin/sentinelone-watchdog
    ln -s $out/opt/sentinelone/lib $out/lib
  '';
}
