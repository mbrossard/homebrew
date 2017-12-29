class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz"
  mirror "https://www.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz"
  version "7.6p1"
  sha256 "a323caeeddfe145baaa0db16e98d784b1fbc7dd436a6bf1f479dfd5cd1d21723"

  option "with-libressl", "Build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/7.6p1/patches/openssh-sandbox-7.6p1.patch"
    sha256 "57b8d15631b6218f386aa0eb40dd34f3d2fedd0bc1671f1081d35b563ec2b7bc"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/7.6p1/patches/openssh-launchd-7.6p1.patch"
    sha256 "298239304515a586a0b5b7199b345ae411149e5b3784a1db2949b6390d6bc367"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/7.6p1/patches/openssh-ecdsa-pkcs11-7.6p1.patch"
    sha256 "53ecf64e75a8b7a9a51360b79dd25b7cc26668d40f408d430dd08e033f031357"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/7.6p1/patches/openssh-pkcs11-7.6p1.patch"
    sha256 "45eb8df7034f0f755e8f10cb23ed4e7c3f0332a67e410497584681543d10a7f6"
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
