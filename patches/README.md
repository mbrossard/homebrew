# Patches

 - openssh-sandbox.patch ([Original Source](https://gist.githubusercontent.com/jacknagel/e4d68a979dca7f968bdb/raw/f07f00f9d5e4eafcba42cc0be44a47b6e1a8dd2a/sandbox.diff)): this patch makes openssh work with the Mac OS X Sandbox.
 - openssh-launchd.patch ([Original Source](https://trac.macports.org/export/138238/trunk/dports/net/openssh/files/launchd.patch))
 - openssh-launchd-support.patch: extracted from  [keychain support patch](https://trac.macports.org/export/135165/trunk/dports/net/openssh/files/0002-Apple-keychain-integration-other-changes.patch) all parts related to launchd support.
 - openssh-pap-0.6.9p1.patch: add flag and support for PKCS#11 Protected Authentication Path to use middleware PIN entry.
 - openssh-exponent.patch: work-around for middleware exposing exponent values with leading zeroes.
