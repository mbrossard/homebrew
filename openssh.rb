class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz"
  version "7.3p1"
  sha256 "3ffb989a6dcaa69594c3b550d4855a5a2e1718ccdde7f5e36387b424220fbecc"

  option "with-libressl", "Build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-sandbox-7.2p1.patch"
    sha256 "b4d731c8b4dc4aaf0498fb4afc1f41eb784182d401e9d90e02b2c10e79feb728"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-launchd-7.2p1.patch"
    sha256 "9b8d752cc54028a1d5e7b476533a65ec9106e380ec176536cfde25213464429b"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-ecdsa-pkcs11-7.2p2.patch"
    sha256 "f0f7ced6fd5f711ec4e38855676ffbb3ec4214c9f77f951db8979fac05e6a2f6"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-pkcs11-7.2p2.patch"
    sha256 "0558abece028c00594dfb62e33d8f4fded770553685debc0c578270c644635a7"
  end

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__ -D__APPLE_LAUNCHD__"

    args = %W[
      --with-libedit
      --with-pam
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
    ]

    if build.with? "libressl"
      args << "--with-ssl-dir=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    end

    args << "--with-ldns" if build.with? "ldns"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
