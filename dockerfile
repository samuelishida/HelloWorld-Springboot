# Imagem base do OpenJDK com Maven
FROM maven:3.8.5-openjdk-8-slim AS builder

# Diretório de trabalho
WORKDIR /usr/src/app

# Copiar o arquivo pom.xml e outros arquivos necessários para o Maven
COPY ./pom.xml ./pom.xml

# Baixar as dependências sem construir a aplicação (caching das dependências)
RUN mvn dependency:go-offline -B

# Copiar o código-fonte
COPY ./src ./src

# Construir o projeto (gera o WAR)
RUN mvn clean package -DskipTests

# Segunda fase, menor para a aplicação final
FROM openjdk:8-jdk-alpine

# Diretório de trabalho
WORKDIR /usr/app

# Copiar o WAR gerado na fase anterior
COPY --from=builder /usr/src/app/target/helloworld-0.0.1.war /usr/app/

# Executar o WAR com o comando Java
ENTRYPOINT ["java", "-jar", "helloworld-0.0.1.war"]
