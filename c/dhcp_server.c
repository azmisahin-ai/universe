#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define SERVER_IP "0.0.0.0"
#define DHCP_SERVER_PORT 67
#define DHCP_CLIENT_PORT 68
#define MAX_PACKET_SIZE 1024

struct dhcp_packet {
    uint8_t op;      // Mesaj tipi (1 = istemci talebi, 2 = sunucu yanıtı)
    uint8_t htype;   // Donanım tipi (1 = Ethernet)
    uint8_t hlen;    // Donanım adres uzunluğu (Ethernet için 6)
    uint8_t hops;    // Yönlendirici sırası
    uint32_t xid;    // İşlem kimliği
    uint16_t secs;   // İkinci sayacı
    uint16_t flags;  // Flagler
    uint32_t ciaddr; // İstemci IP adresi
    uint32_t yiaddr; // Yönlendirilen IP adresi
    uint32_t siaddr; // Sunucu IP adresi
    uint32_t giaddr; // Yönlendirici IP adresi
    uint8_t chaddr[16]; // Donanım adresi
    uint8_t sname[64];  // Sunucu adı
    uint8_t file[128];  // Dosya adı
    uint32_t magic_cookie; // DHCP sihirli belirteci (0x63825363)
    uint8_t options[312];  // Opsiyonlar
};

void handle_dhcp_request(int sockfd) {
    struct dhcp_packet packet;
    struct sockaddr_in client_addr;
    socklen_t client_addr_len = sizeof(client_addr);

    memset(&packet, 0, sizeof(packet));
    int recv_len = recvfrom(sockfd, &packet, sizeof(packet), 0, (struct sockaddr *)&client_addr, &client_addr_len);
    if (recv_len < 0) {
        perror("Recvfrom failed");
        return;
    }

    printf("DHCP Discover message received from client.\n");

    // Prepare DHCP Offer message
    packet.op = 2; // Boot reply
    packet.yiaddr = htonl(0xC0A80164); // Offered IP address: 192.168.1.100
    packet.siaddr = htonl(0xC0A80101); // Server IP address: 192.168.1.1

    // DHCP magic cookie
    packet.magic_cookie = htonl(0x63825363);

    // DHCP Offer message
    packet.options[0] = 53; // Option 53: DHCP Message Type
    packet.options[1] = 1;  // Length
    packet.options[2] = 2;  // DHCP Offer

    sendto(sockfd, &packet, sizeof(packet), 0, (struct sockaddr *)&client_addr, client_addr_len);
    printf("DHCP Offer message sent to client.\n");
}

int main() {
    int sockfd;
    struct sockaddr_in server_addr;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return 1;
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(DHCP_SERVER_PORT);
    // server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    // server_addr.sin_addr.s_addr = htonl(INADDR_BROADCAST); // Broadcast adresine gönder

    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        return 1;
    }

    printf("DHCP server started. Listening on port %d.\n", DHCP_SERVER_PORT);

    while (1) {
        handle_dhcp_request(sockfd);
    }

    return 0;
}
