from mysql.connector import connect, Error

try:
    with connect(
        host="localhost",
        port="3306",
        user="testing-user",
        password="testing-password",
        database="DevelopmentDB",
        # Employees is the database, Employee is the table
    ) as connection:
        print(connection)
        cursor = connection.cursor()
        cursor.execute('DESCRIBE Employees')
        table = cursor.fetchall()
        print(table)

        cursor.execute('SELECT * FROM Employees')
        second_table = cursor.fetchall()
        print(second_table)
except Error as e:
    print(e)
