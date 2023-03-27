#!/usr/bin/python3
import requests
import sys


def is_kodi_idle(host):
    username = 'kodi'
    password = 'kodi'
    payload = {
            'jsonrpc': '2.0',
            'method': 'XBMC.GetInfoBooleans',
            'params':
            {'booleans': ['System.ScreenSaverActive']},
            'id': 1}
    try:
        r = requests.post(
            'http://{}:8080/jsonrpc'.format(host),
            json=payload,
            auth=(username, password)
        )
        result = r.json()['result']
        return bool(next(iter(result.values())))
    except Exception:
        return True


def main():
    hosts = ['libreelec-wohnzimmer', 'libreelec-schlafzimmer']
    active_kodis = 0

    for host in hosts:
        idle = is_kodi_idle(host)
        if not idle:
            active_kodis += 1
    if active_kodis > 0:
        return 1
    else:
        return 0


if __name__ == '__main__':
    # exit with 0 if no kodi is active
    sys.exit(main())
