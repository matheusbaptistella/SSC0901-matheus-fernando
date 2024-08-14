# Trabalho 1

## Grupo
- Fernando - nusp
- Matheus Baptistella - 11223117

## Funcionamento
Para este projeto, o objetivo era desenvolver um script para mapeamento das portas da máquina do host. Para isso, projetou-se o script `scanner.c` de forma que ele realiza um escaneamento das portas TCP no intervalo de 1 a 65535 e identifica quais estão abertas. Ele faz isso criando um socket para cada porta e tentando estabelecer uma conexão. Se a conexão for estabelecida dentro do tempo limite, a porta é considerada aberta. Além de verificar se a porta está aberta, o script também identifica o protocolo e o serviço associado à porta usando a função `getservbyport`, que consulta o arquivo /etc/services.

## Execução
Para excutar a simulação na máuina local, é preciso compilar o script com o comando:
```bash
make all
```
e rodar utilizando:
```bash
make run
```

Para simular o arquivo na máquina metasploitable2 é necessário ter o Docker instalado na sua máquina. Em seguida, execute o comando;
```bash
docker build -t meta-img . && docker run --rm --name meta-container meta-img
```
