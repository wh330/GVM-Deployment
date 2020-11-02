"""Create a remote OpenVAS scanner.

A CC credential called `remote-scanner` will be used to add the scanner or
it will be created in case it doesn't exist.

Params:
    scanner_name
    scanner_host
    certs_path
    port
"""


def check_args(args):
    if len(args.script) - 1 != 4:
        message = """
        This script creates a remote OpenVAS scanner.
        1. <scanner_name>     -- Name of the scanner
        2. <scanner_host>     -- DNS name or IP address of the scanner
        3. <certs_path>       -- Path of cert and key files. cacert.pem, cert.pem \
                                 and key.pem must exist in <certs_path>
        4. <port>             -- Port of the remote scanner

        Example:
            $ gvm-script --gmp-username name --gmp-password pass \
tls --hostname <gsm> scripts/create-scanner.gmp.py <scanner_name> <scanner_host> <certs_path> <port>
        """
        print(message)
        quit()


def get_credentials(gmp, _filter=None):
    """Gets credentials based on `_filter`."""
    response = gmp.get_credentials(filter=_filter)

    return response.xpath('credential')


def create_credential(gmp, name, certs_path):
    """Creates a CC credential."""
    with open(f'{certs_path}/cert.pem', 'r') as reader:
        cert = reader.read()

    with open(f'{certs_path}/key.pem', 'r') as reader:
        private_key = reader.read()

    credential_type = gmp.types.CredentialType.CLIENT_CERTIFICATE

    result = gmp.create_credential(
        name=name, credential_type=credential_type, certificate=cert, private_key=private_key)

    return result.get('status')


def get_scanners(gmp, _filter=None):
    """Gets scanners."""
    response = gmp.get_scanners(filter=_filter)

    return response.xpath('scanner')


def main(gmp, args):
    """Creates the scanner with attributes passed as args."""
    # Read args
    check_args(args)

    scanner_name = args.argv[1]
    scanner_host = args.argv[2]
    certs_path = args.argv[3]
    port = args.argv[4]

    scanners = get_scanners(gmp, _filter=f'host={scanner_host}')

    if len(scanners) == 1:
        print(f'Scanner already exists: {scanner_host}')
        return True

    credentials = get_credentials(gmp, _filter='name=remote-scanner')
    if len(credentials) == 0:
        # create credential 'remote-scanner'
        result = create_credential(gmp, 'remote-scanner', certs_path)
        if result != 201:
            print('Failed to create the CC credential.')
            return False

    with open(f'{certs_path}/cacert.pem', 'r') as reader:
        ca_pub = reader.read()

    scanner_type = gmp.types.ScannerType.OPENVAS_SCANNER_TYPE

    response_xml = gmp.create_scanner(
        name=scanner_name, host=scanner_host, port=port, scanner_type=scanner_type,
        credential_id=credentials[0].get('id'), ca_pub=ca_pub)

    print(response_xml.get('status'), response_xml.get('status_text'))


if __name__ == '__gmp__':
    main(gmp, args)
