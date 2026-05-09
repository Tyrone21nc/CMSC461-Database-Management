import streamlit as st
import psycopg2             # we use this to connect to our docker environment DB
import pandas as pd


# Database info
# this information is found in docker-compose.yml in the services section
host = "127.0.0.1"
database = "parking_system"
user = "admin"
password = "password123"
port = "5433"


# We first need to connect to the DB
def get_connection():
    try:
        conn = psycopg2.connect(
            host=host, database=database, user=user, password=password, port=port
        )
        return conn
    except Exception as e:
        st.error(f"Database Connection Failed: {e}")
        return None


# The tile for the GUI page
st.title("UMBC Parking Database System")


# A sidebar (used for navigation)
menu = ["Dashboard", "Issue Permit", "Simulate Sensor", "Tickets", "Add students to DB"]
choice = st.sidebar.selectbox("Navigation", menu)

# Query key characters
SELECT = "SELECT"
FROM = "FROM"
users__ = "users"
vehicles__ = "vehicles"
lots__ = "lots"
spots__ = "spots"
reservations__ = "reservations"
payments__ = "payments"
tickets__ = "tickets"
permits__ = "permits"

# variables for if statements
conn = ""

# Dashboard logic
if choice == "Dashboard":
    # st.write("The dashboard page")
    conn = get_connection()     # open the connection
    st.subheader("Available Spots")
    st.write("The number represents the number of free spots in that parking lot")

    df2 = pd.read_sql("SELECT * FROM users", conn)
    st.table(df2)



    df = pd.read_sql("SELECT * FROM View_CurrentAvailability;", conn)    # create the dataframe, df
    st.table(df) # then run the df on using the table function in streamlit
    st.subheader("All users")
    st.write("All users in DB")
    df2 = pd.read_sql(f"{SELECT} * {FROM} {users__}", conn)
    st.table(df2)

    count1 = pd.read_sql(f"{SELECT} COUNT(*) as total {FROM} {users__} WHERE user_type='Student';", conn)
    st.subheader(f"STUDENTS: {count1}")
    df3 = pd.read_sql(f"{SELECT} * {FROM} {users__} WHERE user_type='Student';", conn)
    st.table(df3)
    df4 = pd.read_sql(f"{SELECT} * {FROM} {users__} WHERE user_type='Faculty';", conn)
    st.table(df4)
    df5 = pd.read_sql(f"{SELECT} * {FROM} {users__} WHERE user_type='Visitor';", conn)
    st.table(df5)
    df6 = pd.read_sql(f"{SELECT} * {FROM} {users__} WHERE user_type='Admin';", conn)
    st.table(df6)


    conn.close()                # close the connection when done
elif choice == "Issue Permit":
    st.write("Page for Issueing permits")
    conn = get_connection()
    df = pd.read_sql("SELECT * FROM permits;", conn)
    num_of_permits = pd.read_sql("SELECT Count(*) as total FROM permits;", conn)
    print(f"Show the number of permits: >>{num_of_permits}<<")
    st.table(df)
    st.write(f"There are currently {num_of_permits} permits")
    conn.close()


elif choice == "Simulate Sensor":
    st.write("Simulating Sensors")
    st.subheader("Simulate Vehicle Arrival")
    spot_id = st.number_input("Enter Spot ID", min_value=1)
    if st.button("Car Arrived"):
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO sensor_events (spot_id, entry_time) VALUES (%s, NOW())", (spot_id,))
        conn.commit()
        st.success(f"Sensor logged for Spot {spot_id}. Trigger updated DB!")
        conn.close()
elif choice == "Tickets":
    st.write("Page for showing tickets")
elif choice == "Add students to DB":
    st.subheader("To adding students to the database")
    
    # form info
    submit_btn = ""
    with st.form("creating a user"):
        name = st.text_input("Enter name")
        email = st.text_input("Enter email")
        user_type = st.selectbox("User Type", ["Student", "Faculty", "Visitor", "Admin"])
        # since we're using a form, we have to use a submit button
        submit_btn = st.form_submit_button("submit user")   # this HAS to be indented
    if submit_btn:  # when we click submit, the program gets here
        # convert data from form into a dataframe, df
        # if name and email and user_type:
            user = { # make into a dictionary
                "full name": [name],
                "email": [email],
                "user_type": [user_type]
            }
            df = pd.DataFrame(user)  # convert to df
            st.success(f"{user_type} created!!")    # success msg
            st.write("Sup")
            conn = get_connection()  # open a connection to the DB
            st.write("Hey")
            show_user_table = pd.read_sql("SELECT * FROM users", conn)
            st.table(show_user_table)
            conn.close()    # close connection

