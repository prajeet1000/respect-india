pipeline {
    agent any
	
	stages {
	    stage('GitHUB CheckOut') {
		    steps {
                echo "Cloning the code"
                cleanWs()
                git url:"https://github.com/prajeet1000/respect-india.git", branch: "master"
            }
        }
		stage ('SONARQUBE Code-Quality'){
            steps {
                    withSonarQubeEnv('sonarqube server') {
                sh 'mvn sonar:sonar'}
            }
        }
        stage('MAVEN build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage("DOCKER Build"){
            steps {
                echo "Building the image"
                //sh "docker kill \$(docker ps -q) && docker rm -f \$(docker ps -aq) && docker rmi -f \$(docker images -aq)"
                sh "docker build -t my-testing-app ."
            }
        }
        stage("IMAGE-Push to DOCKERHUB"){
            steps {
                echo "Pushing the image to docker hub"
                withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                sh "docker tag my-testing-app ${env.dockerHubUser}/my-testing-app:latest"
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                sh "docker push ${env.dockerHubUser}/my-testing-app:latest"}
            }
        }
        stage("PRODUCATION SERVER Docker-image-Deploy"){
            steps {
                echo "Deploying the container"
                sshagent(['ssh-agent']) {
                     withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                    sh "sudo ssh -i /root/.ssh/id_rsa ubuntu@ec2-13.127.139.239.ap-south-1.compute.amazonaws.com 'sudo apt update'"
                    sh "sudo ssh -i /root/.ssh/id_rsa ubuntu@ec2-13.127.139.239.ap-south-1.compute.amazonaws.com 'sudo docker kill \$(docker ps -q) && docker rm -f \$(docker ps -aq) && docker rmi -f \$(docker images -aq)'"
                    sh "sudo ssh -i /root/.ssh/id_rsa ubuntu@ec2-13.127.139.239.ap-south-1.compute.amazonaws.com 'sudo docker pull prajeetkumar1000/my-testing-app:latest'"
                    sh "sudo ssh -i /root/.ssh/id_rsa ubuntu@ec2-13.127.139.239.ap-south-1.compute.amazonaws.com 'sudo docker run -td -p 80:80 --name prajeet-devops-duniya prajeetkumar1000/my-testing-app'"
                    sh "sudo ssh -i /root/.ssh/id_rsa ubuntu@ec2-13.127.139.239.ap-south-1.compute.amazonaws.com \"sudo docker exec -i prajeet-devops-duniya /bin/bash -c 'service apache2 restart'\""}
                }
            }
        }
	
    }
}

