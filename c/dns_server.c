#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 53
#define MAX_QUERY_SIZE 1024

void handle_dns_query(int server_socket, const unsigned char *query_data, int query_len, struct sockaddr_in client_addr)
{
    // Burada DNS sorgusu işlenmeli ve cevap oluşturulmalı
    // Örnek bir cevap oluşturalım (örneğin, sadece 1.2.3.4 IPv4 adresi)
    unsigned char response_data[MAX_QUERY_SIZE] = {0};
    int response_len = 0;

    // DNS cevabı oluştur (örnek cevap: example.com için A tipi kaydı)
    memcpy(response_data, query_data, query_len); // Gelen sorguyu cevap olarak kopyala
    response_len = query_len;

    // Cevap veri alanı düzenlemesi (örneğin, 1.2.3.4 IPv4 adresi)
    response_data[2] |= 0x80; // Set response bit
    response_data[3] |= 0x80; // Set authoritative bit

    // IP adresini ekle (örnek cevap: 1.2.3.4)
    response_data[response_len++] = 0xc0; // Compression pointer to start of name
    response_data[response_len++] = 0x0c; // Compression pointer to start of name
    response_data[response_len++] = 0x00; // Type A
    response_data[response_len++] = 0x01; // Class IN
    response_data[response_len++] = 0x00; // TTL (örneğin, 1 saniye)
    response_data[response_len++] = 0x00; // TTL (örneğin, 1 saniye)
    response_data[response_len++] = 0x00; // TTL (örneğin, 1 saniye)
    response_data[response_len++] = 0x01; // TTL (örneğin, 1 saniye)
    response_data[response_len++] = 0x00; // Data length (IPv4 adresi için 4 byte)
    response_data[response_len++] = 0x04; // Data length (IPv4 adresi için 4 byte)
    response_data[response_len++] = 0x01; // 1. byte (örneğin, 1)
    response_data[response_len++] = 0x02; // 2. byte (örneğin, 2)
    response_data[response_len++] = 0x03; // 3. byte (örneğin, 3)
    response_data[response_len++] = 0x04; // 4. byte (örneğin, 4)

    // Sunucuya DNS cevabını gönder
    sendto(server_socket, response_data, response_len, 0, (struct sockaddr *)&client_addr, sizeof(client_addr));
}

int main()
{
    int server_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    unsigned char query_data[MAX_QUERY_SIZE];

    // UDP socket oluştur
    server_socket = socket(AF_INET, SOCK_DGRAM, 0);
    if (server_socket < 0)
    {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Sunucu adresini ayarla
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    server_addr.sin_port = htons(SERVER_PORT);

    // Sunucuyu bağla
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
    {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    printf("DNS Sunucusu başlatıldı. (%s:%d)\n", SERVER_IP, SERVER_PORT);

    while (1)
    {
        // Gelen DNS sorgusunu al
        int recv_len = recvfrom(server_socket, query_data, MAX_QUERY_SIZE, 0, (struct sockaddr *)&client_addr, &client_addr_len);
        if (recv_len < 0)
        {
            perror("Recvfrom failed");
            continue;
        }

        printf("Gelen DNS sorgusu: %s\n", query_data);

        // DNS sorgusunu işle
        handle_dns_query(server_socket, query_data, recv_len, client_addr);
        printf("Cevap gönderildi.\n");
    }

    // Socketi kapat
    close(server_socket);

    return 0;
}
