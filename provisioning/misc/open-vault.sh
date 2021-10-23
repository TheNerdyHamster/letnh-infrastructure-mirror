#!/bin/sh
gpg --batch --decrypt --quiet "$(dirname $0)/vault_passphrase.gpg"
