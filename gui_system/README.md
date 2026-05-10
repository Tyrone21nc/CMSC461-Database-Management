# Database GUI implementation
**This readme will include a background of the folder it pertains to**
## Tech Stack
1. Python as the backend
2. Streamlit framework to easily display and interact with databse, DB
3. Since my database is in my Docker itself, I must connect my GUI to it as well
4. I also use psycopg2 to connect to the DB
5. I also use pandas to convert the code returned from psycopg2 to better formatted code, **dataframe**, which works well with streamlit


## Running the GUI app
1. The app can be run on localhost on your browser
2. After navigating to the correct folder, type these commands in the terminal
    - <code>pip install streamlit psycopg2-binary pandas</code> -> this will install the appropriate libraries if it's not already installed
    - <code>streamlit run app.py</code> -> this will run the app on your terminal
        - If it doesn't work and you get an error like, <code>streamlit: command not found</code>, then try this instead
        - <code>python -m streamlit run app.py</code>
3. Then you can interact with the web browser on your localhost on your browser

## Demo Video
[Screen recording 2026-05-09 8.08.43 PM.webm](https://github.com/user-attachments/assets/23eacbf1-8759-4350-93f2-6ab95dfb91ba)






