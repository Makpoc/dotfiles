#!/usr/bin/env python2.7

import subprocess

# Requires a root cron, which refreshes the repo cache

try:
    out = subprocess.check_output(['pacman', '-Qu'])
except Exception as e:
    if e.returncode == 1:
        print 'up-to-date'  # no new packages
        exit()
    print 'Error!'
    exit(1)

count = 0
if out:
    for item in out.split('\n'):
        if item:
            count += 1

if count == 0:
    print 'up-to-date'
else:
    print count
