#!/usr/bin/env python3

import json
import os
import socket


def get_settings(file_name):
    if os.path.exists(file_name):
        with open(file_name) as file:
            data = json.load(file)
    else:
        data = {"drive.google.com": "", "mail.google.com": "", "google.com": ""}

    return data


def check_availability(settings):
    new_settings = {}
    is_change = False

    for url_service, ip in settings.items():
        current_ip = socket.gethostbyname(url_service)
        if current_ip != ip:
            print(f' [ERROR] <{url_service}> IP mismatch: <{ip}> <{current_ip}>')
            is_change = True

        new_settings.update({url_service: current_ip})

    return is_change, new_settings


def save_settings(file_name, data):
    with open(file_name, "w", encoding="utf-8") as file:
        json.dump(data, file)

SETTINGS_FILE_NAME = "./settings_script.json"

settings = get_settings(SETTINGS_FILE_NAME)

is_change, new_settings = check_availability(settings)

if is_change:
    save_settings(SETTINGS_FILE_NAME, new_settings)

