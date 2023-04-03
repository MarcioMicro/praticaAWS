# Atividade prática de AWS

### Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
1. Antes de configurar a instância, deve-se verificar as configuração de VPC, subnets e internet gateway
2. Uma vez logado no console web do serviço EC2, clique em "Launch Instances"
3. Informe a tag nome da instância
4. Na seção "AMI", selecione "Amazon Linux 2 AMI"
5. Na seção "Instance type", selecione "t3.small"
6. Em "Key pair", deve-se criar uma nova chave
   1. Defina o nome
   2. tipo RSA
   3. Format .pem
   4. Deve-se salvar a chave privada (a pública fica salva na AWS) localmente
7. Na seção "Network settings", em "Firewall", deve-se criar um novo "security group", e pode-se inicialmente deixar marcado para permitir o tráfego SSH
8. Em "Configure storage", deve-se mudar para 16 GiB e gp2
9. Após todas as configurações, clique em "Launch instance"


### Gerar uma chave pública para acesso ao ambiente;
A chave para a instância anterior já foi criada juntamente com a instância, pelo console web.
Caso necessite criar uma nova, pode-se fazer por um terminal linux.
1. Deve-se usar o comando ssh-keygen -t rsa -b 2048
2. Depois confirmar o local e nome da chave (por default ~/.ssh/id_rsa)
3. Serão criadas uma chave privada e uma pública, que poderá ser enviada ao servidor remoto


### Gerar 1 elastic IP e anexar à instância EC2;
1. Acesse o console EC2 da AWS e navegue até a guia "Elastic IPs"
2. Clique em "Allocate new address"
3. Verifique a região de criação
4. Selecione "Amazon's pool of IPv4 addresses" e clique em "Allocate".
5. Selecione o Elastic IP que você acabou de criar e clique em "Actions", depois "Associate Elastic IP address".
6. Selecione a instância EC2 e o Private IP address que você deseja associar o Elastic IP e clique em "Associate".


### Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).
1. Acesse o console EC2 da AWS e navegue até a guia "Security Groups"
2. Clicar no security group utilizado na instância
3. Na guia "Inbound rules", clique em "Edit inbound rules"
4. Adicione as regras de entrada para as portas 22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP e 443/TCP conforme necessário. Para cada porta, selecione o tipo de protocolo (TCP ou UDP) e insira o número da porta no campo "Port range". Em seguida, selecione "Anywhere" ou insira um endereço IP específico ou um intervalo CIDR na caixa "Source".
5. Clique em "Save rules".




## Requisitos no linux:
### Configurar o NFS entregue;
1. Navegue até o serviço EFS
2. Clique em "Create file system"
3. Atribua um nome, caso queira, e clique em "Create"
4. Clique no ID do sistema de arquivos ao qual deseja criar um ponto de montagem.
5. Na guia "Access points", clique no botão "Create access point", defina um nome, caso deseje, e clique em "Create access point".
6. Na guia "Network", clique em "Manage", e atribua o security group criado anteriormente às subnets disponíveis.
7. Com tudo configurado, deve-se anotar o "DNS name" do file system
8. Ao logar à instância por meio de ssh, deve-se criar o diretório /mnt/nfs
9. Depois deve-se montar o file system, por meio do comando ``` sudo mount -t nfs4 <DNS_Name>:/ /mnt/nfs ```
10. Para automatizar a montagem, deve-se instalar o driver do Amazon EFS: ```sudo yum install amazon-efs-utils -y```
11. Depois, deve-se editar o arquivo /etc/fstab, inserindo a seguinte linha: ```<DNS_Name>:/ /mnt/nfs efs defaults,_netdev 0 0```


#### Criar um diretorio dentro do filesystem do NFS com seu nome;
Após a montagem, deve-se usar o comando ```sudo mkdir /mnt/nfs/<seu_nome>```


### Subir um apache no servidor - o apache deve estar online e rodando;
1. Logado na instância, deve-se atualizar o pacote do sistema: ```sudo yum update -y```
2. Instale o servidor web Apache usando o seguinte comando: ```sudo yum install httpd -y```
3. Inicie o Apache usando o seguinte comando: ```sudo systemctl start httpd```
4. Verifique se o Apache está em execução usando o seguinte comando: ```sudo systemctl status httpd```
5. Para garantir que o Apache seja iniciado automaticamente na inicialização do sistema, use o seguinte comando: ```sudo systemctl enable httpd```
6. Deve-se instalar o git para fazer o versionamento da atividade no repositório do GitHub, com o comando: ```sudo yum install git -y```


#### Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretorio no nfs; O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou offline; O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;
Deve ser criado o arquivo check_apache.sh, com o seguinte código:
``` Bash
#!/bin/bash

export TZ=America/Sao_Paulo

DATE=$(date '+%d-%m-%Y %H:%M:%S')

if systemctl is-active --quiet httpd; then
	STATUS="Online"
	MESSAGE="O serviço Apache está funcionando normalmente."
	FILENAME="apache_online.txt"
else
	STATUS="Offline"
	MESSAGE="O serviço Apache não está funcionando normalmente."
	FILENAME="apache_offline.txt"
fi

echo "$DATE httpd $STATUS - $MESSAGE" | sudo tee -a /mnt/nfs/$FILENAME
```


##### Preparar a execução automatizada do script a cada 5 minutos.
1. Para automatizar a execução do script, deve ser usado o comando ```crontab -e```
2. Ao editar o arquivo, deve ser inserida a seguinte linha: ```*/5 * * * * /<caminho_do_script>/script.sh```

Opcionalmente, pode-se criar um html simples para testar o serviço do Apache:
``` html
<!DOCTYPE html>
<html>
<head>
    <title>Página de Teste Apache</title>
</head>
<body>
    <h1>Teste Apache</h1>
    <p>Se você estiver vendo esta página, o servidor Apache está funcionando corretamente.</p>
</body>
</html>
```
O arquivo deve ser salvo no diretório /var/www/html.

Seguindo todos os passos, as atividades propostas estarão devidamente configuradas.

A comunicação por ssh foi feita pelo Oracle Linux 9.1, em máquina virtual.
