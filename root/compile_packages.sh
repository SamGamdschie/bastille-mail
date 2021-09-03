#!/bin/sh
portsnap fetch && portsnap update
portmaster -aBdNN

portmaster -i postfix dovecot dovecot-pigeonhole
