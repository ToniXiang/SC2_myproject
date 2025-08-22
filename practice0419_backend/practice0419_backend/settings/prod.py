from .base import *

DEBUG = False
ALLOWED_HOSTS = ['https://sc2-myproject.onrender.com']

STATIC_ROOT = BASE_DIR / "staticfiles"

MIDDLEWARE += ['whitenoise.middleware.WhiteNoiseMiddleware']
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / "db.sqlite3",
    }
}

