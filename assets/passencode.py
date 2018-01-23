#!/usr/bin/python3

import hashlib
import os
passwd = os.getenv("ALFRESCO_PASSWORD")
encrypted = hashlib.new('md4', passwd.encode('utf-16le')).hexdigest()
print(encrypted)


