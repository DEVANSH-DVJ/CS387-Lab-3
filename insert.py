import argparse

import psycopg2 as pg


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--name', type=str, required=True)
    parser.add_argument('--user', type=str, required=True)
    parser.add_argument('--pswd', type=str, required=True)
    parser.add_argument('--host', type=str, required=True)
    parser.add_argument('--port', type=str, required=True)
    parser.add_argument('--ddl', type=str, required=True)
    parser.add_argument('--data', type=str, required=True)
    args = parser.parse_args()

    conn = pg.connect(database=args.name, user=args.user,
                      password=args.pswd, host=args.host, port=args.port)
    cur = conn.cursor()

    cur.close()
    if (conn):
        conn.close()
