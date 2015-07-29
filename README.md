#DevOps Tools

##Brief Description

Full continuous deployment pipeline using tools running all in docker containers. 

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

##Pipeline Description

The continuous deployment pipeline should be configured as follows, the developers work on their local environments and running their build, test and other processes within Docker containers. Once their code is ready and tested they will commit it to the central Git repo (Gitlab) and the new piece of code will continue its journey towards deployment. 

After this, the jenkins detect a new modifications on the git repo and build the application and run all configured tests and having success in it all then push to the docker-registry the new docker images related to the application deployed, finally deploy the application on the marathon, that is an Apache Mesos framework for long-running applications. It ensures that an app stays up even when machines or entire racks fail. 

With your application deployed on Marathon you can do acceptance test and scale the app with just using the Marathon interface. 

##Prerequisites:

Install the following tools:
- Git Client
- Docker [link](https://docs.docker.com/installation/)
- Docker-compose [link](https://docs.docker.com/compose/install/)

Advice: The docker-compose and docker should be installed under same user account. Can be necessary allow to running the docker without root account, to do this execute the following commands:

> $ sudo groupadd docker

> $ sudo gpasswd -a $ {USER} docker

> $ sudo service docker restart

> $ exit

##Download the solution

Download the solution and go to the directory, just executing the following commands:

> $ git clone https://github.com/dgmachado/devops-tools.git

> $ cd devops-tools

Just if you are using a CentOS you also need execute the following commands:

> $ cd volumes

> $ chcon -Rt svirt_sandbox_file_t *

Obs: Directories that you are mounting into the container need to have svirt_sandbox_file_t as their label.


##Quick Start

To lauch the full continuous deployment pipeline environment, just execute the following command:

> $ docker-compose up -d

This command will download the required images launching containers and will start these with this configuration in the docker-compose.yml file. You will see the following output:

> Creating devopstools_zookeeper_1...

> Creating devopstools_postgresql_1...

> Creating devopstools_redis_1...

> Creating devopstools_gitlab_1...

> Creating devopstools_mesosMaster_1...

> Creating devopstools_marathon_1...

> Creating devopstools_chronos_1...

> Creating devopstools_jenkins_1...

> Creating devopstools_mesosSlave1_1...

> Creating devopstools_mesosSlave2_1...

> Creating devopstools_mesosSlave3_1...

> Creating devopstools_registry_1...

> Creating devopstools_registryui_1...

You should algo verify the state of the services executing the following command:

> $ docker-compose ps

If any service haven't the up state you can verify the problem analyzing the logs just executing the following command:

> $ docker-compose logs

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

Beware with the tools configurations. Some of these tools are accessible without login and for production use they should be protected. It is advisable not to use existing accounts but rather create additional and secure accounts for production use.

##Configuration an new app on CD pipeline

For this example, we'll create a new project on the interface GitLab and place our code with Git client. The code we'll use is the one present in the deposit. It is a small Node application with a Hello World web page.


###Publishing the source code on Gitlab repository

To publishing the source code on Gitlab repositor following the next steps:

1. Create a new project on GitLab with the name "SampleApp"
2. Be placed in the folder sampleapp
3. Initialize the local repository
> $ git init

4. Connect the local repository and the remote 
> $ git remote add origin http://localhost:10080/root/SampleApp.git

5. Add all files to be commited
> $ git add .

6. Commit the content 
> $ git commit -m "Initial Commit"

7. Pushing the code on the remote repository 
> $ git push origin master

8. Access the gitlab url (http://localhost:10080) to verify your pushed source code


###Configurating the Jenkins

To configurating the jenkins build and deploy following the next steps:

1. Access the Jenkins and create a new job "SampleApp" Freestyle project type 
2. Configure the project with Git and the URL http://gitlab/root/SampleApp.git and enter the credentials with user and the password that we created earlier
3. In the Build Triggers section, check the periodic construction and specify the following settings:
> H/2 \* \* \* \*
>
> This will run a building for every two minutes

4. Add the following build steps of type 'Execute shell' to the build:

   - First Command - Script to build the app container  
   > ./continuous_deployment_scripts/build_appcontainer.sh ${BUILD_ID}

   - Second Command - Script to push the app container  
   > ./continuous_deployment_scripts/push_appcontainer.sh ${BUILD_ID}
   
   - Third Command - Script to deploy the app container  
   > ./continuous_deployment_scripts/deploy_appcontainer.sh ${BUILD_ID}

5. Save the configuration
6. Build manually the "SampleApp" project
7. After the build if all successfully finished we can see the application running on Marathon web page:
> localhost:8080

8. We can see our app on http://localhost:31000


###Using the CD envirement

To using the CD envirement following the next steps:

1. Edit the file sampleapp/nodejs_app/app.js and replace the text "Hello World\n" by the text "Hello World - New version\n";
2. Publish the new code
   
  > $ git add .

  > $ git commit -m "Nodejs app modified"

  > $ git push origin master

3. Wait for 2 minutes and access the page http://localhost:31000 and see the new modification
4. See the app running on the Marathon (http://localhost:8080)

##Final Words

My recommendation is that you use at least two distinct pipeline environments, one specific for development and acceptance tests and another to production, and you could too do even more and also separate the development and acceptance tests environment and would be great. 

The deploy of the development environment pipeline could push the new code on the git repo of the acceptance test and in the same way the acceptance test pipeline could push code to git repo of production pipeline finally could deploy the app in same cloud vendor. There are endless ways to customize these settings in order to achieve powerful environments and it depends only of you.

There are two main direction to improve this devops-tools system: adding more functionality and deepening the quality of the setup. The list of possible extensions is very long. Here are some examples:

- Manage code quality (SonarQube)
- Auto-scaling system (Jmeter)
- Package manager (NPM, NugetServer, Maven, ...)
- Project management platform (Taiga)
- Adding centralised logging
