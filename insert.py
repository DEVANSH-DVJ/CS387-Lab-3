import psycopg2 as pg

with open('lab3.ddl', 'r') as file:
    crt = file.read()

conn = pg.connect(database='Lab3', user='postgres',
                  password='secret', host='localhost', port='5432')
cur = conn.cursor()

try:
    cur.execute(crt)
except Exception as error:
    print(error)
cur.close()

if (conn):
    conn.commit()
    conn.close()
