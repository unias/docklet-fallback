#!/usr/bin/python


from pyftpdlib.authorizers import DummyAuthorizer, AuthenticationFailed
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer
import os, sys, pam

class PamAuthorizer(DummyAuthorizer):
    def validate_authentication(self, username, password, handler):
        msg = "Authentication failed."
        if username == 'root':
            if not self.ALLOW_ROOT:
                raise AuthenticationFailed(msg)
        elif not pam.authenticate(username, password):
                raise AuthenticationFailed(msg)
        homedir = '/mnt/global/users/%s/home' % username
        os.system('mkdir -p %s' % homedir)
        self.user_table[username] = {}
        self.user_table[username]['msg_login'] = 'Login successful.'
        self.user_table[username]['msg_quit'] = 'Goodbye.'
        self.user_table[username]['home'] = homedir
        self.user_table[username]['perm'] = 'elradfmwM'
        self.user_table[username]['operms'] = {}

def main():
    try:
        PamAuthorizer.ALLOW_ROOT = len(os.environ['NIS'])<=1
    except:
        PamAuthorizer.ALLOW_ROOT = True
    authorizer = PamAuthorizer()

    handler = FTPHandler
    handler.authorizer = authorizer

    handler.banner = "pyftpdlib based ftpd ready."

    address = ('', 21)
    server = FTPServer(address, handler)

    server.max_cons = 256
    server.max_cons_per_ip = 5

    server.serve_forever()

if __name__ == '__main__':
    main()

