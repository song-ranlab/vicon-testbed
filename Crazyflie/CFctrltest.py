import socket
import sys

def IPpyservertest():
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind the socket to the port
    server_address = ('carbon', 10000)
    #print >>sys.stderr, 'starting up on %s port %s' % server_address
    print('starting up on %s port %s' % server_address)
    sock.bind(server_address)

    # Listen for incoming connections
    sock.listen(1)

    while True:
        # Wait for a connection
        print( 'waiting for a connection', sys.stderr)
        connection, client_address = sock.accept()

        try:
            
            print('connection from', client_address, sys.stderr)
            # Receive the data in small chunks and retransmit it
            while True:
                data = connection.recv(16)
                #print('received "%s"' % data, sys.stderr)
                if data:
                    #print('sending data back to the client', sys.stderr)
                    connection.sendall(data)
                    print(data)
  
                else:
                    #print('no more data from', client_address, sys.stderr)
                    break
                
        finally:
            # Clean up the connection
            connection.close()

if __name__ == "__main__":
    IPpyservertest()

    
