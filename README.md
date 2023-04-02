# praticaAWS
Atividade prática de AWS para Compass

### Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
1. Uma vez logado no console web do serviço EC2, clique em Launch Instances
2. Informe a tag nome da instância
3. Na seção AMI, selecione Amazon Linux 2 AMI
4. Na seção Instance type, selecione t3.small
5. Em Key pair, deve-se criar uma nova chave
  1. Defina o nome
  2. tipo RSA
  3. Format .pem
  4. Deve-se salvar a chave privada (a pública fica salva na AWS)
6. Na seção Network settings, em Firewall, deve-se criar um novo security group, e pode-se inicialmente deixar marcado para permitir o tráfego SSH
7. 

## Gerar uma chave pública para acesso ao ambiente;



Gerar 1 elastic IP e anexar à instância EC2;
Liberar as portas de comunicação para acesso
público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80
/TCP, 443/TCP).
Requisitos no linux:
Configurar o NFS entregue;
Criar um diretorio dentro do filesystem do NFS com
seu nome;
Subir um apache no servidor - o apache deve estar
online e rodando;
Criar um script que valide se o serviço esta online e
envie o resultado da validação para o seu diretorio no
nfs;
O script deve conter - Data HORA + nome do serviço
+ Status + mensagem personalizada de ONLINE ou
offline;
O script deve gerar 2 arquivos de saida: 1 para o
serviço online e 1 para o serviço OFFLINE;
Preparar a execução automatizada do script a cada 5
minutos.
Fazer o versionamento da atividade;
Fazer a documentação explicando o processo de
instalação do Linux. 
