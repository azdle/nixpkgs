{ fetchurl, stdenv, gettext, gdbm, libtool, pam, readline
, ncurses, gnutls, sasl, fribidi, gss , mysql, guile, texinfo,
  gnum4, dejagnu, nettools }:

stdenv.mkDerivation rec {
  name = "mailutils-2.2";

  src = fetchurl {
    url = "mirror://gnu/mailutils/${name}.tar.bz2";
    sha256 = "0szbqa12zqzldqyw97lxqax3ja2adis83i7brdfsxmrfw68iaf65";
  };

  hardeningDisable = [ "format" ];

  patches = [ ./path-to-cat.patch ./no-gets.patch ./scm_c_string.patch ];

  postPatch = ''
    sed -i -e '/chown root:mail/d' \
           -e 's/chmod [24]755/chmod 0755/' \
      */Makefile{,.in,.am}
  '';

  configureFlags = [
    "--with-gsasl"
    "--with-gssapi=${gss}"
  ];

  buildInputs =
   [ gettext gdbm libtool pam readline ncurses
     gnutls mysql.connector-c guile texinfo gnum4 sasl fribidi gss nettools ]
   ++ stdenv.lib.optional doCheck dejagnu;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Rich and powerful protocol-independent mail framework";

    longDescription = ''
      GNU Mailutils is a rich and powerful protocol-independent mail
      framework.  It contains a series of useful mail libraries, clients, and
      servers.  These are the primary mail utilities for the GNU system.  The
      central library is capable of handling electronic mail in various
      mailbox formats and protocols, both local and remote.  Specifically,
      this project contains a POP3 server, an IMAP4 server, and a Sieve mail
      filter.  It also provides a POSIX `mailx' client, and a collection of
      other handy tools.

      The GNU Mailutils libraries supply an ample set of primitives for
      handling electronic mail in programs written in C, C++, Python or
      Scheme.

      The utilities provided by Mailutils include imap4d and pop3d mail
      servers, mail reporting utility comsatd, general-purpose mail delivery
      agent maidag, mail filtering program sieve, and an implementation of MH
      message handling system.
    '';

    license = with licenses; [
      lgpl3Plus /* libraries */
      gpl3Plus /* tools */
    ];

    maintainers = with maintainers; [ vrthra ];

    homepage = http://www.gnu.org/software/mailutils/;

    # Some of the dependencies fail to build on {cyg,dar}win.
    platforms = platforms.gnu;
  };
}
