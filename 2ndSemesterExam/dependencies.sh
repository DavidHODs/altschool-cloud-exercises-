#!/usr/bin/bash

#list of packages needed
packages=('git' 'apache2' 'php8.1-pgsql' 'php8.1-xml' 'php8.1-curl' 'postgresql' 'postgresql-contrib')

log=~/Desktop/AltSchool/2ndSemesterExam/log.log
errorLog=~/Desktop/AltSchool/2ndSemesterExam/error.log
host=$(hostname -I)
key=$(< ~/Desktop/AltSchool/.key)

# function to update all packages
function packageUpdate {
    sudo apt-get update -y 
}

function dependenciesInstallation {
    # installs dependencies needed for php8.1
    sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https 
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php 

    # downloads and gives current user executable permission for running laravel composer
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x /usr/local/bin/composer
}

# loops through the packages in variable packages and installs them
function packageInstallation {
    sudo apt-get install ${packages[@]} -y
}

# iniates the neccessary services of the packages installed
function servicesIniation {
    sudo systemctl start apache2
    sudo systemctl status apache2
    sudo ufw allow 'Apache'
    sudo systemctl start postgresql.service
    sudo systemctl status postgresql.service
}

# checks for errors in the logfile
function errorReport {
    cd /home/david/Desktop/AltSchool/2ndSemesterExam
    if grep -i "error" log.log; then
        echo "Errors Found During Laravel Hosting Operation $(date) for ${host}" >> ${errorLog}
        echo "+-------------------------------+" >> ${errorLog}
        echo >> ${errorLog}

        grep -i "error" log.log >> ${errorLog}
        echo "+-------------------------------+" >> ${errorLog}

        echo >> ${errorLog}
    fi
}

# pulls and moves the laravel app repo to be hosted into apache host directory
function gitOp {
    # checks if AltExam folder does not exist before creating it
    cd ~
    if [ ! -d AltExam ]; then
        mkdir AltExam
    fi

    cd AltExam

    # checks if remote origin exists or if existing remote origin is not the same as the laravel folder to be pulled
    if ! git remote -v; then
        git init
        git remote add origin https://${key}@github.com/DavidHODs/laravel-realworld-example-app.git
    else
        if ! git ls-remote --exit-code https://${key}@github.com/DavidHODs/altschool-cloud-exercises-.git; then 
            # removes origin and clears the contents of AltExam 
            git remote rm origin
            rm -rf ~/AltExam/{*,.*}
            git remote add origin https://${key}@github.com/DavidHODs/laravel-realworld-example-app.git
        fi
    fi
 
    # pulls the laravel content repo
    git pull origin main
    cd ~

    # checks if AltEXam folder exists in apache html directory before deleting it
    if [ -d /var/www/html/AltExam ]; then
        sudo rm -rfv /var/www/html/AltExam
    fi
    
    # moves AltExam folder containing the app to be hosted into apache html directory
    sudo mv AltExam /var/www/html/ 
}

packageUpdate >> ${log}
dependenciesInstallation >> ${log}
packageInstallation >> ${log}
packageUpdate >> ${log}
servicesIniation >> ${log}
gitOp >> ${log}
errorReport

# sudo -i 
# su - postgres
# psql
# exit;