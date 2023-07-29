pipeline {
    agent any
	
	stages {
	    stage('GitHUB CheckOut') {
		    steps {
                echo "Cloning the code"
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
        stage("DOCKLER Build"){
            steps {
                echo "Building the image"
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
        stage("DOCKER image-Deploy"){
            steps {
                echo "Deploying the container"
                sh "docker-compose down && docker-compose up -d"
                
            }
        }
    }
}
