#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 3000
#define MAX_BUFFER_SIZE 1024

int main() {
    int server_fd, new_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    char buffer[MAX_BUFFER_SIZE];

    // TCP soket oluştur
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Sunucu adresini ayarla
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Soketi sunucuya bağla
    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    // Sunucuyu dinleme moduna al
    if (listen(server_fd, 5) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }

    printf("TCP server is running on port %d...\n", PORT);

    // Bağlantı kabul et
    if ((new_socket = accept(server_fd, (struct sockaddr *)&client_addr, &client_len)) < 0) {
        perror("Accept failed");
        exit(EXIT_FAILURE);
    }

    // İstemciden mesaj al
    int bytes_received = recv(new_socket, buffer, MAX_BUFFER_SIZE, 0);
    buffer[bytes_received] = '\0'; // Null terminate the received data
    printf("Message from client: %s\n", buffer);

    // Cevap gönder
    const char *response = "Hello from TCP server";
    send(new_socket, response, strlen(response), 0);
    printf("Response sent to client.\n");

    close(new_socket);
    close(server_fd);

    return 0;
}
