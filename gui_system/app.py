import streamlit as st
import psycopg2             # we use this to connect to our docker environment DB
import pandas as pd


# Database info
# this information is found in docker-compose.yml in the services section
host = "localhost"
database = "parking_system"
user = "admin"
password = "password123"
port = "5432"


# We first need to connect to the DB
def get_connection():
    return psycopg2.connect(
        host="localhost", database="parking_system", user="admin", password="password123", port="5432"
    )


# The tile for the GUI page
st.title("UMBC Parking Database System")


# A sidebar (used for navigation)
menu = ["Dashboard", "Issue Permit", "Simulate Sensor", "Tickets"]
choice = st.sidebar.selectbox("Navigation", menu)


# Dashboard logic
if choice == "Dashboard":
    st.write("The dashboard page")
    st.write("You selected:", choice)
    st.subheader("Current Lot Availability")
    conn = get_connection()     # open the connection
    st.write("Before the more things")
    df = pd.read_sql("SELECT * FROM View_CurrentAvailability", conn)    # create the dataframe, df
    st.table(df) # then run the df on using the table function in streamlit
    st.write("More things")
    conn.close()                # close the connection when done
elif choice == "Issue Permit":
    st.write("Page for Issueing permits")
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
else:
    st.write("This is the wrong page, enter the correct navigation section name")

