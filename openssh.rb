class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.3p1.tar.gz"
  version "7.4p1"
  sha256 "1b1fc4a14e2024293181924ed24872e6f2e06293f3e8926a376b8aec481f19d1"

  option "with-libressl", "Build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-sandbox-7.4p1.patch"
    sha256 "82d2b5f6f91fb5929a2a9fc6cfee97481ef4e5e1f1c6b7123005cde21ba3bf3c"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-launchd-7.4p1.patch"
    sha256 "923907809dab8cb2621f6dc0fc38a41d920e17a4e424f979a35a3bedc5900c1c"
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
