"""Delete a remote OpenVAS scanner.

Params:
    scanner_hostname
"""


def check_args(args):
    if len(args.script) - 1 != 1:
        message = """
        This script creates a remote OpenVAS scanner.
        1. <scanner_hostname>     -- Hostname of the scanner

        Example:
            $ gvm-script --gmp-username name --gmp-password pass tls --hostname <gsm> \
scripts/delete-scanner.gmp.py <scanner_hostname>
        """
        print(message)
        quit()


def get_scanners(gmp, _filter=None):
    """Gets scanners."""
    response = gmp.get_scanners(filter=_filter)

    return response.xpath('scanner')


def main(gmp, args):
    """Deletes the scanner with hostname passed in arguments."""
    # Read args
    check_args(args)

    scanner_host = args.argv[1]

    scanners = get_scanners(gmp, _filter=f'host={scanner_host}')

    if len(scanners) == 0:
        print(f'Scanner not found: {scanner_host}')
        return True

    response_xml = gmp.delete_scanner(scanner_id=scanners[0].get('id'))
    print(response_xml.get('status'), response_xml.get('status_text'))


if __name__ == '__gmp__':
    main(gmp, args)
