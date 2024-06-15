#!/bin/bash
exec > /var/log/startup-script.log 2>&1
set -x

# Function to extract zone information
get_zone() {
    local zone_full=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H "Metadata-Flavor: Google")
    local zone=$(basename "$zone_full")
    echo "$zone"
}


# Update package repositories and install Apache
sudo apt update
sudo apt -y install apache2

# Define HTML content for the Apache home page
sudo bash -c "cat <<EOF > /var/www/html/index.html
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Welcome to Apache</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background-color: #004d4d; 
            color: #ffffff; 
            margin: 0; 
            padding: 0; 
        }
        .container { 
            max-width: 800px; 
            margin: 50px auto; 
            background-color: #006666; 
            padding: 20px; 
            border-radius: 5px; 
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); 
        }
        h1 { color: #ffffff; text-align: center; }
        p { color: #d9d9d9; text-align: left; }
        b { color: #f7f7f7e4; }
        .value-placeholder { color: #ffffff; }
        h2 { color: #ffffff; text-align: center; margin-top: 40px; font-family:'Times New Roman', Times, serif;}
        .social-icon { 
            font-size: 1.5em; 
            color: #ffffff; 
            margin: 0 5px; 
        }
        .social-icon:hover { 
            color: #d9d9d9; 
        }
        .social-container { text-align: center; }
    </style>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class=\"container\">
        <h1>Welcome to the Home Page</h1>
        <p><b>This is the default home page for the Apache web server running on:</b> <span class=\"value-placeholder\">\$(hostname)</span>.</p>
        <p><b>Server IP Address:</b> <span class=\"value-placeholder\">\$(hostname -i)</span></p>
        <p><b>Server Domain:</b> <span class=\"value-placeholder\">\$(hostname -d)</span></p>
        <p><b>Zone:</b> <span class=\"value-placeholder\">$(get_zone)</span></p>
        <h2>Tech with Thulitha</h2>
        <div class=\"social-container\">
            <a href=\"https://github.com/ThulithaNawagamuwa\" class=\"mx-2\" target=\"_blank\"><i class=\"fab fa-github social-icon\"></i></a>
            <a href=\"https://medium.com/@thulitha_n\" class=\"mx-2\" target=\"_blank\"><i class=\"fab fa-medium social-icon\"></i></a>
            <a href=\"https://www.linkedin.com/in/thulitha-nawagamuwa/\" class=\"mx-2\" target=\"_blank\"><i class=\"fab fa-linkedin-in social-icon\"></i></a>
        </div>
    </div>
</body>
</html>
EOF"


sudo mkdir /var/www/html/home/

# copy the home page to /home directory
sudo cp /var/www/html/index.html /var/www/html/home/index.html


# Update 000-default.conf file
sudo sed -i '/# The ServerName directive/a\
    Alias "/home_page" "/var/www/html/home"\
' /etc/apache2/sites-available/000-default.conf

# Start Apache and enable it to start on boot
sudo systemctl start apache2
sudo systemctl enable apache2
