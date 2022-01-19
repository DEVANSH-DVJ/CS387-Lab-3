import argparse
import csv

import psycopg2 as pg

files = ['player.csv',
         'umpire.csv',
         'team.csv',
         'owner.csv',
         'venue.csv',
         'match.csv',
         'player_match.csv',
         'umpire_match.csv',
         'ball_by_ball.csv']


def ddl(cur, ddl_file):
    with open(ddl_file, 'r') as file:
        crt = file.read()

    try:
        cur.execute(crt)
    except Exception as error:
        print(error)


def data(cur, data_folder):
    for file_name in files:
        with open(data_folder + file_name, 'r') as file:
            reader = csv.reader(file)
            next(reader)

            for row in reader:
                try:
                    cur.execute('INSERT INTO {} VALUES {}'.format(
                        file_name.split('.')[0],
                        str(tuple(row))))
                except Exception as error:
                    print(error)


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