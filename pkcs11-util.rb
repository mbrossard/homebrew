class Pkcs11Util < Formula
  desc "Small tool to access cryptographic tokens through the PKCS#11 API."
  homepage "https://github.com/mbrossard/pkcs11"
  url "https://github.com/mbrossard/pkcs11/archive/v1.0.tar.gz"
  version "1.0"
  sha256 "64bf761b8c854f086087eb40c2e2cad08016ba16bb2d7110845b14c4e5e77ec9"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "openssl"
  depends_on "nss"

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"

    system "make", "install"
  end

  test do
    system "false"
  end
end
