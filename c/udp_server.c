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
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    char buffer[MAX_BUFFER_SIZE];

    // UDP soket oluştur
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Sunucu adresini ayarla
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Soketi sunucuya bağla
    if (bind(sockfd, (const struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    printf("UDP server is running on port %d...\n", PORT);

    // UDP istemciden mesaj al ve cevapla
    while (1) {
        int bytes_received = recvfrom(sockfd, (char *)buffer, MAX_BUFFER_SIZE, 0,
                                      (struct sockaddr *)&client_addr, &client_len);
        buffer[bytes_received] = '\0'; // Null terminate the received data
        printf("Message from client: %s\n", buffer);

        // Eğer istemciden mesaj alındıysa, cevap gönder
        const char *response = "Hello from UDP server";
        sendto(sockfd, response, strlen(response), 0,
               (const struct sockaddr *)&client_addr, client_len);
        printf("Response sent to client.\n");
    }

    return 0;
}
