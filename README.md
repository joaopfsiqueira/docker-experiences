# Repositório criado para prática e listagem de comandos docker.

# Sumário 📚

1 - **[Dockerfile](https://github.com/joaopfsiqueira/docker-experiences#exemplo-de-dockerfile)**<br>
2 - **[Docker](https://github.com/joaopfsiqueira/docker-experiences#docker)**<br>
3 - **[Comandos](https://github.com/joaopfsiqueira/docker-experiences#executando-comandos-ao-mesmo-tempo)**<br>
4 - **[Observações](https://github.com/joaopfsiqueira/docker-experiences#observa%C3%A7%C3%B5es)**<br>
5 - **[Persistindo dados](https://github.com/joaopfsiqueira/docker-experiences#persistindo-dados-)**<br>
6 - **[Docker Hub](https://github.com/joaopfsiqueira/docker-experiences#docker-hub-)**<br>
7 - **[Possíveis erros](https://github.com/joaopfsiqueira/docker-experiences#poss%C3%ADveis-erros-)**<br>

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

### docker run

- O comando docker run é responsável por executar um container em nosso host. Se não existir localmente, ele busca o container no docker hub https://hub.docker.com/.

- Procura a imagem localmente -> Baixa a imagem caso não encontre localmente -> Valida o hash da imagem -> Executa o container.

```
docker run hello-world (nesse exemplo vai rodar a imagem hello-world https://hub.docker.com/_/hello-world que serve só para testar o docker.)

docker run hello-world sleep 1d(o comando sleep é um comando que diz que o processo só vai ser executado em determinado tempo, 1day. Raramente é utilizado, mas é uma forma de sempre mostrar em execução os containers.)

docker run -it hello-world bash (roda o docker e já abre o terminal interativo.)
```

### docker ps

- Vai mostrar os containeres em executação ou não

```
docker ps
docker container ps -a
```

### docker ls

- Vai mostrar os containeres em executação ou não, igual ao ps só que mais verboso.

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

Esse comando vai parar os containeres e depois vai listar todos os containeres mas só o id de cada um. Por conta do comando -q (quiet)

# Observações 👀

## Images 🏞️

- Todas as imagens tem diversas camadas que formam uma única. E todas elas, quando baixamos, vem no modo RO, read only.

- Beleza, mas então como a gente consegue criar algo dentro dessa imagem através de um container? É simples! Como mencionado acima, imagem é um conjunto de camadas e quando baixamos uma imagem, uma nova camada acima das outras é criada, permitindo o uso das camadas que ficam abaixo e criando uma nova que é R/W read and write.

### docker images

- Usado para ver as imagens baixadas no sistema.

```
docker images
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
cd app/
ls
touch arquivo-qualquer.txt
basta olhar na pasta que você criou que esses arquivo criado dentro de app vai estar lá tbm!
```

Dito isso, é possível até mesmo excluir o container e rodar o comando docker run acima que tudo o que estiver dentro da sua pasta criada também vai para app! É o jeito perfeito para transacionar dados entre containeres.
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
