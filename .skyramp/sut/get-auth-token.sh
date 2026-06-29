#!/bin/bash
set -e

COMPOSE_FILE=".skyramp/sut/docker-compose.testbot.yml"
COMPOSE_OPTS="-f $COMPOSE_FILE --project-directory ."
USERNAME="testbot-admin"
PASSWORD="TestbotPass9876"

TOKEN=$(docker compose $COMPOSE_OPTS exec -T netbox python netbox/manage.py shell -c "
from django.contrib.auth import get_user_model
from users.models import Token
import sys

User = get_user_model()

# Create or get testbot superuser
user, created = User.objects.get_or_create(
    username='$USERNAME',
    defaults={
        'is_superuser': True,
        'email': 'testbot@skyramp.local',
    }
)
if created:
    user.set_password('$PASSWORD')
    user.save()
    print('Created superuser', file=sys.stderr)

# Seed minimal test data for list endpoints
try:
    from dcim.models import Site, Manufacturer
    from ipam.models import Prefix
    for slug, name in [('testbot-site-alpha', 'Testbot Site Alpha'), ('testbot-site-beta', 'Testbot Site Beta'), ('testbot-site-gamma', 'Testbot Site Gamma')]:
        Site.objects.get_or_create(slug=slug, defaults={'name': name})
    for slug, name in [('testbot-mfg-alpha', 'Testbot Manufacturer Alpha'), ('testbot-mfg-beta', 'Testbot Manufacturer Beta'), ('testbot-mfg-gamma', 'Testbot Manufacturer Gamma')]:
        Manufacturer.objects.get_or_create(slug=slug, defaults={'name': name})
    for prefix in ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16']:
        Prefix.objects.get_or_create(prefix=prefix)
    print('Seeded test data', file=sys.stderr)
except Exception as e:
    print(f'Seed warning: {e}', file=sys.stderr)

# Always create a fresh token to capture the plaintext (v2 tokens only expose plaintext at creation)
Token.objects.filter(user=user).delete()
token = Token(user=user)
token.save()

# Output in format: nbt_<key>.<plaintext>
# Authorization header will be: Bearer nbt_<key>.<plaintext>
print(f'nbt_{token.key}.{token.token}')
" 2>/dev/null | tr -d '\r' | tail -1)

echo "$TOKEN"
