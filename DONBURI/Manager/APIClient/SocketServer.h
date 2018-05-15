#import <Foundation/Foundation.h>

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <signal.h>
#include <sys/wait.h>
#include <netdb.h>
#include <unistd.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define BACKLOG 10  /* queue size for pending connect requests */

@interface SocketServer : NSObject {
   int sockfd, new_fd, rv;
   BOOL connected;
   struct addrinfo hints, *servinfo, *p;
   struct sockaddr_storage their_addr;
   socklen_t sin_size;
   struct in_addr address;
}

+ (SocketServer *)sharedSocket;
+ (void)destroySharedSocket;

- (id)initWithPort:(NSString*)port;
- (BOOL)accept;
- (void)sendData:(NSString*)strData;
- (NSString*)receiveBytes:(char*)byteMsg maxBytes:(int)max;
- (BOOL)close;
@end

