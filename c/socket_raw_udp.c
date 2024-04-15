#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/if_ether.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <netinet/udp.h>

void process_packet(unsigned char *buffer, int size) {
    struct ethhdr *eth = (struct ethhdr *)buffer;

    // IP paketi başlangıcını almak için 14 byte ötesine geçiyoruz
    struct iphdr *ip_header = (struct iphdr *)(buffer + sizeof(struct ethhdr));

    // Sadece IPv4 (0x0800) paketlerini işleyeceğiz
    if (ntohs(eth->h_proto) == ETH_P_IP) {
        if (ip_header->protocol == IPPROTO_UDP) {
            struct udphdr *udp_header = (struct udphdr *)(buffer + sizeof(struct ethhdr) + sizeof(struct iphdr));

            // UDP başlığındaki hedef ve kaynak port numaralarını al
            unsigned short source_port = ntohs(udp_header->source);
            unsigned short dest_port = ntohs(udp_header->dest);

            printf("Received UDP Packet from %s:%d to %s:%d\n",
                   inet_ntoa(*(struct in_addr *)&ip_header->saddr),
                   source_port,
                   inet_ntoa(*(struct in_addr *)&ip_header->daddr),
                   dest_port);

            // UDP verilerini almak için başlık boyutunu geç
            int udp_data_size = size - sizeof(struct ethhdr) - sizeof(struct iphdr) - sizeof(struct udphdr);
            if (udp_data_size > 0) {
                unsigned char *udp_data = buffer + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct udphdr);
                printf("UDP Data: ");
                for (int i = 0; i < udp_data_size; i++) {
                    printf("%c", udp_data[i]);
                }
                printf("\n");
            }
        }
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
