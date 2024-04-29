#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <time.h>

#define PORT 9001
#define SERVER_IP "127.0.0.1"  // Sunucu IP adresi

typedef struct {
    char name[20];
    int signal_strength;
    int active;
    float temperature;    // Sıcaklık değeri
    float pH;             // pH değeri
    float oxygen_level;   // Oksijen seviyesi
    float resource_level; // Kaynak seviyesi
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

int main() {
    int client_fd;
    struct sockaddr_in server_addr;

    // Socket oluşturma
    if ((client_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("Socket oluşturma hatası");
        exit(EXIT_FAILURE);
    }

    // Sunucu bağlantı bilgilerini ayarla
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);

    // Sunucuya bağlan
    if (connect(client_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("Sunucuya bağlanma hatası");
        exit(EXIT_FAILURE);
    }

    printf("Universe bağlantısı gerçekleşti.\n");

    // Rastgele mikroorganizma oluştur
    Microorganism my_microorganism;
    sprintf(my_microorganism.name, "Mikroorganizma-%d", getpid());
    my_microorganism.signal_strength = get_random_number(1, 10); // 1 ile 10 arasında rastgele sinyal gücü
    my_microorganism.active = 1;

    // Mikroorganizmayı sunucuya gönder
    send(client_fd, &my_microorganism, sizeof(Microorganism), 0);
    printf("%s Sinyal gücü: %d\n", my_microorganism.name, my_microorganism.signal_strength);

    // Sunucudan quorum kontrol sonucunu al
    int quorum_reached;
    recv(client_fd, &quorum_reached, sizeof(int), 0);

    // Quorum durumunu işle
    if (quorum_reached) {
        printf("Quorum sağlandı! Çevresel değişkenler alınıyor...\n");

        // Sunucudan çevresel değişkenleri al
        recv(client_fd, &my_microorganism.temperature, sizeof(float), 0);
        recv(client_fd, &my_microorganism.pH, sizeof(float), 0);
        recv(client_fd, &my_microorganism.oxygen_level, sizeof(float), 0);
        recv(client_fd, &my_microorganism.resource_level, sizeof(float), 0);

        // Çevresel değişkenlere tepkiyi işle
        if (my_microorganism.temperature > 30.0) {
            printf("%s sıcaklık değişikliğine tepki veriyor...\n", my_microorganism.name);
        }

        if (my_microorganism.pH < 6.0) {
            printf("%s asitik bir ortama tepki veriyor...\n", my_microorganism.name);
        }

        if (my_microorganism.oxygen_level < 0.1) {
            printf("%s düşük oksijen seviyesine tepki veriyor...\n", my_microorganism.name);
        }

        if (my_microorganism.resource_level > 50.0) {
            printf("%s yüksek kaynak seviyesine sahip, diğer organizmalarla rekabet ediyor...\n", my_microorganism.name);
        }
    } else {
        printf("Quorum sağlanamadı.\n");
    }

    // Bağlantıyı kapat
    close(client_fd);

    return 0;
}
