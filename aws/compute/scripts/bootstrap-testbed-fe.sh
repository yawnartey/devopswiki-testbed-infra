#!/bin/bash
set -x
yum install -y ansible-core git

# checkout the playbooks
git clone -b dev https://github.com/yawnartey/devopswiki-ansible.git /tmp/devopswiki-ansible

# install base components
ansible-galaxy collection install -r /tmp/devopswiki-ansible/base-components/requirements.yml

# run the playbook
ansible-playbook /tmp/devopswiki-ansible/base-components/main.yml
ansible-playbook /tmp/devopswiki-ansible/frontend/main.yml

# create first user access (this is being handled by ansible create_user.yml file)
# useradd -m -s /bin/bash yaw
# mkdir -p /home/yaw/.ssh
# chmod 700 /home/yaw/.ssh
# echo "${yaw_public_key}" > /home/yaw/.ssh/authorized_keys
# chmod 600 /home/yaw/.ssh/authorized_keys
# chown -R yaw:yaw /home/yaw/.ssh
# echo "yaw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/yaw
# chmod 440 /etc/sudoers.d/yaw

# install docker (this is being handled by ansible)
# yum install -y docker
# systemctl enable docker
# systemctl start docker
# usermod -aG docker yaw

# install certbot (this is being handled by ansible)
# yum install -y certbot

# try copy certbot from bucket first (this is being handled by ansible)
# aws s3 cp s3://devops-wiki-letsencrypt-c9123c3a736c3547/testbed/letsencrypt /etc/letsencrypt --recursive 2>/dev/null

#run certbot if the file does not exist (this is being handled by ansible)
# if [ ! -f /etc/letsencrypt/live/test.devopswiki.info/fullchain.pem ]; then
#   certbot certonly --standalone -d test.devopswiki.info \
#     --non-interactive --agree-tos --email yawenochnartey@gmail.com
#   aws s3 cp /etc/letsencrypt s3://devops-wiki-letsencrypt-c9123c3a736c3547/testbed/letsencrypt --recursive
# fi

# write env file for nginx (now being handled by ansible)
# mkdir -p /opt/app
# chown -R yaw:yaw /opt/app
# cat > /opt/app/.env <<ENVFILE
# BE_PRIVATE_IP=${be_private_ip}
# SERVER_NAME=test.devopswiki.info
# CERT_DOMAIN=test.devopswiki.info
# ENVFILE

# install docker compose (this is being handled by ansible)
# curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# set up certbot auto-renewal (this is now being handled by ansible)
# yum install -y cronie
# systemctl enable --now crond
# echo "0 3 * * * certbot renew --quiet && /usr/local/bin/docker-compose -f /opt/app/docker-compose.yml restart frontend" | crontab -