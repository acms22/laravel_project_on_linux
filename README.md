Laravel Project Setup Script with Apache Virtual Host Configuration
This Bash script automates the setup of a Laravel project in an Apache web server environment. It simplifies the process of creating a new Laravel project, setting up the necessary file permissions, and configuring Apache Virtual Hosts. Ideal for developers looking to quickly spin up Laravel projects with minimal manual effort.

Key Features
Automated Laravel Installation: Installs a new Laravel project using Composer.
Customizable User Permissions: Accepts a username argument to set ownership and permissions.
Apache Virtual Host Configuration: Automatically creates and enables an Apache Virtual Host for the project.
Local Domain Setup: Adds the project's domain (e.g., project-name.test) to /etc/hosts.
Error Handling: Ensures directories and configurations are created safely and warns if steps fail.
User-Friendly: Provides helpful prompts and error messages for seamless execution.
Usage
bash
Copier
Modifier
# Basic usage (default user is the current user)
./setup-laravel.sh <project-name>

# Specify a username for ownership
./setup-laravel.sh <project-name> <username>
Example
bash
Copier
Modifier
# Create a Laravel project named "myproject" with ownership set to "john"
./setup-laravel.sh myproject john
Prerequisites
Apache web server installed and running.
Composer installed on the server.
Sudo privileges for the executing user.
What the Script Does
Creates the /www directory if it doesn’t exist.
Installs a Laravel project in /www/<project-name>.
Sets appropriate ownership and permissions for the project files.
Configures an Apache Virtual Host for the project.
Adds the project domain (e.g., project-name.test) to /etc/hosts.
Reloads Apache to apply changes.
Notes
Ensure you have sudo access as the script performs system-level changes.
Modify the script as needed to match your specific server environment.
This description highlights the script’s purpose, features, and usage while maintaining a professional and engaging tone.
