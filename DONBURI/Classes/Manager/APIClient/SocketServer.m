#import "SocketServer.h"

// get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa){
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in*)sa)->sin_addr);
    }
    return &(((struct sockaddr_in6*)sa)->sin6_addr);
}

@implementation SocketServer

static SocketServer *_sharedSocket = nil;

+ (SocketServer *)sharedSocket{
    NSString *portNum = [Util objectForKey:kDefaultSocketServerPort];
    if (_sharedSocket == nil) {
        _sharedSocket = [[SocketServer alloc] initWithPort:portNum];
    }
    return _sharedSocket;
}
+ (void)destroySharedSocket{
    [_sharedSocket close];
    _sharedSocket = nil;
}

- (id)initWithPort: (NSString*) port{
   self = [super init];
   int ret = 0;
   memset(&hints, 0, sizeof hints);
   hints.ai_family = AF_INET;
   hints.ai_socktype = SOCK_STREAM;
   hints.ai_flags = AI_PASSIVE; // use my IP
   const char* portStr = [port UTF8String];
   if ((rv = getaddrinfo(NULL, portStr, &hints, &servinfo)) != 0) {
      fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
      ret = 1;
   }else{
      for(p = servinfo; p != NULL; p = p->ai_next) {
        sockfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
         if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &(int){ 1 }, sizeof(int)) < 0){
            perror("server: socket create error");
            continue;
         }
         if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
            close(sockfd);
            perror("server: bind error");
            continue;
         }
         break;
      }
      if (p == NULL)  {
         fprintf(stderr, "server: failed to bind\n");
         ret = 2;
      }else{
         freeaddrinfo(servinfo); // all done with this structure
         if (listen(sockfd, BACKLOG) == -1) {
            perror("server: listen error");
            ret = 3;
         }
      }
      if (ret == 0){
         return self;
      } else {
         return nil;
      }
   }
    return self;
}

- (BOOL)accept {
   BOOL ret = YES;
   new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);
   if (new_fd == -1) {
      perror("server: accept error");
      ret = NO;
   }
   connected = ret;
   return ret;
}

- (void)sendData:(NSString*)strData{
   NSLog(@"***** Send Data To Pepper : %@",strData);
   const char *byteMsg = [strData UTF8String];
    
   ssize_t ret = send(new_fd, byteMsg, strlen(byteMsg), 0); //
   if(ret < 0){
      NSLog(@"error sending bytes");
   }
}

- (NSString* )receiveBytes:(char*)byteMsg maxBytes:(int)max{
   ssize_t ret = recv(new_fd, byteMsg, max, 0);
   if(ret < 0){
      NSLog(@"server error receiving bytes");
   }
   NSString *retStr = [NSString stringWithUTF8String: byteMsg];
   return retStr;
}

- (BOOL)close{
   close(new_fd);
   connected = NO;
   return YES;
}

- (void)dealloc {
   close(sockfd);
   [super dealloc];
}

@end
