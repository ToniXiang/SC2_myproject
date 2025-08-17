from .base import *
import os

DEBUG = True
ALLOWED_HOSTS = ['localhost', '127.0.0.1']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'test0419',
        'USER': os.getenv('DB_USER', default='root'),
        'PASSWORD':  os.getenv('DB_PASSWORD', default='your_db_password'),
        'HOST':  os.getenv('DB_HOST', default='localhost'),
        'PORT':  os.getenv('DB_PORT', default='3306'),
        'OPTIONS': {
            'charset': 'utf8mb4',
        },
    }
}
