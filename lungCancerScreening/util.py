from ConfigParser import SafeConfigParser
import os

config = SafeConfigParser()
config_file = os.environ.get('LCS_CONFIG_FILE', 'config.ini')
config.read(config_file)

ADMIN_EMAIL = config.get('email', 'admin_email')
SUPPORT_EMAIL = config.get('email', 'support_email')
