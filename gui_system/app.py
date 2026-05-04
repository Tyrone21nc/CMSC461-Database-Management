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
        host=host, database=database, user=user, password=password, port=port
    )


# The tile for the GUI page
st.title("UMBC Parking Database System")


# A sidebar (used for navigation)
menu = ["Dashboard", "Issue Permit", "Simulate Sensor", "Tickets"]
choice = st.sidebar.selectbox("Navigation", menu)


# Dashboard logic
if choice == "Dashboard":
    print("hello world")

