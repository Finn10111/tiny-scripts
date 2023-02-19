#!/usr/bin/env python3

# Install Adafruit_DHT and paho via pip:
# pip3 install Adafruit_DHT paho-mqtt
# 
# Subscribing to your MQTT server for testing purpose:
# mosquitto_sub -h hostname -u username -P password -t '#'
#
# run as following (as cronjob for example):
#
# MQTT_HOSTNAME=hostname MQTT_USERNAME=myuser MQTT_PASSWORD=my_password MQTT_TOPIC=/home/room1/dht PIN=17 /path/to/dht_mqtt.py
#
# MQTT_HOSTNAME: hostname or ip of mqtt broker
# MQTT_USERNAME: mqtt username (optional)
# MQTT_PASSWORD: mqtt password (optional)
# MQTT_TOPIC: mqtt topic (optional, default is /home/your-hostname/dht)
# PIN: Raspberry Pi GPIO Pin (optional, default ist 17)

import paho.mqtt.client as mqtt
import Adafruit_DHT
import socket
import json
import sys
import os

if 'MQTT_HOSTNAME' in os.environ:
    broker_address = os.environ['MQTT_HOSTNAME']
else:
    print('No broker address was given, exiting.')
    sys.exit(1)

if 'MQTT_USERNAME' in os.environ and 'MQTT_PASSWORD' in os.environ:
    username = os.environ['MQTT_USERNAME']
    password = os.environ['MQTT_PASSWORD']

if 'PIN' in os.environ:
    pin = os.environ['pin']
else:
    pin = 17 # default pin

if 'MQTT_TOPIC' in os.environ:
    topic = os.environ['MQTT_TOPIC']
else:
    topic = '/home/{}/dht'.format(socket.gethostname())

port = 1883
qos = 1

hum, temp = Adafruit_DHT.read_retry(Adafruit_DHT.DHT22, pin)
data = {'temperature': round(temp, 1), 'humidity': round(hum, 1)}

client = mqtt.Client()
if username and password:
    client.username_pw_set(username, password)
client.connect(broker_address, port)
client.publish(topic, json.dumps(data), qos=qos)
client.loop()
