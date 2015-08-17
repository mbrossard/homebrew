class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.9p1.tar.gz"
  mirror "https://fossies.org/linux/misc/openssh-6.9p1.tar.gz"
  version "6.9p1"
  sha256 "6e074df538f357d440be6cf93dc581a21f22d39e236f217fcd8eacbb6c896cfe"

  option "with-libressl", "Build with LibreSSL instead of OpenSSL"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-sandbox.patch"
    sha256 "82c287053eed12ce064f0b180eac2ae995a2b97c6cc38ad1bdd7626016204205"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-launchd.patch"
    sha256 "012ee24bf0265dedd5bfd2745cf8262c3240a6d70edcd555e5b35f99ed070590"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-launchd-support.patch"
    sha256 "9dc71f3485c525dc289528353b675d84ebf23bc64ec89998da92e1a3c77d3fc9"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-pap-0.6.9p1.patch"
    sha256 "665c5d6f026a1beafaf7160f80cc003cc5dc3d0a9a804423191873e50f5c60d8"
  end

  patch do
    url "https://raw.githubusercontent.com/mbrossard/homebrew-dupes/master/patches/openssh-exponent.patch"
    sha256 "3d32d794086f754229727a7b2a9905edccdd6f9860e23f76720b2bb4c991d7e7"
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
