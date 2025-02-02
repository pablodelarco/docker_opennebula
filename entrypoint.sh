#!/bin/bash

# Generate SSH keys if they don't exist
if [ ! -f /var/lib/one/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f /var/lib/one/.ssh/id_rsa
    chown oneadmin:oneadmin /var/lib/one/.ssh/id_rsa*
    chmod 600 /var/lib/one/.ssh/id_rsa
    chmod 644 /var/lib/one/.ssh/id_rsa.pub
fi

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
    ssh-keygen -t ecdsa -N "" -f /etc/ssh/ssh_host_ecdsa_key
    ssh-keygen -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key
    chmod 600 /etc/ssh/ssh_host_*_key
    chmod 644 /etc/ssh/ssh_host_*_key.pub
fi

# Start services
exec "$@"