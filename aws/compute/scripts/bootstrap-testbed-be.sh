#!/bin/bash
set -x

# create first user access
useradd -m -s /bin/bash yaw
mkdir -p /home/yaw/.ssh
chmod 700 /home/yaw/.ssh
echo "${yaw_public_key}" > /home/yaw/.ssh/authorized_keys
chmod 600 /home/yaw/.ssh/authorized_keys
chown -R yaw:yaw /home/yaw/.ssh
echo "yaw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/yaw
chmod 440 /etc/sudoers.d/yaw

# install docker
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker yaw

# write env file
mkdir -p /opt/app
cat > /opt/app/.env <<ENVFILE
POSTGRES_USER=${postgres_user}
POSTGRES_PASSWORD=${postgres_password}
ENVFILE

# install docker compose
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# pull docker compose file and run it
curl -H "Authorization: token ${github_token}" \
    -o /opt/app/docker-compose.yml \
    https://raw.githubusercontent.com/yawnartey/devopswiki-containerisation/dev/backend/docker-compose.yml

# login to docker
echo "${dockerhub_password}" | docker login -u ${dockerhub_username} --password-stdin

# spin up docker containers
cd /opt/app
docker-compose up -d

# set up certbot auto-renewal
echo "0 3 * * * certbot renew --quiet && /usr/local/bin/docker-compose -f /opt/app/docker-compose.yml restart frontend" | crontab -