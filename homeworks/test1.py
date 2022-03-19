#!/usr/bin/env python3

import requests


username = "ra-leonid"
password = "qjuf7Cenhs!"
token = "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"
repo = 'test'

r = requests.get('https://api.github.com/user', auth=(username, token))
# r = requests.get('https://api.github.com/user', auth=(username, password))
url = f'https://api.github.com/repos/{username}/{repo}/pulls'

params = {"title": "commip PR", "head": "iss53", "base": "master", "draft": False, "accept": "application/vnd.github.v3+json"}
params = {"title": "commip PR", "head": "iss53", "base": "master", "draft": True}
pr = requests.post(url, auth=(username, token), params=params)

pass
