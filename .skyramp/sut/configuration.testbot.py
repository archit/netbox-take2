ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'netbox',
        'USER': 'netbox',
        'PASSWORD': 'netbox',
        'HOST': 'postgres',
        'PORT': '5432',
        'CONN_MAX_AGE': 0,
    }
}

REDIS = {
    'tasks': {
        'HOST': 'redis',
        'PORT': 6379,
        'USERNAME': '',
        'PASSWORD': '',
        'DATABASE': 0,
        'SSL': False,
    },
    'caching': {
        'HOST': 'redis',
        'PORT': 6379,
        'USERNAME': '',
        'PASSWORD': '',
        'DATABASE': 1,
        'SSL': False,
    }
}

SECRET_KEY = 'skyramp-testbot-secret-key-not-for-production-this-is-only-for-ci-testing-1234567890abcdef'

API_TOKEN_PEPPERS = {
    1: 'skyramp-testbot-pepper-not-for-production-this-is-only-for-ci-testing-1234567890abcdefghij',
}
