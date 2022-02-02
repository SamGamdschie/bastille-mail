#!/bin/sh
portsnap auto 
pkg remove -f postfix dovecot dovecot-pigeonhole rspamd
portmaster --packages-build --delete-build-only postfix dovecot dovecot-pigeonhole rspamd
portmaster --clean-distfiles


