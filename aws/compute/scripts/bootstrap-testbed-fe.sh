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

# install certbot 
yum install -y certbot

# try copy certbot from bucket first 
aws s3 cp s3://devopswiki-testbed-letsencrypt-8daccc39b5d2c2e9/letsencrypt /etc/letsencrypt --recursive 2>/dev/null

#run certbot if the file does not exist
if [ ! -f /etc/letsencrypt/live/test.devopswiki.info/fullchain.pem ]; then
  certbot certonly --standalone -d test.devopswiki.info \
    --non-interactive --agree-tos --email yawenochnartey@gmail.com
  aws s3 cp /etc/letsencrypt s3://devopswiki-testbed-letsencrypt-8daccc39b5d2c2e9/letsencrypt --recursive
fi

# write env file for nginx
mkdir -p /opt/app
chown -R yaw:yaw /opt/app
cat > /opt/app/.env <<ENVFILE
BE_PRIVATE_IP=${be_private_ip}
SERVER_NAME=test.devopswiki.info
CERT_DOMAIN=test.devopswiki.info
ENVFILE

# install docker compose
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# set up certbot auto-renewal
echo "0 3 * * * certbot renew --quiet && /usr/local/bin/docker-compose -f /opt/app/docker-compose.yml restart frontend" | crontab -