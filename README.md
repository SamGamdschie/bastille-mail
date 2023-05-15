# bastille-mail
BastilleBSD template for mail at WerzelServer

## Base Configuration
The configuration is based on the guide at https://www.c0ffee.net/blog/mail-server-guide/ using Postfix, Dovecot, Rspamd, and Sieve for an up-to-date Mailserver.
This is adapted to use MySQL/MariaDB as storage for username/password.

### Configuration
The template will mount the following host directories
- /werzel/server_config/dovecot read-only
- /werzel/server_config/rspamd/local.d read-only
- /werzel/server_config/postfix read-only
- /werzel/server_config/postfix-policyd-spf-python read-only
- /werzel/mail
- /werzel/certificates
The first four directories are used to link specific files to certain config files in jail. Thus configuration can be changed from outside jail.
Also, the TLS-certificates are used from /werzel/certificates using /www/certificates inside jail. This allows to use another jail to creat letsenrypt certificates.

Additionally, the mail data directory /var/mail is mounted from host (read-write-mode) to be able use external / shared storage and backup techniques from outside jail.

In future maybe some default configuration will be made available; currently tr to find out.

### DKIM / DMARC
Generate your DKIM keys using rspamdadm
```sh
rspamadm dkim_keygen -k /var/db/rspamd/dkim/example.com.dkim.key -b 2048 -s dkim -d example.com
```

Now add the public key to your DNS:
```
dkim._domainkey IN TXT ( "v=DKIM1; k=rsa; "
  "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzGdxkFW0tIDYdNrGyj/J2Hff7N/9BEWE2qxMw6PBW5FhJRullZT9WNZOVrrXk1TsiBHRq8YQrSS1TfLbNV9PE7sE0vGx0eLgkiqnqLMwTy5Y9+jEbiNrddNR6v+TGHuMckYJO3JMjiROhMi/86Lv6P/rv2R/lxFldCeYQxa41/8LH+b3ZXWTLYRM6y2/2UpGz/wtknvA+DtO0rn+Y"
  "uLuPrh+ftzmJb6i3g01XFgAO8ZzMLMdO/k7UJDX/Q6himKxVv2t3vSvS1MGqiWThXiU3WxhQED0zZUlkC5Lfx4BCo1h0v7fwZeMdu2NPOzlDBMDq5HRYgbwuFXTAmxSM7WRqQIDAQAB"
) ;
```
Now also give your policies regarding SPF and DKIM
```
_dmarc  IN  TXT  "v=DMARC1; p=reject; adkim=r; aspf=r; sp=reject"
```
Further reading in German: https://kb.mailbox.org/de/privat/e-mail-mit-eigener-domain/spam-reputation-der-eigenen-domain-verbessern-mit-spf-dkim-und-dmarc


### Sync mailboxes with old server
```sh
imapsync --host1 xxx.xxx.de --user1 bla@wxxx.de --passfile1 ./password1 --authmech1 CRAM-MD5 --host2 10.0.0.10 --user2 xxx@blub.de --passfile2 ./password2
```

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

