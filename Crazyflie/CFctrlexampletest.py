import socket
import sys
import logging
import time

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie

URI = 'radio://0/80/2M'

# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)

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

                    #crazyflie example
                    # Initialize the low-level drivers (don't list the debug drivers)
                    cflib.crtp.init_drivers(enable_debug_driver=False)
                    with SyncCrazyflie(URI, cf=Crazyflie(rw_cache='./cache')) as scf:
                        cf = scf.cf

                        cf.param.set_value('kalman.resetEstimation', '1')
                        time.sleep(0.1)
                        cf.param.set_value('kalman.resetEstimation', '0')
                        time.sleep(2)

                        for y in range(10):
                            cf.commander.send_hover_setpoint(0, 0, 0, y / 25)
                            time.sleep(0.1)

                        for _ in range(20):
                            cf.commander.send_hover_setpoint(0, 0, 0, 0.4)
                            time.sleep(0.1)

                        for _ in range(50):
                            cf.commander.send_hover_setpoint(0.5, 0, 36 * 2, 0.4)
                            time.sleep(0.1)

                        for _ in range(50):
                            cf.commander.send_hover_setpoint(0.5, 0, -36 * 2, 0.4)
                            time.sleep(0.1)

                        for _ in range(20):
                            cf.commander.send_hover_setpoint(0, 0, 0, 0.4)
                            time.sleep(0.1)

                        for y in range(10):
                            cf.commander.send_hover_setpoint(0, 0, 0, (10 - y) / 25)
                            time.sleep(0.1)

                        cf.commander.send_stop_setpoint()

                    
                else:
                    #print('no more data from', client_address, sys.stderr)
                    break
                
        finally:
            # Clean up the connection
            connection.close()

if __name__ == "__main__":
    IPpyservertest()

    
