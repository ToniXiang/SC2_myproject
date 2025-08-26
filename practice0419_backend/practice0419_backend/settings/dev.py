from .base import *
import os

DEBUG = True
ALLOWED_HOSTS = ['localhost', '127.0.0.1']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'test0419',
        'USER': 'root',
        'PASSWORD':  os.getenv('DB_PASSWORD', default='your_db_password'),
        'HOST':  'localhost',
        'PORT':  '3306',
        'OPTIONS': {
            'charset': 'utf8mb4',
        },
    }
}
