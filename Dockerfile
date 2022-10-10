## Queremos que nessa imagem tenha node para rodar nosso servidor.
## para isso, vamos utilizar a imagem do node no docker hub para rodar o projeto.

## vamos baixar da imagem node:16 versao 16, é possível visualizar as versões no docker hub
FROM node:16 

## Definindo o nosso diretório de trabalho padrão.
WORKDIR /nomeDaPastaOndeTaOprojeto

## Serve para apontar que vamos receber esse argumento em tempo de imagem, podendo pegar de um process.env.PORT
ARG PORT_BUILD=3000

## Definindo determinado variável de ambiente dentro do nosso CONTAINER e não na imagem.
ENV PORT=$PORT_BUILD

## expondo aplicação em uma porta, fazendo não ser necessário o comando -p na hora de rodar determinada imagem. Nesse caso, estamos pegando o valor definidido acima no ARG.
EXPOSE $PORT_BUILD

## copiar esse conteúdo para determinada pasta dentro do container. Usamos . . pq pega do workdir acima
COPY . .

## Instalar as depedências da nossa aplicação
RUN npm install

## Definindo o ponto de entrada do nosso container, podemos executar o nosso projeto por script, por exemplo.
ENTRYPOINT npm start 