#!/bin/sh
path=$(dirname $0)
pwgen -cynCs 64 1 > $path/new-pw

for i in $(ag ANSIBLE_VAULT -l --ignore *.sh); do
    ansible-vault rekey --new-vault-password-file $path/new-pw $i;
done

cat $path/new-pw | gpg -e -o $path/vault_passphrase.gpg
rm $path/new-pw
