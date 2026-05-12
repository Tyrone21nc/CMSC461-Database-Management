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
menu = ["Issue Permit", "Dashboard", "Simulate Sensor", "Tickets", "Add users to DB"]
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
# conn = ""

# Dashboard logic
if choice == "Dashboard":
    # st.write("The dashboard page")
    conn = get_connection()     # open the connection
    # st.subheader("Available Spots")
    # st.write("The number represents the number of free spots in that parking lot")

    # df = pd.read_sql("SELECT * FROM View_CurrentAvailability;", conn)    # create the dataframe, df
    # st.table(df) # then run the df on using the table function in streamlit
    st.subheader(":blue[All users]")
    st.write("All users in DB")
    df2 = pd.read_sql(f"{SELECT} * {FROM} {users__}", conn)
    st.table(df2)

    conn.close()                # close the connection when done
elif choice == "Issue Permit":
    st.subheader(":blue[Issueing permits]")
    st.write("Page for Issueing permits")
    conn = get_connection()
    df = pd.read_sql("SELECT * FROM permits;", conn)
    num_of_permits = pd.read_sql("SELECT Count(*) as total FROM permits;", conn)
    print(f"Show the number of permits: >>{num_of_permits}<<")
    st.table(df)
    st.write(f"There are currently {num_of_permits} permits")
    conn.close()
    # Allowing the admin to issue a permit
    #form info
    submit_btn = ""
    license_plate = ""
    exp_date = ""
    permit_type = ""
    with st.form("Issue a permit to a user"):
        license_plate = st.text_input("Enter the license plate number")
        exp_date = st.text_input("Enter the expiration date")
        permit_type = st.selectbox("Permit Type", ["", "Commuter", "Residential", "Faculty", "EXPIRED_TEST"])
        submit_btn = st.form_submit_button("submit permit")

    # retrieve all license plates
    conn = get_connection()
    cur = conn.cursor()
    df = pd.read_sql("SELECT * from vehicles;", conn)
    # put license plates in a list
    license_plates_list = []
    for license_plt in df["license_plate"]:
        license_plates_list.append(license_plt)
    # if button has been submitted
    if submit_btn:
        # st.write("button submitted yes!")
        # the license plate, LP, has to first be registered to a car and that car has to be registered to a user_id, which is corresponds to a user
        # if the license plate is already registered
        if license_plate in license_plates_list and permit_type:
            # I'm not going to make the check to see if LP already has a permit because the permit could have been expired and would need a new one. 
            insert_query = """
                INSERT INTO permits (license_plate, expiry_date, permit_type)
                VALUES (%s, %s, %s);
            """ # to insert we need an insert query
            permit_to_insert = (license_plate, exp_date, permit_type)
            st.success(f"Permit with license plate: {license_plate} has been successfully been added", icon="✅")
            cur.execute(insert_query, permit_to_insert)
            conn.commit()
        else:
            st.error("license plate doesn't exist or invalid permit type", icon="🚨")

    cur.close()
    conn.close()


elif choice == "Simulate Sensor":
    st.subheader(":blue[Simulate Vehicle Arrival]")
    st.write("Simulating Sensors")
    spot_id = st.number_input("Enter Spot ID", min_value=1)
    if st.button("Car Arrived"):
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO sensor_events (spot_id, entry_time) VALUES (%s, NOW())", (spot_id,))
        conn.commit()
        st.success(f"Sensor logged for Spot {spot_id}. Trigger updated DB!")
        conn.close()
    # show sensor_events table
    st.write("**:green[Reload page] to see the updated sensor_events table**")
    conn = get_connection()
    df = pd.read_sql("SELECT * FROM sensor_events;", conn)
    st.table(df)
    conn.close()


elif choice == "Tickets":
    st.subheader(":blue[Page for showing tickets]")
    conn = get_connection()
    df = pd.read_sql("SELECT * FROM tickets;", conn)
    st.write("All tickets and paid status")
    st.table(df)
    conn.close()
elif choice == "Add users to DB":
    st.subheader(":blue[To adding users to the database]")
    
    # form info
    submit_btn = ""
    with st.form("creating a user"):
        name = st.text_input("Enter name")
        email = st.text_input("Enter email")
        user_type = st.selectbox("User Type", ["Student", "Faculty", "Visitor", "Admin"])
        # since we're using a form, we have to use a submit button
        submit_btn = st.form_submit_button("submit user")   # this HAS to be indented

    if submit_btn:  # if we have submitted
        if name and email:  # if name name email are not empty
            conn = get_connection()
            if conn:
                # to display we only need get_connection()
                # to do an action, we need cursor and commit on that conection
                cur = conn.cursor()
                insert_query = """
                    INSERT INTO users (full_name, email, user_type)
                    VALUES (%s, %s, %s);
                """
                data_to_insert = (name, email, user_type)
                cur.execute(insert_query, data_to_insert)
                # We ALWAYS want to commit for insert, update, and delete (operations that change the data rather than just retrieve it)
                conn.commit()
                st.success(f"User {name} successfully added to the database!")
                cur.close()
                conn.close()
# Only commited on my computer






