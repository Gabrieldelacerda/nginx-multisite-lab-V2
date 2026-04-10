Nginx Multi-Site Lab. By Gabriel de la Cerda  (versão em português abaixo)

You can type this in your browser to access!
http://54.233.211.29

Quick Start:

Provision infrastructure:
terraform init
terraform apply

Configure server:
ansible-playbook -i inventory.ini deploy.yml

Test virtual hosts:
curl -H "Host: site1.local" http://54.233.211.29
curl -H "Host: site2.local" http://54.233.211.29


Before getting into the details, here’s a quick overview of how everything is structured:

The request starts from the browser and reaches an EC2 instance in AWS using its public IP. Inside that instance, Nginx is running in a Docker container. Nginx is configured with virtual hosts, so depending on the Host header, it serves either site1 or site2. Each site has its own directory with static files.

In practice, the layers are separated like this: Terraform is responsible for creating the infrastructure in AWS, Ansible prepares and configures the server, Docker runs the containerized environment, and Nginx handles the routing between the sites.

If you wanted to recreate this environment from scratch, the flow is straightforward. First, the infrastructure is provisioned with Terraform. Then Ansible connects to the instance and installs Docker and deploys the application. After that, the application is already accessible through the public IP.

This project started as a simple idea: understand how Nginx serves multiple websites from the same machine. I set it up first in a local Ubuntu VM, configuring two sites — site1.local and site2.local — each with its own directory and server block. The routing is based on the Host header, which is how real servers differentiate domains sharing the same IP.

At that stage, everything was manual. I edited Nginx configs directly, reloaded the service, and tested with curl and the browser. I also enabled HTTPS using self-signed certificates just to get familiar with the process and the kinds of errors that usually come with it.

After getting it working, the next step was making the setup less manual and more reproducible. I moved Nginx into a Docker container so the environment could be recreated consistently. Instead of relying on system-level configuration, the server setup and site files are mounted into the container, which made it easier to control and reset everything when needed.

Then I introduced Ansible to automate the environment setup. Instead of repeating installation steps, I wrote a playbook that prepares the machine and gets everything ready to run the project. This removed a lot of friction and made the setup predictable.

Once that was stable locally, I took the same idea to AWS. Using Terraform, I provisioned an EC2 instance and defined the infrastructure as code. From there, Ansible connects remotely to configure the instance, and Docker runs the same Nginx container as before. One of the main takeaways here was that once the containerized setup worked locally, moving it to the cloud required very few changes.

Testing in the cloud is done by sending requests directly to the EC2 public IP while specifying the Host header, which simulates real domain routing. For example, using curl with different hostnames returns the correct site content.

During this process, I ran into an issue where both domains were returning the same page. This turned out to be caused by a misconfiguration in Nginx, where one of the server blocks was set as a catch-all using "server_name _;". After correcting it to the proper hostname and recreating the container, the routing behaved as expected. I verified the fix by checking the configuration inside the container and retesting the requests.

Some decisions in this project were intentional. I kept the structure simple instead of over-engineering it, focused on separating responsibilities between infrastructure, configuration, and application layers, and used Docker to ensure consistency between local and cloud environments. I also chose to simulate multiple domains using the Host header instead of setting up a real DNS, to keep the focus on how Nginx routing works internally.

Overall, this project reflects how I approach learning and problem-solving: start simple, make it work, then improve it step by step. It also shows practical experience with Nginx configuration, containerization, infrastructure provisioning, and debugging issues across both local and remote environments.



================


Você pode testar o projeto por conta própria, basta digitar isso no navegador:
http://54.233.211.29

Antes de entrar nos detalhes, aqui vai uma visão geral rápida de como tudo está estruturado.

A requisição começa no navegador e chega a uma instância EC2 na AWS usando o IP público. Dentro dessa instância, o Nginx está rodando em um container Docker. O Nginx está configurado com virtual hosts, então dependendo do Host header, ele serve o site1 ou o site2. Cada site tem seu próprio diretório com arquivos estáticos.

Na prática, as camadas estão separadas assim: o Terraform é responsável por criar a infraestrutura na AWS, o Ansible prepara e configura o servidor, o Docker executa o ambiente containerizado, e o Nginx faz o roteamento entre os sites.

Se você quiser recriar esse ambiente do zero, o fluxo é direto. Primeiro, a infraestrutura é provisionada com Terraform. Depois, o Ansible se conecta à instância e instala o Docker e faz o deploy da aplicação. Após isso, a aplicação já fica acessível pelo IP público.

Este projeto começou como uma ideia simples: entender como o Nginx serve múltiplos sites a partir da mesma máquina. Eu configurei primeiro em uma VM Ubuntu local, criando dois sites — site1.local e site2.local — cada um com seu próprio diretório e server block. O roteamento é baseado no Host header, que é como servidores reais diferenciam domínios compartilhando o mesmo IP.

Nesse estágio, tudo era manual. Eu editava as configurações do Nginx diretamente, recarregava o serviço e testava com curl e no navegador. Também habilitei HTTPS usando certificados autoassinados só para me familiarizar com o processo e com os tipos de erro que normalmente aparecem.

Depois que isso estava funcionando, o próximo passo foi tornar o setup menos manual e mais reproduzível. Eu movi o Nginx para um container Docker, assim o ambiente poderia ser recriado de forma consistente. Em vez de depender de configurações no sistema, os arquivos do servidor e dos sites são montados dentro do container, o que facilitou controlar e resetar tudo quando necessário.

Em seguida, introduzi o Ansible para automatizar a preparação do ambiente. Em vez de repetir etapas de instalação, escrevi um playbook que prepara a máquina e deixa tudo pronto para rodar o projeto. Isso removeu bastante atrito e tornou o setup previsível.

Quando isso estava estável localmente, levei a mesma ideia para a AWS. Usando Terraform, criei uma instância EC2 e defini a infraestrutura como código. A partir daí, o Ansible se conecta remotamente para configurar a instância, e o Docker roda o mesmo container Nginx de antes. Um dos principais aprendizados aqui foi que, uma vez que o setup containerizado funcionava localmente, levar para a nuvem exigiu pouquíssimas mudanças.

Os testes na nuvem são feitos enviando requisições diretamente para o IP público da EC2, especificando o Host header, o que simula o roteamento real por domínio. Por exemplo, usando curl com diferentes hostnames retorna o conteúdo correto de cada site.

Durante esse processo, encontrei um problema onde ambos os domínios retornavam a mesma página. Isso aconteceu por causa de uma configuração incorreta no Nginx, onde um dos server blocks estava definido como catch-all usando "server_name _;". Depois de corrigir para o hostname correto e recriar o container, o roteamento passou a funcionar como esperado. Eu validei a correção verificando a configuração dentro do container e testando novamente as requisições.

Algumas decisões nesse projeto foram intencionais. Mantive a estrutura simples em vez de superengenhar, foquei em separar responsabilidades entre infraestrutura, configuração e aplicação, e usei Docker para garantir consistência entre ambientes local e em nuvem. Também optei por simular múltiplos domínios usando o Host header em vez de configurar um DNS real, para manter o foco em como o roteamento do Nginx funciona internamente.

No geral, este projeto reflete como eu abordo aprendizado e resolução de problemas: começo simples, faço funcionar e depois vou melhorando passo a passo. Ele também demonstra experiência prática com configuração de Nginx, containerização, provisionamento de infraestrutura e debugging tanto em ambientes locais quanto remotos.

Ainda há mais coisas que posso evoluir, como configurar HTTPS corretamente na AWS com Certbot, usar um domínio real com Route53 ou adicionar um pipeline de CI/CD, mas essa versão já cobre bem os conceitos principais que eu queria praticar.
