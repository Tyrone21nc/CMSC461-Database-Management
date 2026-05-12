# Setting up the docker and postgress database
1. Open up a terminal on VSCode or your prefered IDE, which should be udner your project folder.
2. The docker compose includes the credentials for the project, if you want to change the usernames,
    passwords, container names, we can do that.
3. Make sure you've navigated to the correct directory in the terminal and then run the command: 
    docker-compose stop. This creates the neccessary containers for the project
4. Then to connect and create a server for the database:{#web-browser-setup}
    - Open your prefered browser and type this in the url: http://localhost:8080
    - Log in with the credentials in the pgAdmin section
    - Click "Add New Server":
        - enter "UMBC Parking System" for name
        - move the connection tab and enter "db" for Host name/address 
        - enter "5432" for port
        - enter "postgres" for maintenance database
        - enter "admin" for username which is the value of POSTGRES_USER in the .yml file
        - enter "password123" for password which is the value of POSTGRES_PASSWORD in the .yml file
        - BEFORE you press save, make sure your docker is up and running, saving your password is up to you
5. To Stop docker, you can type the command run "docker-compose down" in the terminal.


### To run the docker
1. In your bash linux system, navigate into the folder where you can see all these files (createDDL.sql, docker-compose.yml, ...transaction.sql)
2. Then run this command <code>docker-compose up -d</code>, which will then start up the docker environment, that way you can connect to it via the web browser using the credentials in docker-compose.yml
3. After running the command above, go to your web browser follow [these directions] (in step 4 above)(#web-browser-setup)
4. Open up a query tool in the browser and run the code in these files in order:
    1. smoke_test.sql
    2. loadAll.sql
    3. queryAll.sql
    4. indexAll.sql
    5. transaction.sql


### Demo Video (which you can also find in the readme under the gui_system directory)
[Screen recording 2026-05-09 8.08.43 PM.webm](https://github.com/user-attachments/assets/23eacbf1-8759-4350-93f2-6ab95dfb91ba)

**This is the demo video of the gui version**<br>
Small change

