#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/if_ether.h>
#include <net/if.h>
#include <arpa/inet.h>

void process_packet(unsigned char *buffer, int size) {
    // Ethernet frame'in başlangıcındaki MAC adresleri
    struct ethhdr *eth = (struct ethhdr *)buffer;

    // IP paketi başlangıcını almak için 14 byte ötesine geçiyoruz
    unsigned short ethertype = ntohs(eth->h_proto);

    // Sadece IPv4 (0x0800) paketlerini işleyeceğiz
    if (ethertype == ETH_P_IP) {
        printf("Received IP Packet of size %d bytes\n", size);
        // Burada IP paketini işleyebiliriz, ancak basitçe boyutunu yazdırıyoruz
    }
}

int main() {
    int sock;
    unsigned char buffer[65536]; // Maksimum paket boyutu

    // Raw socket oluştur
    sock = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
    if (sock < 0) {
        perror("Socket creation failed");
        return 1;
    }

    printf("Raw socket created. Listening for packets...\n");

    while (1) {
        int data_size = recvfrom(sock, buffer, sizeof(buffer), 0, NULL, NULL);
        if (data_size < 0) {
            perror("Packet receive error");
            break;
        }

        // Paket verisi alındı, işleme fonksiyonunu çağır
        process_packet(buffer, data_size);
    }

    close(sock);
    printf("Socket closed.\n");
    return 0;
}
