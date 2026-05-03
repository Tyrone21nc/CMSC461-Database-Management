# Setting up the docker and postgress database
1. Open up a terminal on VSCode or your prefered IDE, which should be udner your project folder.
2. The docker compose includes the credentials for the project, if you want to change the usernames,
    passwords, container names, we can do that.
3. Make sure you've navigated to the correct directory in the terminal and then run the command: 
    docker-compose stop. This creates the neccessary containers for the project
4. Then to connect and create a server for the database:
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
