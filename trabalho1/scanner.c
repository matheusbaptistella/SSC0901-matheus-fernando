#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <unistd.h> 
#include <netinet/in.h> 
#include <fcntl.h>
#include <sys/time.h>
#include <sys/select.h> 
 
#define MAX_PORT 65535
#define TIMEOUT 1 

void check_port(int port, struct servent *service) {
    int sock; 
    struct sockaddr_in server;
    struct timeval timeout; 
    fd_set fdset; 

    // Cria um socket para a comunicacao via TCP
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) { 
        perror("Falha oa criar a socket");
        return;
    }

    // Informacoes do servidor (IPv4, localhost)
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    server.sin_addr.s_addr = inet_addr("127.0.0.1");

    // Configura o timeout para a conexão.
    timeout.tv_sec = TIMEOUT;
    timeout.tv_usec = 0;

    // Inicializa descritores
    FD_ZERO(&fdset);
    FD_SET(sock, &fdset);

    // Configura o socket para ser nao-bloqueante
    fcntl(sock, F_SETFL, O_NONBLOCK);

    if (connect(sock, (struct sockaddr *)&server, sizeof(server)) < 0) {
        // Se a conexao nao puder ser estabelecida imediatamente, utiliza-se do
        // selcet() para esperar ate que esteja pronta
        if (select(sock + 1, NULL, &fdset, NULL, &timeout) == 1) {
            int so_error;
            socklen_t len = sizeof so_error;

            // Verifica o status da conexao
            getsockopt(sock, SOL_SOCKET, SO_ERROR, &so_error, &len);

            // Porta aberta
            if (so_error == 0) {
                printf("Porta %d OPEN (Protocolo: %s, Serviço: %s)\n",
                       port, service->s_proto, service->s_name);
            }
        }
    }

    close(sock); 
}

int main() {
    // Armazena informacoes sobre o servico da porta
    struct servent *service; 
    
    // Escaneia todas as portas TCP
    for (int port = 1; port <= MAX_PORT; port++) {
        // Checa apenas as portas com servicos
        service = getservbyport(htons(port), "tcp");
        if (service != NULL) { 
            check_port(port, service);
        }
    }

    return 0; 
}
