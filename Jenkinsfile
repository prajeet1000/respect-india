pipeline {
    agent any

    stages {
        stage('GitHub CheckOut') {
            steps {
                echo "Cloning the code"
                cleanWs()
                git url: "https://github.com/prajeet1000/respect-india.git", branch: "master"
            }
        }
        stage('SONARQUBE Code-Quality') {
            steps {
                withSonarQubeEnv('sonarqube server') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('MAVEN build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('DOCKER Build') {
            steps {
                echo "Building the image"
                sh 'docker build -t my-testing-app1 .'
            }
        }
        stage('IMAGE-Push to DOCKERHUB') {
            steps {
                echo "Pushing the image to docker hub"
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh "docker tag my-testing-app1 ${env.dockerHubUser}/my-testing-app1:latest"
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                    sh "docker push ${env.dockerHubUser}/my-testing-app1:latest"
                }
            }
        }
        stage("PRODUCTION SERVER Docker-image-Deploy") {
            steps {
                echo "Deploying the container"
                sshagent(['producation'])  {
                    withCredentials([usernamePassword(credentialsId: "dockerHub", passwordVariable: "dockerHubPass", usernameVariable: "dockerHubUser")]) {
                        script {
                            def sshKey = "/home/ubuntu/.ssh/id_rsa"
                            def remoteHost = "root@3.235.3.168"
                            
                            // Use the 'ssh' command to run remote commands non-interactively
                            sh '''
                            ssh -o stricthostkeychecking=no root@172.31.12.83 'sudo apt update'
                            ssh -o stricthostkeychecking=no root@172.31.12.83 'sudo docker kill \$(docker ps -q) && docker rm -f \$(docker ps -aq) && docker rmi -f \$(docker images -aq)'
                            ssh -o stricthostkeychecking=no root@172.31.12.83 'sudo docker pull prajeetkumar1000/my-testing-app1:latest'
                            ssh -o stricthostkeychecking=no root@172.31.12.83 'sudo docker run -it -d -p 80:80 --name prajeet-devops-duniya prajeetkumar1000/my-testing-app1 /bin/bash'
                            ssh -o stricthostkeychecking=no -T root@172.31.12.83 'sudo docker exec -i prajeet-devops-duniya /bin/bash -c "service apache2 restart"'
                            '''
                           }
                    }
                }
            }
        }
    }
}
