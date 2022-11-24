# bastille-mail
BastilleBSD template for mail at WerzelServer

## Base Configuration
The configuration is based on the guide at https://www.c0ffee.net/blog/mail-server-guide/ using Postfix, Dovecot, Rspamd, and Sieve for an up-to-date Mailserver.
This is adapted to use MySQL/MariaDB as storage for username/password.

For converting / backing up old server, see [DoveAdm - Backup](https://wiki.dovecot.org/Tools/Doveadm/Sync).

### Indexing mailboxes
After configuration and setup, start indexing all mailboxes using ```doveadm index -A inbox```.

### Comments of Postfix install
To use postfix instead of sendmail:
  - clear sendmail queue and stop the sendmail daemons

Run the following commands to enable postfix during startup:
  - sysrc postfix_enable="YES"
  - sysrc sendmail_enable="NONE"

If postfix is *not* already activated in /usr/local/etc/mail/mailer.conf
  - mv /usr/local/etc/mail/mailer.conf /usr/local/etc/mail/mailer.conf.old
  - install -d /usr/local/etc/mail
  - install -m 0644 /usr/local/share/postfix/mailer.conf.postfix /usr/local/etc/mail/mailer.conf

Disable sendmail(8) specific tasks,
add the following lines to /etc/periodic.conf(.local):
  daily_clean_hoststat_enable="NO"
  daily_status_mail_rejects_enable="NO"
  daily_status_include_submit_mailq="NO"
  daily_submit_queuerun="NO"

If you are using SASL, you need to make sure that postfix has access to read
the sasldb file.  This is accomplished by adding postfix to group mail and
making the /usr/local/etc/sasldb* file(s) readable by group mail (this should
be the default for new installs).

