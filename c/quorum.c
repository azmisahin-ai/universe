#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define PORT 5000
#define MAX_CLIENTS 5

// Mikroorganizma yapısı
typedef struct {
    char name[20];
    int signal_strength;
} Microorganism;

// Quorum sensing kontrolü
void check_quorum(Microorganism *microorganisms, int num_microorganisms, int threshold) {
    int count = 0;

    for (int i = 0; i < num_microorganisms; i++) {
        if (microorganisms[i].signal_strength >= threshold) {
            count++;
        }
    }

    if (count >= threshold) {
        printf("Quorum sağlandı! Tüm mikroorganizmalar tepki verecek.\n");
    } else {
        printf("Quorum sağlanamadı.\n");
    }
}

int main() {
    int server_fd, client_sockets[MAX_CLIENTS];
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);

    // Sunucu soketi oluştur
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("Socket oluşturma hatası");
        exit(EXIT_FAILURE);
    }

    // Sunucu bağlantı bilgilerini ayarla
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Sunucu soketini bağla
    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Bağlantı hatası");
        exit(EXIT_FAILURE);
    }

    // Sunucuyu dinlemeye başla
    if (listen(server_fd, MAX_CLIENTS) == -1) {
        perror("Dinleme hatası");
        exit(EXIT_FAILURE);
    }

    printf("Sunucu dinleniyor...\n");

    // Mikroorganizma verileri
    Microorganism microorganisms[MAX_CLIENTS];
    int num_microorganisms = 0;

    while (1) {
        // Yeni bir istemci bağlantısı kabul et
        int client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &addr_len);
        if (client_fd == -1) {
            perror("Bağlantı kabul hatası");
            continue;
        }

        // İstemci bilgilerini al
        recv(client_fd, &microorganisms[num_microorganisms], sizeof(Microorganism), 0);
        printf("%s bağlandı.\n", microorganisms[num_microorganisms].name);

        // Mikroorganizmayı sayıyı arttır
        num_microorganisms++;

        // Tüm mikroorganizmalar için quorum sensing kontrolü yap
        int threshold = 3;  // Quorum eşiği
        if (num_microorganisms >= threshold) {
            check_quorum(microorganisms, num_microorganisms, threshold);
        }
    }

    close(server_fd);
    return 0;
}
