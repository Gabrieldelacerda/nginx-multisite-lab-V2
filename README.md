Nginx Multi-Site Lab (Local Dev Environment) V2:


===============
What changed in V2?

The first version of this lab was implemented directly on the host system using a standard Nginx installation.

In V2, the project was expanded to introduce basic automation and containerization concepts commonly used in modern infrastructure.

The main changes were:

Docker

* Nginx now runs inside a Docker container instead of being installed directly on the system.
* The container is built and started using "docker-compose".
* Site configuration and content are mounted into the container as volumes.

This simulates how web services are commonly deployed in containerized environments.

Ansible

* Ansible is used to automate the environment setup.
* The playbook installs required packages and prepares the configuration needed to run the project.
* This removes the need for manual configuration steps and makes the environment reproducible.

Together, Docker and Ansible allow the entire lab environment to be recreated quickly and consistently.
===============


This repository documents a small hands-on lab where I configured Nginx to serve multiple websites on the same machine using different hostnames.

The main goal was to practice how virtual hosting works in a real Linux environment, including HTTPS setup and basic debugging.

I ran everything on an Ubuntu virtual machine.

    What I built?

I configured Nginx to serve two local sites on the same server:

"site1.local"
"site2.local"

Each site has:

* Its own root directory under "/var/www"
* Its own Nginx server block
* Independent HTML content

Requests are routed using the "Host" header, simulating how multiple domains are handled on a single server in real environments.

I also enabled HTTPS locally using self-signed certificates for testing purposes.

    How I tested?

From the terminal, I verified that Nginx routes requests correctly based on the hostname:

curl -H "Host: site1.local" http://127.0.0.1
curl -H "Host: site2.local" http://127.0.0.1

In the browser, I accessed:

"https://site1.local"
"https://site2.local"

This required adding the hostnames to "/etc/hosts" and accepting the self-signed certificate warning.

    What I learned in practice?

While setting this up, I ran into and fixed real issues that are common in day-to-day work:

* Wrong site being served due to Nginx server block precedence
* File permission problems under "/var/www"
* Character encoding issues in HTML files
* Browser cache causing outdated content to appear
* Certificate and HTTPS configuration mistakes

This forced me to debug using:

* "nginx -t"
* "systemctl reload nginx"
* "curl"
* Browser dev tools and cache refresh

    Why this project exists?

This lab is not meant to be a production-ready setup.

The purpose is to demonstrate that I can:

* Configure Nginx beyond a default install
* Understand how virtual hosts work
* Set up HTTPS in a controlled environment
* Debug real configuration and OS-level issues
* Work comfortably in Linux
