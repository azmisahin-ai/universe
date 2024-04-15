#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 3000
#define SERVER_IP "127.0.0.1"
#define MAX_BUFFER_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[MAX_BUFFER_SIZE];

    // TCP soket oluştur
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Sunucu adresini ayarla
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);

    // Sunucuya bağlan
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Connection failed");
        exit(EXIT_FAILURE);
    }

    // Kullanıcıdan mesaj al
    printf("Enter message for server: ");
    fgets(buffer, MAX_BUFFER_SIZE, stdin);

    // Sunucuya mesaj gönder
    send(sockfd, buffer, strlen(buffer), 0);
    printf("Message sent to server.\n");

    // Sunucudan cevap al
    memset(buffer, 0, MAX_BUFFER_SIZE); // Bufferı temizle
    int bytes_received = recv(sockfd, buffer, MAX_BUFFER_SIZE, 0);
    buffer[bytes_received] = '\0'; // Null terminate the received data

    printf("Response from server: %s\n", buffer);

    close(sockfd);

    return 0;
}
