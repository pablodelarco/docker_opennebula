# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

########################################
# 1. Install Base Dependencies & Prevent Auto-Generation of SSH Keys
########################################
RUN apt-get update && \
    apt-get install -y \
      gnupg2 \
      wget \
      apt-transport-https \
      ca-certificates \
      ruby \
      ruby-dev \
      openssh-server \
      openssh-client \
      sudo && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # Prepare SSH configuration to avoid automatic key generation
    mkdir -p /etc/ssh && \
    touch /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
    \
    # Remove any pre-generated SSH keys
    rm -f /etc/ssh/ssh_host_* && \
    rm -rf /var/lib/one/.ssh/* && \
    rm -rf /var/lib/one/.ssh-oneprovision/*

########################################
# 2. Add OpenNebula Repository & Install OpenNebula Packages
########################################
RUN mkdir -p /etc/apt/keyrings && \
    wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.10/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list && \
    apt-get update && \
    RUNLEVEL=1 apt-get install -y \
      opennebula \
      opennebula-sunstone \
      opennebula-fireedge \
      opennebula-gate \
      opennebula-flow \
      opennebula-provision && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # Remove any SSH keys that might have been generated during package install
    rm -f /etc/ssh/ssh_host_* && \
    rm -f /var/lib/one/.ssh/id_rsa* && \
    rm -f /var/lib/one/.ssh-oneprovision/id_rsa*

########################################
# 3. Configure oneadmin User & Required Directories
########################################
RUN usermod -aG sudo oneadmin && \
    echo "oneadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /var/lib/one/.one /var/lib/one/.ssh /var/run/sshd /var/log/one /var/lock/one && \
    echo 'oneadmin:oneadmin' > /var/lib/one/.one/one_auth && \
    echo 'oneadmin:oneadmin' | chpasswd && \
    chown -R oneadmin:oneadmin /var/lib/one /var/log/one /var/lock/one && \
    chmod 600 /var/lib/one/.one/one_auth && \
    chmod 700 /var/lib/one/.ssh && \
    sudo -u oneadmin onedb init -f

########################################
# 4. Expose Necessary Ports
########################################
EXPOSE 2633 9869 2474 29876 2616 2222

########################################
# 5. Copy and Set Up Entrypoint Script
########################################
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

########################################
# 6. Define Entrypoint and Default Command
########################################
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "service ssh start && \
    sudo -u oneadmin /usr/bin/oned && \
    sudo -u oneadmin /usr/bin/sunstone-server start && \
    sudo -u oneadmin /usr/bin/fireedge-server start && \
    sudo -u oneadmin /usr/bin/oneflow-server start && \
    sudo -u oneadmin /usr/bin/onegate-server start && \
    tail -f /var/log/one/*.log"]
