#!/usr/bin/env bash

echo -e "\tOS Info" >&2
lsb_release -a 2>/dev/null

echo -e "\n\tQEMU" >&2
if [ -x "$(command -v qemu-system-x86_64)" ]; then
	qemu-system-x86_64 --version
else
	echo -e "qemu is not installed." >&2
fi
