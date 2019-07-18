import socket
import json

import machine
from time import sleep

import depslep
import dht

# put pin D6 as input pin for the data dht11
d = dht.DHT11(machine.Pin(12))

d.measure()

hum = d.humidity()
temp = d.temperature()


UDP_IP = "Ip @ phone"
UDP_PORT = 5005

data = '{"temp": "'+str(temp)+'","hum":"'+str(hum)+'"}'

MESSAGE = str(data)

print("UDP target IP:", UDP_IP)
print("UDP target port:", UDP_PORT)
print("message:", MESSAGE)

sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP
sock.sendto(str.encode(MESSAGE), (UDP_IP, UDP_PORT))

# it's important to add this 5 sec for catching the micro awake
sleep(5)
print('Im awake, but Im going to sleep')

# go to sleep for 10 sec
depslep.deep_sleep(10000)
