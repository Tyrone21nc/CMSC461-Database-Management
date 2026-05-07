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
menu = ["Home", "Second page", "Third page"]
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

if choice == "Home":
    st.write("Home page")
    conn = get_connection()

    conn.close()

