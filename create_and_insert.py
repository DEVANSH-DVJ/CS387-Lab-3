import psycopg2 as pg

conn = pg.connect(database='Lab3B', user='postgres',
                  password='secret', host='localhost', port='5432')
cur = conn.cursor()

with open('PS/DDL_ipl.sql', 'r') as file:
    cur.execute(file.read())
with open('PS/sampleData_ipl.sql', 'r') as file:
    cur.execute(file.read())

conn.commit()

cur.close()
if (conn):
    conn.close()
