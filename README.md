# bastille-mail
BastilleBSD template for mail at WerzelServer

## Base Configuration
The configuration is based on the guide at https://www.c0ffee.net/blog/mail-server-guide/ using Postfix, Dovecot, Rspamd, and Sieve for an up-to-date Mailserver.
This is adapted to use MySQL/MariaDB as storage for username/password.

For converting / backing up old server, see [DoveAdm - Backup](https://wiki.dovecot.org/Tools/Doveadm/Sync).

### Indexing mailboxes
After configuration and setup, start indexing all mailboxes using ```doveadm index -A inbox```.