#!/usr/bin/env bash -ex

cat <<CONFIG

echo -e "codepot1337\ncodepot1337" | passwd

cat <<EOF > /etc/config/dropbear || exit 1
config dropbear
	option PasswordAuth 'off'
	option Port '22'
EOF

CONFIG

