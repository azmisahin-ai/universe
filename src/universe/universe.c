#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <time.h>

#define PORT 9001
#define MAX_CLIENTS 10
#define QUORUM_THRESHOLD 1

typedef struct {
    char name[20];
    int signal_strength;
    int active;
    float temperature;
    float pH;
    float oxygen_level;
    float resource_level;
} Microorganism;

// Rastgele sayı üretme fonksiyonu
int get_random_number(int min, int max) {
    static int initialized = 0;
    if (!initialized) {
        srand(time(NULL)); // Yalnızca bir kez tohumlama yap
        initialized = 1;
    }
    return min + rand() / (RAND_MAX / (max - min + 1) + 1);
}

// Rastgele float sayı üretme fonksiyonu
float get_random_float(float min, float max) {
    return min + ((float)rand() / RAND_MAX) * (max - min);
}

int main() {
    int server_fd, client_fds[MAX_CLIENTS];
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);

    Microorganism microorganisms[MAX_CLIENTS];
    int num_microorganisms = 0;

    // Socket oluşturma
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

    printf("Universe dinlemede...\n");

    srand(time(NULL)); // Rastgelelik için tohum ayarla

    while (1) {
        // Yeni bir istemci bağlantısı kabul et
        int client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &addr_len);
        if (client_fd == -1) {
            perror("Bağlantı kabul hatası");
            continue;
        }

        // Istemci soketini `client_fds` dizisine ekle
        if (num_microorganisms < MAX_CLIENTS) {
            client_fds[num_microorganisms] = client_fd;
            num_microorganisms++;
        } else {
            printf("Maksimum istemci sayısına ulaşıldı, yeni istemci kabul edilemiyor.\n");
            close(client_fd);
            continue;
        }

        // Mikroorganizma bilgisini al
        Microorganism new_microorganism;
        recv(client_fd, &new_microorganism, sizeof(Microorganism), 0);

        // Mikroorganizmayı sakla
        microorganisms[num_microorganisms - 1] = new_microorganism;

        // Quorum kontrolü
        if (num_microorganisms >= QUORUM_THRESHOLD) {
            int count = 0;
            for (int i = 0; i < num_microorganisms; i++) {
                if (microorganisms[i].active && microorganisms[i].signal_strength >= QUORUM_THRESHOLD) {
                    count++;
                }
            }

            int quorum_reached = (count >= QUORUM_THRESHOLD) ? 1 : 0;

            // Tüm istemcilere quorum sonucunu gönder
            for (int i = 0; i < num_microorganisms; i++) {
                send(client_fds[i], &quorum_reached, sizeof(int), 0);
            }

            // Quorum durumunu işle
            if (quorum_reached) {
                printf("Quorum sağlandı! Tüm aktif mikroorganizmalar tepki verecek.\n");

                // Çevresel değişkenlerde rastgele değişiklikleri simüle et
                for (int i = 0; i < num_microorganisms; i++) {
                    // Sıcaklık artışı
                    microorganisms[i].temperature += get_random_float(0.0, 5.0);
                    // pH değişikliği
                    microorganisms[i].pH += get_random_float(-1.0, 1.0);
                    // Oksijen seviyesi düşüşü
                    microorganisms[i].oxygen_level -= get_random_float(0.0, 0.05);
                    // Kaynak seviyesi azalması
                    microorganisms[i].resource_level -= get_random_float(0.0, 2.0);

                    // İstemcilere çevresel değişkenleri gönder
                    send(client_fds[i], &microorganisms[i].temperature, sizeof(float), 0);
                    send(client_fds[i], &microorganisms[i].pH, sizeof(float), 0);
                    send(client_fds[i], &microorganisms[i].oxygen_level, sizeof(float), 0);
                    send(client_fds[i], &microorganisms[i].resource_level, sizeof(float), 0);
                }
            } else {
                printf("Quorum sağlanamadı.\n");
            }

            // Bağlantıları kapat ve sunucuyu sıfırla
            for (int i = 0; i < num_microorganisms; i++) {
                close(client_fds[i]);
            }
            num_microorganisms = 0;
            printf("Sunucu sıfırlandı, yeni mikroorganizmaları bekliyor...\n");
        }
    }

    close(server_fd);
    return 0;
}
