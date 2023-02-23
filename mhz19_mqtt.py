#!/usr/bin/env python3

# Install mh-z19 and paho via pip:
# pip3 install mh-z19 paho-mqtt
#
# Subscribing to your MQTT server for testing purpose:
# mosquitto_sub -h hostname -u username -P password -t '#'
#
# run as following (as cronjob for example):
#
# MQTT_HOSTNAME=hostname MQTT_USERNAME=myuser MQTT_PASSWORD=my_password MQTT_TOPIC=/home/room1/co2 /path/to/mhz19_mqtt.py
#
# MQTT_HOSTNAME: hostname or ip of mqtt broker
# MQTT_USERNAME: mqtt username (optional)
# MQTT_PASSWORD: mqtt password (optional)
# MQTT_TOPIC: mqtt topic (optional, default is /home/your-hostname/co2)
#
# https://github.com/UedaTakeyuki/mh-z19

import paho.mqtt.client as mqtt
import mh_z19
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

if 'MQTT_TOPIC' in os.environ:
    topic = os.environ['MQTT_TOPIC']
else:
    topic = '/home/{}/co2'.format(socket.gethostname())

port = 1883
qos = 1

co2 = mh_z19.read_all()
data = {'co2': co2['co2']}

client = mqtt.Client()
if username and password:
    client.username_pw_set(username, password)
try:
    client.connect(broker_address, port)
    client.publish(topic, json.dumps(data), qos=qos)
    client.loop()
except Exception:
    print("Could not connect to MQTT broker :-(")
