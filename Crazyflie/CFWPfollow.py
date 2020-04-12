import socket
import sys
import logging
import time
import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.position_hl_commander import PositionHlCommander

URI = 'radio://0/80/2M'

# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)
def IPpyserver():
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind the socket to the port
    server_address = ('192.168.0.100', 10000)
    #print('starting up on %s port %s' % server_address)
    sock.bind(server_address)

    # Listen for incoming connections
    sock.listen(1)

    while True:
        # Wait for a connection
        #print( 'waiting for a connection', sys.stderr)
        connection, client_address = sock.accept()

        try:
            
            #print('connection from', client_address, sys.stderr)
            # Receive the data in small chunks and retransmit it
            wp=bytes()
            while True:
                data = connection.recv(16)
                #print('received "%s"' % data, sys.stderr)
                wpnew=data
                wp = wp + wpnew

                if data:
                    #print('sending data back to the client', sys.stderr)
                    connection.sendall(data)
                    #print(data)
                    #print(type(data))
                    
                else:
                    #print('no more data from', client_address, sys.stderr)
                    #print(wp)
                    #print(type(wp))

                    #save data as waypoints
                    wp = wp.decode('utf8').replace('b','').replace('\n','').replace("'",'').split(',')
                    #print(wp)
                    x,y,z,v,psi = wp[0].replace('x','').replace('=',''),\
                                  wp[1].replace('y','').replace('=',''),\
                                  wp[2].replace('z','').replace('=',''),\
                                  wp[3].replace('v','').replace('=',''),\
                                  wp[4].replace('psi','').replace('=','')
                    #print(x,y,z,v,psi)
                    return x,y,z,v,psi
                    
                    break


        finally:
            # Clean up the connection
            connection.close()
            
if __name__ == '__main__':

    
    # Initialize the low-level drivers (don't list the debug drivers)
    cflib.crtp.init_drivers(enable_debug_driver=False)

    with SyncCrazyflie(URI, cf=Crazyflie(rw_cache='./cache')) as scf:
        cf = scf.cf
        print(cf)
        cf.param.set_value('kalman.resetEstimation', '1')
        time.sleep(0.1)
        cf.param.set_value('kalman.resetEstimation', '0')
        time.sleep(2)
        with PositionHlCommander(
                    scf,x=0.0, y=0.0, z=0.0,default_velocity=0.3,default_height=0.5,
                    controller=PositionHlCommander.CONTROLLER_MELLINGER) as pc:
##            pc.take_off()
            time.sleep(20)
            pc.land()
##        for y in range(10):
##            cf.commander.send_hover_setpoint(0, 0, 0, y / 25)
##            time.sleep(0.1)
##            cf.commander.send_hover_setpoint(0, 0, 0, 0.4)
        #while True:
            #time.sleep(0.1)
            #x,y,z,v,psi=IPpyserver()
            #print(x,y,z,v,psi)
            
##                pc.move_distance(0.0,0.0,0.5)
##            time.sleep(1)





















##        with PositionHlCommander(
##                scf,
##                x=0.0, y=0.0, z=0.0,
##                default_velocity=0.3,
##                default_height=0.5,
##                controller=PositionHlCommander.CONTROLLER_MELLINGER) as pc:
##        
##        pc.move_distance(self, x, 0, z,v):
##
##        for _ in range(50):
##            cf.commander.send_hover_setpoint(0.5, 0, 36 * 2, 0.4)
##            time.sleep(0.1)
##
##        for _ in range(50):
##            cf.commander.send_hover_setpoint(0.5, 0, -36 * 2, 0.4)
##            time.sleep(0.1)
##
##        for _ in range(20):
##            cf.commander.send_hover_setpoint(0, 0, 0, 0.4)
##            time.sleep(0.1)
##
##        for y in range(10):
##            cf.commander.send_hover_setpoint(0, 0, 0, (10 - y) / 25)
##            time.sleep(0.1)
##
##        cf.commander.send_stop_setpoint()

