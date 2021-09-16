#!/bin/sh
portsnap auto 
portmaster -addwG -x postfix dovecot dovecot-pigeonhole
pkg remove -f postfix dovecot dovecot-pigeonhole
portmaster --packages-build --delete-build-only postfix dovecot dovecot-pigeonhole
portmaster --clean-distfiles


