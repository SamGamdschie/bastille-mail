#!/bin/sh
portsnap auto 
pkg remove -f postfix dovecot dovecot-pigeonhole rspamd
portmaster --packages-build --delete-build-only mail/postfix mail/dovecot mail/dovecot-pigeonhole mail/rspamd mail/dcc-dccd
portmaster --clean-distfiles


