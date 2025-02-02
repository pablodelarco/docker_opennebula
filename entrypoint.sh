#!/bin/bash
set -e

# Generate SSH host keys if missing
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating new SSH host keys..."
    ssh-keygen -A
fi

# Generate user SSH keys if missing
if [ ! -f /var/lib/one/.ssh/id_rsa ]; then
    echo "Generating user SSH keys..."
    ssh-keygen -t rsa -N "" -f /var/lib/one/.ssh/id_rsa
    chown oneadmin:oneadmin /var/lib/one/.ssh/id_rsa*
    chmod 600 /var/lib/one/.ssh/id_rsa
    chmod 644 /var/lib/one/.ssh/id_rsa.pub
fi

# Start services
exec "$@"