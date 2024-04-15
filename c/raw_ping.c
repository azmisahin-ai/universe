#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <arpa/inet.h>

#define PACKET_SIZE 64
#define DESTINATION_IP "8.8.8.8" // Google DNS

// Checksum hesaplama fonksiyonu
unsigned short calculate_checksum(unsigned short *ptr, int nbytes) {
    unsigned long sum;
    unsigned short oddbyte;
    unsigned short checksum;

    sum = 0;
    while (nbytes > 1) {
        sum += *ptr++;
        nbytes -= 2;
    }
    if (nbytes == 1) {
        oddbyte = 0;
        *((unsigned char *)&oddbyte) = *(unsigned char *)ptr;
        sum += oddbyte;
    }

    sum = (sum >> 16) + (sum & 0xFFFF);
    sum += (sum >> 16);
    checksum = ~sum;
    return checksum;
}

int main() {
    int sockfd;
    struct sockaddr_in dest_addr;
    char packet[PACKET_SIZE];
    struct iphdr *ip_header;
    struct icmphdr *icmp_header;
    int packet_size;

    // Socket oluşturma
    sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return 1;
    }

    // Hedef adresi ayarlama
    memset(&dest_addr, 0, sizeof(dest_addr));
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_addr.s_addr = inet_addr(DESTINATION_IP);

    // ICMP paketi oluşturma
    memset(packet, 0, PACKET_SIZE);

    ip_header = (struct iphdr *)packet;
    icmp_header = (struct icmphdr *)(packet + sizeof(struct iphdr));

    ip_header->ihl = 5;
    ip_header->version = 4;
    ip_header->tos = 0;
    ip_header->tot_len = sizeof(struct iphdr) + sizeof(struct icmphdr);
    ip_header->id = htons(12345);
    ip_header->frag_off = 0;
    ip_header->ttl = 64;
    ip_header->protocol = IPPROTO_ICMP;
    ip_header->check = 0;
    ip_header->saddr = inet_addr("192.168.1.100"); // Kaynak IP adresi
    ip_header->daddr = dest_addr.sin_addr.s_addr;

    icmp_header->type = ICMP_ECHO;
    icmp_header->code = 0;
    icmp_header->un.echo.id = 0;
    icmp_header->un.echo.sequence = 0;
    icmp_header->checksum = 0;
    icmp_header->checksum = calculate_checksum((unsigned short *)icmp_header, sizeof(struct icmphdr));

    // Paketi gönderme
    packet_size = sizeof(struct iphdr) + sizeof(struct icmphdr);
    if (sendto(sockfd, packet, packet_size, 0, (struct sockaddr *)&dest_addr, sizeof(dest_addr)) <= 0) {
        perror("Packet send failed");
        return 1;
    }

    printf("ICMP Echo Request sent to %s\n", DESTINATION_IP);

    close(sockfd);
    return 0;
}
