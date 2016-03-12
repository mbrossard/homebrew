class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.2p2.tar.gz"
  version "7.2p2"
  sha256 "a72781d1a043876a224ff1b0032daa4094d87565a68528759c1c2cab5482548c"

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
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-pkcs11-7.2p1.patch"
    sha256 "0b981b38b791e4a703f3096c3a75b27c8844014261fc1ca2067e1fc629d0c1a6"
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
