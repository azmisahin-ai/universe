#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define ROOT_DNS_IP "127.0.0.1"   // A root DNS sunucusunun IP adresi (örnek: a.root-servers.net)
#define DNS_PORT 53                // DNS sunucuları genellikle 53 numaralı portu kullanır

// DNS başlık yapısı
struct DNSHeader {
    unsigned short id;
    unsigned short flags;
    unsigned short qcount;
    unsigned short ans_count;
    unsigned short auth_count;
    unsigned short add_count;
};

// DNS sorgu yapısı
struct DNSQuery {
    unsigned short qtype;
    unsigned short qclass;
};

int main() {
    int sockfd;
    struct sockaddr_in dest_addr;
    char dns_query[1024];
    struct DNSHeader *dns_header = (struct DNSHeader *)dns_query;
    struct DNSQuery *dns_query_data = (struct DNSQuery *)(dns_query + sizeof(struct DNSHeader));

    // UDP socket oluştur
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    memset(&dest_addr, 0, sizeof(dest_addr));

    // Kök DNS sunucusunun adresini ve port numarasını ayarla
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = htons(DNS_PORT);
    dest_addr.sin_addr.s_addr = inet_addr(ROOT_DNS_IP);

    // DNS sorgusu oluştur
    dns_header->id = htons(12345);   // Örnek bir ID
    dns_header->flags = htons(0x0100);  // Standart DNS sorgusu
    dns_header->qcount = htons(1);    // Bir sorgu yapılacak
    dns_header->ans_count = 0;
    dns_header->auth_count = 0;
    dns_header->add_count = 0;

    // DNS sorgusu verilerini ayarla (örneğin: google.com)
    strcpy(dns_query + sizeof(struct DNSHeader), "\x06google\x03com\x00");
    dns_query_data = (struct DNSQuery *)(dns_query + sizeof(struct DNSHeader) + strlen("\x06google\x03com\x00"));
    dns_query_data->qtype = htons(1);  // A (IPv4 adresi) sorgusu
    dns_query_data->qclass = htons(1); // IN (Internet) sorgusu

    // Kök DNS sunucusuna DNS sorgusunu gönder
    if (sendto(sockfd, dns_query, sizeof(struct DNSHeader) + strlen("\x06google\x03com\x00") + sizeof(struct DNSQuery), 0,
               (const struct sockaddr *)&dest_addr, sizeof(dest_addr)) < 0) {
        perror("DNS query failed");
        exit(EXIT_FAILURE);
    }

    printf("DNS query sent to %s:%d\n", ROOT_DNS_IP, DNS_PORT);

    // DNS cevabını al
    char buffer[1024];
    socklen_t len = sizeof(dest_addr);
    int n = recvfrom(sockfd, buffer, sizeof(buffer), 0,
                     (struct sockaddr *)&dest_addr, &len);

    if (n < 0) {
        perror("Failed to receive DNS response");
        exit(EXIT_FAILURE);
    }

    printf("DNS response received (%d bytes)\n", n);

    // DNS cevabını işleme veya ekrana yazdırma (çözümleme)
    // Burada DNS cevabını analiz ederek alan adının IP adresini çözebilirsiniz

    close(sockfd);
    return 0;
}
