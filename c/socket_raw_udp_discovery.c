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

            // UDP başlığındaki veri boyutunu al
            int udp_data_size = ntohs(udp_header->len) - sizeof(struct udphdr);

            // DHCP discovery mesajının içeriğini kontrol et
            if (dest_port == 67 && udp_data_size >= 4) {
                unsigned char *udp_data = buffer + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct udphdr);
                
                // DHCP discovery mesajının ilk 4 byte'ı 53, 1, 1, 6 ise bu bir DHCP discovery mesajıdır
                if (udp_data[0] == 53 && udp_data[1] == 1 && udp_data[2] == 1 && udp_data[3] == 6) {
                    printf("DHCP Discovery message received:\n");
                    printf("Source IP: %s, Source Port: %d\n", inet_ntoa(*(struct in_addr *)&ip_header->saddr), source_port);
                    printf("Destination IP: %s, Destination Port: %d\n", inet_ntoa(*(struct in_addr *)&ip_header->daddr), dest_port);
                }
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

    printf("Raw socket created. Listening for DHCP Discovery messages...\n");

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
