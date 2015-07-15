#DevOps Tools

##Brief Description

Full continuous deployment pipeline using tools running in docker containers. 

Each tool runs in a separeted docker container and to manages the orchestration and deployment of the docker images 
and containers we use Docker Compose.

Docker Compose is a tool for defining and running multi-container applications with Docker. With Compose, 
you define a multi-container application in a single file, then spin your application up in a single command which does
everything that needs to be done to get it running.

Within the continuous deployment environment we use the following tools:

- Gitlab - Similar to GitHub but open source
- Jenkins
- Docker
- Docker-compose
- Docker-registry - Similar to docker hub but open source
- Docker-registry-ui
- Mesos
- Mesosphere Marathon
- Zookeeper for internal use of Mesos and Marathon

##Prerequisites:

Install the following tools:
- Docker [link](https://docs.docker.com/)
- Docker-compose [link](https://docs.docker.com/compose/)

##Quick Start

To lauches the full continuous deployment pipeline environment, just the following command:

> docker-compose up

This command will download the required images launching containers and will start these with this configuration in the docker-compose.yml file.


##Access

See the following tools that can be accessed:

- Jenkins -> http://IP_ADDRESS:8081
- GitLab -> http://IP_ADDRESS:10080
- Registry-UI -> http://IP_ADDRESS:9090
- Marathon -> http://IP_ADDRESS:8080
- Mesos -> http://IP_ADDRESS:5050
- Chronos -> http://IP_ADDRESS:4400


If the services are deployed locally, it is possible to replace IP_ADDRESS by localhost

An account already exists in GitLab, change the password as requested after the first connection:

>username: root 

>password: 5iveL!fe

Beware with the tools configurations. Some of these tools are accessible without login and for production use they should be protected. It is advisable not to use already accounts but rather to create additional and secure accounts for production use.


##Configuration an new app on CD pipeline

For this example, we'll create a new project on the interface GitLab and place our code with Git client. The code we'll use is the one present in the deposit. It is a small Node application with a Hello World web page.


###Publishing the source code on Gitlab repository

To publishing the source code on Gitlab repositor following the next steps:

1. Create a new user on Gitlab
2. Create a new project on GitLab with the name "Sample Project"
2. Be placed in the folder sampleapp
3. Initialize the local repository
> git init

4. Connect the local repository and the remote 
> git remote add origin http://localhost:10080/root/sampleapp.git

5. Add all files to be commited
> git add .

6. Commit the content 
> git commit -m "Initial Commit"

7. Pushing the code on the remote repository 
> git push origin master

8. Enter the user account created on GitLab 




###Configurating the Jenkins

To configurating the jenkins build and deploy following the next steps:

1. Access the Jenkins and create a new project "SampleApp" Freestyle project type 
2. Configure the project with Git and the URL http://gitlab/root/sampleapp.git and enter the credentials with user and the password that we created earlier
3. In the Build Triggers section, check the periodic construction and specify the following settings:
> H/2 \* \* \* \*
>
> This will run a building for every two minutes

4. Add to the Jenkins configuration the script to build the app container  
> continuous_deployment_scripts/build_appcontainer.sh

5. Add to the Jenkins configuration the script to push the app container  
> continuous_deployment_scripts/push_appcontainer.sh

6. Add to the Jenkins configuration the script to deploy the app container  
>continuous_deployment_scripts/deploy_appcontainer.sh

7. Save Configuration
8. Build manually the "SampleApp" project
9. After the build if all successfully finished we can see the application running on Marathon web page:
> localhost:8080

10. We can see our app on http://localhost:31000


###Using the CD envirement

To using the CD envirement following the next steps:

1. Edit the file sampleapp/nodejs_app/app.js and replace the text "Hello World\n" by the text "Hello World - New version\n";
2. Publish the new code
> git add .
>
> git commit -m "Nodejs app modified"
>
>git push origin master
3. Wait for 2 minutes and access the page http://localhost:31000
4. See the app running on the Marathon (http://localhost:8080)
