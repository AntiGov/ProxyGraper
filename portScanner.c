/**
* Author : AntiGov @ MA
* Simple Single Port Scanner
**/

#include <stdio.h>
#include <sys/socket.h>
#include <errno.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <ctype.h>
#include <arpa/inet.h>

int portScan(char *hostname, int port);
 
int main(int argc , char **argv)
{
    if(argc != 3){
    	printf("Usage: %s host port\n", argv[0]);
    	exit(1);
    }
     
     char *hostname = argv[1];
     int port = atoll(argv[2]);
     
     printf("host: %s port: %d\n",hostname,port);
     
     if(portScan(hostname,port)){
     	printf("%s\n", "success");
     }else{
     	printf("%s\n", "fails");
     }
    return(0);
}

int portScan(char *hostname, int port){
    struct hostent *host;
    int err ,sock;
  
    struct sockaddr_in sa;

    strncpy((char*)&sa , "" , sizeof sa);
    sa.sin_family = AF_INET;
     
    if(isdigit(hostname[0])){
        sa.sin_addr.s_addr = inet_addr(hostname);
    }else if( (host = gethostbyname(hostname)) != 0){
     
        strncpy((char*)&sa.sin_addr , (char*)host->h_addr , sizeof sa.sin_addr);
    }else{
        herror(hostname);
        exit(2);
    }
        sa.sin_port = htons(port);
        sock = socket(AF_INET , SOCK_STREAM , 0);
        if(sock < 0){
            perror("\nSocket");
            exit(1);
        }
        err = connect(sock , (struct sockaddr*)&sa , sizeof sa);
        if( err < 0 )
        	return 0;
        return 1;
      
    close(sock);
}
