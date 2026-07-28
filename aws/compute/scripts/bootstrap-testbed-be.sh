#!/bin/bash
set -x
yum install -y ansible-core git

# checkout the playbooks
git clone -b dev https://github.com/yawnartey/devopswiki-ansible.git /tmp/devopswiki-ansible

# install base components
ansible-galaxy collection install -r /tmp/devopswiki-ansible/base-components/requirements.yml

# run the playbook
ansible-playbook /tmp/devopswiki-ansible/base-components/main.yml
ansible-playbook /tmp/devopswiki-ansible/backend/main.yml

# create first user access (now being handled by ansible)
# useradd -m -s /bin/bash yaw
# mkdir -p /home/yaw/.ssh
# chmod 700 /home/yaw/.ssh
# echo "${yaw_public_key}" > /home/yaw/.ssh/authorized_keys
# chmod 600 /home/yaw/.ssh/authorized_keys
# chown -R yaw:yaw /home/yaw/.ssh
# echo "yaw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/yaw
# chmod 440 /etc/sudoers.d/yaw

# install docker (now being handled by ansible)
# yum install -y docker
# systemctl enable docker
# systemctl start docker
# usermod -aG docker yaw

# write env file (this is now being handled by ansible)
# mkdir -p /opt/app
# chown -R yaw:yaw /opt/app
# cat > /opt/app/.env <<ENVFILE
# POSTGRES_USER=${postgres_user}
# POSTGRES_PASSWORD=${postgres_password}
# ENVFILE

# install docker compose (now being handled by ansible)
# curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# set up certbot auto-renewal (not needed since we don't need certbot at the backend)
# echo "0 3 * * * certbot renew --quiet && /usr/local/bin/docker-compose -f /opt/app/docker-compose.yml restart frontend" | crontab -