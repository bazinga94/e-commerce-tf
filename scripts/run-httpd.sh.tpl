#!/bin/bash
# Update and install necessary packages
sudo apt update -y
sudo apt-get install -y apache2 git mysql-client

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Create a simple HTML page
echo "<html>
<head>
  <title> Ubuntu rocks! </title>
</head>
<body>
  <p> I'm running this website on an Ubuntu Server! </p>
</body>
</html>" | sudo tee /var/www/html/index.html > /dev/null

# Restart Apache
sudo systemctl restart apache2 

# Clone the Git repository
git clone https://github.com/arbaaz29/e-commerce-db.git
cd e-commerce-db || exit

# Download RDS SSL certificate
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Load SQL data into the database
mysql -h ${mysqlendpoint} -u ${username} --ssl-ca=global-bundle.pem --ssl-mode=REQUIRED -p"${ecomdbpasswd}" < ecommerce_1.sql
