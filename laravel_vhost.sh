#!/bin/bash

# Check if the project name argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

# Variables
PROJECT_NAME="$1"
WWW_PATH="/www"
PROJECT_ROOT="${WWW_PATH}/${PROJECT_NAME}"
DOCUMENT_ROOT="${PROJECT_ROOT}/public"
APACHE_CONF_DIR="/etc/apache2/sites-available"
CONF_FILE="${APACHE_CONF_DIR}/${PROJECT_NAME}.conf"
HOSTS_FILE="/etc/hosts"
CURRENT_USER=$(whoami)

# Check and create /www directory if it doesn't exist
if [ ! -d "${WWW_PATH}" ]; then
    echo "Creating /www directory..."
    sudo mkdir "${WWW_PATH}"
fi
cd "${WWW_PATH}"
sudo chown -R "${CURRENT_USER}:www-data" "${WWW_PATH}"
sudo chmod -R 775 "${WWW_PATH}"
pwd
# Check if the project directory exists
if [ ! -d "${PROJECT_ROOT}" ]; then
    echo "Creating project directory for ${PROJECT_NAME}..."
    composer create-project laravel/laravel "${PROJECT_NAME}" --prefer-dist
    sudo chown -R "${CURRENT_USER}:www-data" "${PROJECT_ROOT}"
    sudo chmod -R 775 "${PROJECT_ROOT}"
else
    echo "Project directory for ${PROJECT_NAME} already exists."
fi

# Create the Apache configuration file
echo "Creating Apache configuration for ${PROJECT_NAME}..."

sudo bash -c "cat > ${CONF_FILE}" <<EOL
<VirtualHost *:80>
    ServerName ${PROJECT_NAME}.test
    DocumentRoot ${DOCUMENT_ROOT}

    <Directory ${DOCUMENT_ROOT}>
        AllowOverride All
        Require all granted
        Options Indexes FollowSymLinks
    </Directory>

    <Directory ${PROJECT_ROOT}>
        AllowOverride All
        Require all granted
        Options Indexes FollowSymLinks
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${PROJECT_NAME}_error.log
    CustomLog \${APACHE_LOG_DIR}/${PROJECT_NAME}_access.log combined
</VirtualHost>
EOL

# Enable the site
echo "Enabling site ${PROJECT_NAME}.conf..."
sudo a2ensite "${PROJECT_NAME}.conf" > /dev/null

# Add the domain to /etc/hosts
if ! grep -q "${PROJECT_NAME}.test" "$HOSTS_FILE"; then
    echo "Adding ${PROJECT_NAME}.test to /etc/hosts..."
    echo "127.0.0.1 ${PROJECT_NAME}.test" | sudo tee -a "$HOSTS_FILE" > /dev/null
else
    echo "${PROJECT_NAME}.test already exists in /etc/hosts."
fi

# Reload Apache
echo "Reloading Apache server..."
if ! sudo systemctl reload apache2; then
    echo "Failed to reload Apache. Check the configuration and try again."
    exit 1
fi

echo "Apache configuration for ${PROJECT_NAME}.test created and enabled successfully!"
