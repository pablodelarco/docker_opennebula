# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies and clean up in the same layer
RUN apt-get update && apt-get install -y \
    gnupg2 wget apt-transport-https ca-certificates \
    ruby ruby-dev openssh-server openssh-client sudo \
    && rm -rf /var/lib/apt/lists/* \
    # Prevent SSH key generation during install
    && mkdir -p /etc/ssh \
    && touch /etc/ssh/sshd_config \
    && sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd \
    # Remove any generated keys
    && rm -f /etc/ssh/ssh_host_* \
    && rm -rf /var/lib/one/.ssh/* \
    && rm -rf /var/lib/one/.ssh-oneprovision/*

# Add OpenNebula repository and install packages
RUN mkdir -p /etc/apt/keyrings \
    && wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.10/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list \
    && apt-get update \
    && RUNLEVEL=1 apt-get install -y \
        opennebula opennebula-sunstone opennebula-fireedge \
        opennebula-gate opennebula-flow opennebula-provision \
    && rm -rf /var/lib/apt/lists/* \
    # Remove any keys that might have been generated
    && rm -f /etc/ssh/ssh_host_* \
    && rm -f /var/lib/one/.ssh/id_rsa* \
    && rm -f /var/lib/one/.ssh-oneprovision/id_rsa*

# Configure oneadmin and directories in one layer
RUN usermod -aG sudo oneadmin \
    && echo "oneadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /var/lib/one/.one /var/lib/one/.ssh /var/run/sshd /var/log/one /var/lock/one \
    && echo 'oneadmin:oneadmin' > /var/lib/one/.one/one_auth \
    && echo 'oneadmin:oneadmin' | chpasswd \
    && chown -R oneadmin:oneadmin /var/lib/one /var/log/one /var/lock/one \
    && chmod 600 /var/lib/one/.one/one_auth \
    && chmod 700 /var/lib/one/.ssh \
    && sudo -u oneadmin onedb init -f

# Expose ports
EXPOSE 2633 9869 2474 29876 2616 2222

# Copy and set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "service ssh start && \
    sudo -u oneadmin /usr/bin/oned && \
    sudo -u oneadmin /usr/bin/sunstone-server start && \
    sudo -u oneadmin /usr/bin/fireedge-server start && \
    sudo -u oneadmin /usr/bin/oneflow-server start && \
    sudo -u oneadmin /usr/bin/onegate-server start && \
    tail -f /var/log/one/*.log"]