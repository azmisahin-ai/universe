#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

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

void send_dhcp_discover(int sockfd) {
    struct dhcp_packet packet;

    memset(&packet, 0, sizeof(packet));
    packet.op = 1; // Boot request
    packet.htype = 1; // Ethernet
    packet.hlen = 6; // Ethernet MAC address length
    packet.xid = getpid(); // Transaction ID
    packet.flags = htons(0x8000); // Broadcast flag

    // DHCP magic cookie
    packet.magic_cookie = htonl(0x63825363);

    // DHCP Discover message
    packet.options[0] = 53; // Option 53: DHCP Message Type
    packet.options[1] = 1;  // Length
    packet.options[2] = 1;  // DHCP Discover

    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(DHCP_SERVER_PORT);
    server_addr.sin_addr.s_addr = htonl(INADDR_BROADCAST); // Broadcast adresine gönder

    sendto(sockfd, &packet, sizeof(packet), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
    printf("DHCP Discover message sent.\n");
}

int main() {
    int sockfd;
    struct sockaddr_in client_addr;

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return 1;
    }

    memset(&client_addr, 0, sizeof(client_addr));
    client_addr.sin_family = AF_INET;
    client_addr.sin_port = htons(DHCP_CLIENT_PORT);
    client_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(sockfd, (struct sockaddr *)&client_addr, sizeof(client_addr)) < 0) {
        perror("Bind failed");
        return 1;
    }

    printf("DHCP client started. Listening on port %d.\n", DHCP_CLIENT_PORT);

    // Send DHCP Discover message
    send_dhcp_discover(sockfd);

    // Wait for DHCP Offer (timeout can be implemented here)
    sleep(5); // Wait for 5 seconds for response

    printf("No DHCP Offer received. Assuming no DHCP server present.\n");

    return 0;
}
