import sys
import socket

def IPpydatatest(x):
    print(x)

def IPpyclientfunc(x):
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Connect the socket to the port where the server is listening
    server_address = ('carbon', 10000)
    #print >>sys.stderr, 'connecting to %s port %s' % server_address
    print('connecting to %s port %s' % server_address, sys.stderr)
    sock.connect(server_address)
    try:
        
        # Send data
            #message = 'This is the message.  It will be repeated.'
            #print >>sys.stderr, 'sending "%s"' % message
        #print('sending "%s" "%s" "%s"',% x,% y,% z,sys.stderr)
        sock.sendall(x.encode())
        #sock.sendall(y.encode())
        #sock.sendall(z.encode())
        # Look for the response
        amount_received = 0
        amount_expected = len(x)
        
        while amount_received < amount_expected:
            data = sock.recv(16)
            amount_received += len(data)
            #print >>sys.stderr, 'received "%s"' % data
            print('received "%s"' % data, sys.stderr)

    finally:
        #print >>sys.stderr, 'closing socket'
        print('closing socket', sys.stderr)
        sock.close()

if __name__ == "__main__":
    x = sys.argv[1]
    IPpydatatest(x)
    IPpyclientfunc(x)
