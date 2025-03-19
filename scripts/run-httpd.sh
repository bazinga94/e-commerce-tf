#!/bin/bash
sudo apt update -y
sudo apt-get install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2

# sudo mkdir /var/www/gci/
echo "<html>
<head>
  <title> Ubuntu rocks! </title>
</head>
<body>
  <p> I'm running this website on an Ubuntu Server server! </p>
</body>
</html>" | sudo tee /var/www/html/index.html > /dev/null

# sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/gci.conf

# echo "<VirtualHost *:80>
#     ServerAdmin arbaazij@umd.edu
#     DocumentRoot /var/www/gci/
#     ServerName midterms.com
#     <Directory /var/www/gci/>
#       AllowOverride All
#       Require all granted
#     </Directory>
#     ErrorLog \${APACHE_LOG_DIR}/gci_error.log
#     CustomLog \${APACHE_LOG_DIR}/gci_access.log combined
# </VirtualHost>" | sudo tee /etc/apache2/sites-available/gci.conf > /dev/null

# cd /etc/apache2/sites-available/

# sudo a2ensite gci.conf

sudo systemctl restart apache2 