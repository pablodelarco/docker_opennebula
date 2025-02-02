#!/bin/bash
set -e

# Generate host keys if missing
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# Generate user keys for both locations
for KEY_PATH in /var/lib/one/.ssh/id_rsa /var/lib/one/.ssh-oneprovision/id_rsa; do
    if [ ! -f "${KEY_PATH}" ]; then
        echo "Generating ${KEY_PATH}..."
        ssh-keygen -t rsa -N "" -f "${KEY_PATH}"
        chown oneadmin:oneadmin "${KEY_PATH}"*
        chmod 600 "${KEY_PATH}"
        chmod 644 "${KEY_PATH}.pub"
    fi
done

# Start services
exec "$@"