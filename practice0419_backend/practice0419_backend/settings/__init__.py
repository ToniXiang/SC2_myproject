# practice0419_backend/settings/__init__.py
import os
import pymysql

pymysql.install_as_MySQLdb()

env = os.getenv("DJANGO_ENV", "dev")
if env == "prod":
    from .prod import *
else:
    from .dev import *