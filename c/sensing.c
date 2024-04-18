#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define SERVER_IP "127.0.0.1"
#define PORT 5000

// Mikroorganizma yapısı
typedef struct {
    char name[20];
    int signal_strength;
} Microorganism;

int main() {
    int client_fd;
    struct sockaddr_in server_addr;

    // Sunucuya bağlan
    if ((client_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("Socket oluşturma hatası");
        exit(EXIT_FAILURE);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    server_addr.sin_port = htons(PORT);

    if (connect(client_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Bağlantı hatası");
        exit(EXIT_FAILURE);
    }

    // Mikroorganizma bilgilerini sunucuya gönder
    Microorganism microorganism;
    strcpy(microorganism.name, "Mikroorganizma A");
    microorganism.signal_strength = 3;  // Sinyal gücü

    send(client_fd, &microorganism, sizeof(Microorganism), 0);

    printf("Mikroorganizma A sunucuya bağlandı.\n");

    close(client_fd);
    return 0;
}
