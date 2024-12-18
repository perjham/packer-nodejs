#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 22.12.0
node -e "console.log('Running Node.js ' + process.version)"
node -v
npm -v
cat > hello.js << EOF
const http = require('http');

const hostname = 'localhost';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World!\n');
});

server.listen(port, hostname, () => {
  console.log(\`Server running at http://\${hostname}:\${port}/\`);
});
EOF

npm install pm2@latest -g
pm2 start hello.js
pm2 startup systemd
sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v22.12.0/bin /home/ec2-user/.nvm/versions/node/v22.12.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save
sudo systemctl enable pm2-ec2-user
sudo systemctl start pm2-ec2-user
sudo systemctl status pm2-ec2-user --no-pager --full

sudo dnf install nginx -y

cat > hello.conf << EOF
server {
    listen 80;
    server_name 0.0.0.0; # Reemplaza con tu dominio o IP pública

    location / {
        proxy_pass http://localhost:3000; # Dirección de tu aplicación Node.js
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade ;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo mv hello.conf /etc/nginx/conf.d/
sudo systemctl restart nginx
sudo systemctl enable nginx
