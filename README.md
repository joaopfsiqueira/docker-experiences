# Repositório criado para prática e listagem de comandos docker.

# Sumário 📚

1 - **[Dockerfile](https://github.com/joaopfsiqueira/docker-experiences#exemplo-de-dockerfile)**<br>
2 - **[Docker](https://github.com/joaopfsiqueira/docker-experiences#docker)**<br>
3 - **[Comandos](https://github.com/joaopfsiqueira/docker-experiences#executando-comandos-ao-mesmo-tempo)**<br>
4 - **[Observações](https://github.com/joaopfsiqueira/docker-experiences#observa%C3%A7%C3%B5es-)**<br>
5 - **[Persistindo dados](https://github.com/joaopfsiqueira/docker-experiences#persistindo-dados-)**<br>
6 - **[Rede bridge](https://github.com/joaopfsiqueira/docker-experiences#rede-bridge-)**<br>
7 - **[Docker Hub](https://github.com/joaopfsiqueira/docker-experiences#docker-hub-)**<br>
8 - **[Possíveis erros](https://github.com/joaopfsiqueira/docker-experiences#poss%C3%ADveis-erros-)**<br>
9 - **[Docker Compose](https://github.com/joaopfsiqueira/docker-experiences#docker-compose)**<br>
10 - **[Instalação Docker Ubuntu](https://github.com/joaopfsiqueira/docker-experiences#instala%C3%A7%C3%A3o-docker-ubuntu)**

# Dockerfile

- Docker file com explicação: **[Dockerfile](https://github.com/joaopfsiqueira/linux/blob/docker/Dockerfile)**

- Documentação oficial dockerfile: **[Documentação](https://docs.docker.com/engine/reference/builder/)**

## docker build

- Serve para criar imagem que o docker file acima estruturou.

```
docker build -t nomedaImagem:versao localDoDockerFile(joaopfsiqueira/app-node:1.0 .) (o ponto é para especificar o caminho, no caso o repositório atual, caso esteja rodando o comando dentro da pasta onde se encontra o docker file.)

docker images
docker run -p 8080:3000(portaOndeVaiRodarAplicação, express ou não) repositoryImagemCriada(retorna no docker images)
```

### Informações pertinentes sobre o Dockerfile.

- A instrução ARG carrega variáveis apenas no momento de build da imagem, enquanto a instrução ENV carrega variáveis que serão utilizadas no container.

# Docker 🗃️

- Comandos que serão usados em um docker

### docker pull

- Comando utilizado para baixar a imagem do docker hub e manter no nosso docker.

```
docker pull mongo:latest
docker pull mongo:4.4.6
```

### docker run

- O comando docker run é responsável por executar um container em nosso host. Se não existir localmente, ele busca o container no docker hub https://hub.docker.com/.

- Procura a imagem localmente -> Baixa a imagem caso não encontre localmente -> Valida o hash da imagem -> Executa o container.

```
docker run hello-world (nesse exemplo vai rodar a imagem hello-world https://hub.docker.com/_/hello-world que serve só para testar o docker.)

docker run hello-world sleep 1d(o comando sleep é um comando que diz que o processo só vai ser executado em determinado tempo, 1day. Raramente é utilizado, mas é uma forma de sempre mostrar em execução os containers.)

docker run -it hello-world bash (roda o docker e já abre o terminal interativo.)
```

### --name

- Comando utilizado para quando baixarmos um container ou imagem, podemos colocar o nome que quisermos!

```
docker run -it --name ubuntu1 ubuntu bash
```

### docker ps

- Vai mostrar os containers! em executação ou não

```
docker ps
docker container ps -a
```

### docker ls

- Vai mostrar os containers! em executação ou não, igual ao ps só que mais verboso.

```
docker ls
docker container ls -a (mostra todos os containers em execução ou não)
```

### docker stop

- Usado para parar um container

```
docker stop idcontainer (esse id é achado no comando ps ou ls)
```

### docker pause

- Usado para pausar um container

```
docker pause idcontainer (esse id é achado no comando ps ou ls)
```

### docker unpause

- Usado para despausar um container

```
docker unpause idcontainer (esse id é achado no comando ps ou ls)
```

### docker start

- Usado para dar um start em um container parado.

```
docker start idcontainer (esse id é achado no comando ps ou ls)
```

### docker exec

- Usado para executar um container em modo interativo.

```
docker exec -it idcontainer bash (vai rodar o container em modo bash, no terminal, usado para usar comandos dentro do docker.)
```

### docker rm

- Comando utilizado para remover um container.

```
docker rm idcontainer
docker rm idcontainer --force (vai forçar a exclusão caso esteja rodando)
docker rmi (removendo imagens)
```

### docker inspect

- Serve para inspecionar um container, o comando retorno diversos dados sobre o mesmo! Como network, bridge, ips...

```
docker ps (pegar o idContainer)
docker inspect idcontainer
```

### -d

- -d é um comando utilizado para manter algo em execução e não bloquear o terminal. -d = detached

```
docker run -d hello-world
docker compose up -d
```

### -s

- -s é uma tag que retorna uma nova coluna no ps ou ls, coluna que se chama size, retornando o tamanho da imagem.

```
docker ps -s
```

### top

- Usado para ver as árvores de processos, geralmente usado dentro de um container.

# Executando comandos ao mesmo tempo. 🧾

- É possível utilizar um único comando que faça várias coisas, como por exemplo:

```
docker stop $(docker container ls -q)
docker container rm $(docker container ls -aq)
docker rmi $(docker image ls -aq) --force
```

Esse comando vai parar os containers! e depois vai listar todos os containers! mas só o id de cada um. Por conta do comando -q (quiet)

# Observações 👀

## Images 🏞️

- Todas as imagens tem diversas camadas que formam uma única. E todas elas, quando baixamos, vem no modo RO, read only.

- Beleza, mas então como a gente consegue criar algo dentro dessa imagem através de um container? É simples! Como mencionado acima, imagem é um conjunto de camadas e quando baixamos uma imagem, uma nova camada acima das outras é criada, permitindo o uso das camadas que ficam abaixo e criando uma nova que é R/W read and write.

### docker images

- Usado para ver as imagens baixadas no sistema.

```
docker images
```

### docker search

- Usado para pesquisar informações sobre imagens que estão no Docker Hub
```
docker search ubuntu
docker search hello-world
```

### docker inspect

- Usado para inspecionar uma imagem

```
docker inspect idimagem
```

### docker history

- Usado para ver o histórico de alterações da imagem em questão. Mostrando todas as camadas que formam a imagem principal.

```
docker history idimagem
```

## Ports

- Quando executamos um container com algo dentro, geralmente vinculamos uma porta nele. Isso não quer dizer que essa porta vai ficar acessível fora do nosso container, sendo necessário EXPOR essa porta para acesso externos, mesmo dentro de um container em wsl e você tentando acessar pelo navegador do windows. Muitas vezes a porta em que o container está rodando é definidido dentro do dockerfile.

### port

- Usado para mapear como está o funcionamento de portas de um container em relação ao host.

```
docker port idcontainer
```

### -P (maísculo)

- Usado para tornar acessível o container através de uma porta pelo host. Resolvendo o problema da observação acima.

```
docker run -d -P dockersanples/static-site (nesse exemplo, estamos usando -d para detached e o -p que vai tornar portas padrões 80 e 443 acessíveis fora do container. Depois é só rodar o comando docker port idcontainer para ver as portas abertas e o host. se estiver rodando dentro da wsl localhost:80, se tiver fora basta passar o ip:porta (acho que funciona))
```

### -p (minusculo)

- Usado para apontar qual porta da minha máquina vai refletir na porta do container.

```
docker run -d -p 8080:80 dockersanples/static-site (aqui ele informa que a porta 8080 da minha máquina reflita na porta 80 do container)

docker container ls -q (jeito de retornar as portas)
```

# Persistindo dados 🎲

- Podemos querer que os dados da nossa aplicação sejam persistentes, porque assim garantimos que ela esteja distribuída e disponível se precisarmos consultá-la. Porém, se escrevermos os dados nos containers, por padrão eles não ficarão armazenados nesta camada, criada para ser descartável.

Formas de lidar com isso:

1 - _Volumes_. Com volumes, é possível escrever os dados em uma camada persistente.
2 - _Bind mounts_. Com bind mounts, é possível escrever os dados em uma camada persistente baseado na estrutura de pastas do host.

## Bind Mounts

- Ele vai fazer basicamente o bind, uma ligação entre um ponto de montagem do nosso sistema operacional e algum diretório dentro do container. Vamos entender agora como isso vai funcionar.

1 - Primeiro eu crio uma pasta chamada volume-docker(pode ser qualquer nome), que é a pasta que vai armazenar a persistência de dados.

2 - Rodar seguinte comando:

```
docker run –it –v /home/joaopfsiqueira/volume-docker:/app Ubuntu bash
```

Esse comando vai persistir os dados que está dentro de /app na imagem ubuntu e já vai abrir o bash.
Para _testar_:

```
ls
cd app/[](https://cursos.alura.com.br/course/docker-criando-gerenciando-containers/task/100402)
ls
touch arquivo-qualquer.txt
basta olhar na pasta que você criou que esses arquivo criado dentro de app vai estar lá tbm!
```

Dito isso, é possível até mesmo excluir o container e rodar o comando docker run acima que tudo o que estiver dentro da sua pasta criada também vai para app! É o jeito perfeito para transacionar dados entre containers!.
Mantendo tudo o que estiver dentro da camada de R/W em outras imagens, já que a camada de R/W é excluida junto da imagem.

- Porém, ultimamente vem sendo recomendado fazer os mesmos passos acima com um outro comando, o --mount.
  Como ficaria?

```
docker run it --mount type=bind,source="/home/joaopfsiqueira/volume-docker,target=/app ubuntu bash
```

Bem mais descritivo!`
Para ver se o arquivo que está dentro de volume-docker inserido anteriormente vai estar dentro do novo container basta fazer o seguinte comando dentro do bash do container:

```
cd app/
ls
```

## Volumes

- Volumes é uma outra forma de persistir dados e também a mais recomendada. Se olharmos a imagem que está presente na documentação (https://docs.docker.com/storage/volumes/), ele mostra que a utilização de volumes é uma área gerenciada pelo Docker dentro do seu file system.

Então por mais que no fim das contas as nossas informações continuem dentro do nosso host original para ser persistidas, nós teremos uma área que o Docker vai gerenciar e é muito mais segura a nível de alguém mexer e fazer alguma loucura ali dentro, porque será gerenciada pelo próprio Docker.

E como criamos um volume inicialmente? Vamos voltar no nosso terminal.

### docker volume

- Usado para ver todos os volumes criados no docker.

```
docker volume ls
```

- Criando volume

```
docker volume create joaopfsiqueira-volume
```

Feito isso, vamos fazer o mesmo passo do bind mounts! Só que agora, ao invés de especificar o diretório na minha máquina que eu quero que seja copiado do "app" ou qualquer outro lugar do container, eu vou especificar o volume! Uma das vantagens é que o docker é quem gerencia os volumes, sem necessitar de uma estrutura de pastas como em bind mounts!

```
docker run -it -v joaopfsiqueira-volume:/app ubuntu bash

OU

docker run -it --mount source=joaopfsiqueira-volume,target=/app ubuntu bash
```

- O mais mágico é, se os comandos acima não encontrarem o volume especificado ele vai simplesmente criar!
  <br>
  <br>

_Criamos arquivo para teste_!

```
cd app/
touch arquivo-qualquer.txt
```

_Criamos um novo container para ver se foi persistido!_

```
docker run -it -v meu-volume:/app ubuntu bash
cd app/
ls
arquivo vai estar lá!
```

- Acessando volumes com os arquivos!

```
sudo su
cd /var/lib/docker (tudo o que tem dentro do docker, image, containers e VOLUMES!)
cd volumes/
ls (vai achar _data dentro do volume!)
cd _data/
ls (Vai achar os arquivos criados anteriormentes que foram salvos no volume e persistidos de outras imagens!)
```

# Rede Bridge 🌉

- Quando criamos um container ou vários, podemos rodar o comando _docker inspect idContainer_ e ter acesso à diversas informações do container, uma delas é o Network! E dentro desse conjunto de redes ele tem uma chamada _bridge_ que tem diversas configurações

- Mas em que momento nós configuramos essa rede? A questão é que nós não configuramos. Quem fez isso foi o próprio Docker. É algo automático, tudo é criado em uma única rede. Isso é possível de comparar executando 2 containers! ao mesmo tempo:

1 - docker run –it ubuntu bash
2 - abre outro terminal
3 - docker ps idContainer1
4 - abre outro terminal
5 - docker run –it ubuntu bash
6 - abre outro terminal
7 - docker ps idContainer2

- Feito isso, é só comparar! Repara que se colocarmos lado a lado, toda essa parte de rede que ele está mostrando é igual. A parte de IPAMconfig como null, o network ID é igual. Então todos esses pontos dentro do nosso sistema, exceto o endpoint ID e o IP address, são iguais. Por quê? Isso significa então que esses containers no fim das contas estão na _mesma rede_.
  <br>
  <br>

- Mas será que conseguimos fazer algum tipo de comunicação entre eles, já que eles estão na mesma rede, que é um driver que o Docker está colocando para nós? Antes de pensar nisso, precisamos entender o que é a _bridge_

### docker network

- Comando utilizado para visualizar todas as networks do docker. É padrão ter bridge, host e none!

```
docker network ls
```

Com isso, podemos ver que os containers! que checamos acima, ao realizar um inspect neles, notamos que o _networkId_ tem a inicial do id de uma dessas networks!

- Dito isso, então podemos nos comunicar por ping dentro de um container para o outro? Sim! Como ficaria?

```
1 - docker run -it ubuntu(ou qualquer outra imagem) bash
2 - apt-get update (caso de um erro de ping not found)
3 - apt-get install iputils-ping -y (caso de um erro de ping not found)
4 - ping IPAddressContainer (valor retornado do docker inspect)
```

- Porém, o ping é algo instável, já que eles podem se alterar em uma posível reinicialização! Dito isso, vamos criar nossa própria rede bridge!

## Criando Rede Bridge

- Ao invés de utilizarmos o ip, podemos utilizar o hostname para fazer essa rede, para isso, vamos precisar criar nossa própria rede, já que apenas redes criadas pelo usuário podem utilizar do hostname! Vamos ao passo a passo!

1 - Criar uma nova rede que fará o papel da rede bridge!

```
docker network create --driver bridge *nomeRedeNova*
```

2 - Quando rodarmos o container, selecionar a rede que ele vai rodar!

```
docker run -it --name ubuntu1 --network *nomeRedeNova* ubuntu bash
docker ps (pegar idContainer)
docker inspect idcontainer
```

Feito isso, podemos analisar que dentro desse container, ao invés de _bridge_ em _Networks_, vemos _nomeRedeNova_

3 - Colocar quantos containers! nessa rede! _SE ATENTAR AO NOME DE CONTAINER DIFERENTE_

```
docker run -it --name ubuntu2 --network *nomeRedeNova* ubuntu bash sleep 1d
docker run -it --name ubuntu3 --network *nomeRedeNova* ubuntu bash sleep 1d
```

Colocamos em sleep 1d para não nos preocuparmos com a execução do mesmo no terminal!

4 - Voltamos ao primeiro terminal do primeiro container ubuntu1 e comunicar _ubuntu1_ com o _ubuntu2_ e _ubuntu3_!

```
apt-get update
apt-get install iputils-ping -y
ping ubuntu2
ping ubuntu3
```

Com isso, podemos ver que o ping será realizado normalmente!

## Rede none

- Rede utilizada quando não queremos que a aplicação tenha acesso a rede. Fazendo com que o container não tenha ip ou algo do tipo. Removendo a interface de rede.

## Rede host

- Rede utilizada para colocar aplicações em localhost. Removendo quaisquer restrições de isolamento ou porta que envolvem container e o sistema.

```
docker run -d --network host joaopfsiqueira/app-node:1.0
```

Como esse container roda uma aplicação que a porta é 3000, basta ir no navegador e utilizar _localhost:3000_

### Tutorial Prático Aplicação e Banco

Inicialmente, abra o terminal e execute o comando docker network ls. Caso ainda não tenha criado a rede minha-bridge, execute o comando docker network create –driver bridge minha-bridge.

Em seguida, iremos executar o container responsável pelo banco de dados. Para isso, execute o comando docker run -d –network minha-bridge –name meu-mongo mongo:4.4.6. Repare que estamos usando a versão 4.4.6.

Precisamos agora executar o container responsável pela aplicação que irá se comunicar com o banco de dados. Para isso, execute o comando docker run -d –network minha-bridge –name alurabooks -p 3000:3000 aluradocker/alura-books:1.0. Repare que utilizamos a flag -p para em seguida validar o funcionamento da aplicação através de nosso host.

Em seu navegador, acesse a url localhost:3000 e veja que foi possível carregar a página da aplicação. Para que os dados sejam carregados e armazenados no banco, acesse localhost:3000/seed e, em seguida, recarregue a página localhost:3000. Veja que as informações agora estão sendo exibidas por conta da comunicação entre aplicação e banco de dados.
<br>
<br>
<br>

# Docker Hub 🌎

## Subindo Imagem para Hub

1 - O primeiro passo é que você crie sua conta na parte direita da própria home do Docker Hub. Você define seu username, seu e-mail e sua senha, aceita os termos e marca o recaptcha. Depois é só clicar em “Sign Up” e confirmar sua conta por e-mail.

2 - Depois que você dizer isso, no canto superior direito tem a parte de “Sign In”. Você vai colocar o seu usuário e também a senha que você usou no momento do cadastro.

3 - Autenticar nossa conta no linux. _docker login -u nomeusuario_

4 - Depois de apentar enter, vai pedir a senha que criou anteriormente referente ao username.

5 - Rodar comando docker _images_ e pegar o _REPOSITORY_ da imagem que queremos subir e a _TAG_

6 - Rodar o seguinte comando _docker push REPOSITORY:TAG_

7 - Abrir https://hub.docker.com/repositories e achar seu repo!

## Juntando imagens

- Como dito anteriormente, imagens são feitas de camadas e o docker aproveita as camadas iguais! Sendo assim, se eu tivesse um _projeto x_ que tivesse 4 camadas e um _projeto y_ que tem as mesmas 4 camadas e mais 2 camadas novas, como eu faria para pegar essas duas camadas novas do _projeto y_ e juntar ao _projeto x_?

```
docker tag repositorioProjetoY:tagProjetoY repositorioProjetoX:tagProjetoX
docker push repositorioProjetoX:tagProjetoX
```

- Nisso, será possível ver pelo terminal que o docker vai informar que 4 camadas já são iguais e que vai apenas subir mais 2 novas!

# Possíveis erros ❌

## Acess denied ao subir hub

- Se você se deparou com essa mensagem de erro logo na primeira vez que foi subir ou hub ou em algum outro momento, tente isso:

1 - docker tag _repositoryQueDaErro:tagQueDaErro_ _seuUserNameNoHub/NomeProjeto:tagNova_

2 - _docker images_ para ver se a nova imagem já está ali.

3 - docker push _novoRepository:novaTag_

- _Exemplo de comando docker tag joaopfsiq/app-node:1.0 joaopfsiqueira/projeto-x:1.0_

# Docker Compose

- Docker compose é uma solução desenvolvida para agilizar e facilitar tudo visto anteriormente, através de interface e comandos simples. Vamos conhecer mais!

- O Docker Compose nada mais é do que uma ferramenta de coordenação de containers. Não confunda com orquestração, são coisas diferentes.

- Então o Docker Compose vai nos auxiliar a executar, a compor, como o nome diz, diversos containers em um mesmo ambiente, através de um único arquivo. Então vamos conseguir compor uma aplicação maior através dos nossos containers com o Docker Compose.

- E faremos isso através da definição de um arquivo yml, aquela extensão yml, ou yaml, caso você já tenha ouvido falar. E nada mais é do que um tipo de estrutura que vamos seguir baseado em indentação do nosso arquivo.

## Instalação 🔧

### Windows

- Para instalar no windows, basta seguir a seguir a seguinte documentação: https://docs.docker.com/desktop/install/windows-install/ utilizando Docker Desktop.

### WSL

- https://docs.docker.com/desktop/windows/wsl/

### Linux

- Para Linux ou WSL é possível realizar a instalação por pacote no terminal.

1 - sudo apt-get update
2 - sudo apt-get install docker-compose-plugin
3 - docker compose version (Deve retornar a versão.)

# Utilização 🛠️

- Feito a instalação, vamos para a utilização!

1 - Criar arquivo docker-compose.yml, segue um **[exemplo](https://github.com/joaopfsiqueira/docker-experiences/blob/master/docker-compose.yml)**
2 - Ir no diretório onde se encontra o docker-compose.yml, e rodar _docker compose up_
3 - Para visualizar basta abrir o docker desktop (caso esteja utilizando) ou através do navegador, digitando localhost:4000 (porta de exemplo do docker-compose.yml)

## docker compose down

- Para removermos os containers e parar os serviços, usamos o comando _docker compose down_!

```
docker compose down
```

## docker compose ps

- Listando os containers!

```
docker compose ps
```

### Criando Make file

- Uma forma de deixar os comandos do docker compose ainda mais simples é através da criação de um _Makefile_! Esse Makefile cria comandos simples que executam outros comandos. No exemplo abaixo, eu crio a section "up" que é rodada através de _make up_ no terminal e a section "down" rodada através do _make down_ também no terminal! Ambos vão rodar os comandos que estão abaixo da section.

**[Exemplo Make File](https://github.com/joaopfsiqueira/docker-experiences/blob/master/Makefile)**



# Instalação Docker Ubuntu

**[Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)**
**[Docker Engine](https://docs.docker.com/engine/install/ubuntu/)**
