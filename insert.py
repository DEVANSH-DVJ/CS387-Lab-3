import argparse
import csv
import os

import psycopg2 as pg
from psycopg2.extras import execute_values

tables = ['player', 'umpire', 'team', 'owner', 'venue', 'match',
          'player_match', 'umpire_match', 'ball_by_ball']


def ddl(cur, ddl_file):
    with open(ddl_file, 'r') as file:
        cur.execute(file.read())


def data(cur, data_folder):
    for table in tables:
        with open(os.path.join(data_folder, table + '.csv'), 'r') as file:
            reader = csv.reader(file)
            next(reader)

            values = []
            for row in reader:
                values.append(tuple([None if x == 'NULL' else x for x in row]))
            sql = 'INSERT INTO {} VALUES %s'.format(table)
            execute_values(cur, sql, values)


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

    ddl(cur, args.ddl)
    data(cur, args.data)
    conn.commit()

    cur.close()
    if (conn):
        conn.close()
