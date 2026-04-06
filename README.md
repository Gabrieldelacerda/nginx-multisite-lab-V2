Nginx Multi-Site Lab. By Gabriel de la Cerda

This project started as a simple idea: understand how Nginx serves multiple websites from the same machine. I set it up first in a local Ubuntu VM, configuring two sites — site1.local and site2.local — each with its own directory and server block. The routing is based on the Host header, which is how real servers differentiate domains sharing the same IP.

At that stage, everything was manual. I edited Nginx configs directly, reloaded the service, and tested with curl and the browser. I also enabled HTTPS using self-signed certificates just to get familiar with the process and the kinds of errors that usually come with it.

After getting it working, the next step was making the setup less manual and more reproducible. I moved Nginx into a Docker container so the environment could be recreated consistently. Instead of relying on system-level configuration, the server setup and site files are mounted into the container, which made it easier to control and reset everything when needed.

Then I introduced Ansible to automate the environment setup. Instead of repeating installation steps, I wrote a playbook that prepares the machine and gets everything ready to run the project. This removed a lot of friction and made the setup predictable.

Once that was stable locally, I took the same idea to AWS. Using Terraform, I provisioned an EC2 instance and defined the infrastructure as code. From there, Ansible connects remotely to configure the instance, and Docker runs the same Nginx container as before. One of the main takeaways here was that once the containerized setup worked locally, moving it to the cloud required very few changes.

Testing in the cloud is done by sending requests directly to the EC2 public IP while specifying the Host header, which simulates real domain routing. For example, using curl with different hostnames returns the correct site content.

During this process, I ran into an issue where both domains were returning the same page. This turned out to be caused by a misconfiguration in Nginx, where one of the server blocks was set as a catch-all using "server_name _;". After correcting it to the proper hostname and recreating the container, the routing behaved as expected. I verified the fix by checking the configuration inside the container and retesting the requests.

Overall, this project reflects how I approach learning and problem-solving: start simple, make it work, then improve it step by step. It also shows practical experience with Nginx configuration, containerization, infrastructure provisioning, and debugging issues across both local and remote environments.

There’s still more I can build on top of this, like setting up HTTPS properly in AWS with Certbot, using a real domain with Route53, or adding a CI/CD pipeline, but this version already captures the core concepts I wanted to practice.
