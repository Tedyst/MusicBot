import os
import subprocess

try:
    VERSION = subprocess.check_output(
        ["git", "describe", "--tags", "--always"]).decode('ascii').strip()
except Exception:
    if os.environ.get('APP_ENV') == 'docker':
        if os.environ.get('VERSION'):
            VERSION = os.environ.get('VERSION')
        else:
            VERSION = 'version_unknown'
    else:
        VERSION = 'version_unknown'

AUDIO_CACHE_PATH = os.path.join(os.getcwd(), 'audio_cache')
DISCORD_MSG_CHAR_LIMIT = 2000
