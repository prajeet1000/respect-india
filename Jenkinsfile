pipeline {
    agent any
	stages {
	    stage('Github CheckOut') {
		    steps {
			   checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/prajeet1000/respect-india.git']]])
			}
		}
        stage('SonarQube Code Quality') {
            steps {
                    withSonarQubeEnv('sonarqube server') {
                sh 'mvn sonar:sonar'
                }
            }
        }
        stage ('Clean and Install'){
            steps {
                sh 'mvn clean install'
            }
        }
        stage("Docker Image-Build"){
            steps {
                echo "Building the image"
                // sh "docker build -t my-pipeline ."
            }
        }
        stage('Push to Docker Hub') {
            steps {
                echo "Pushing the image to docker hub"
                // withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                // sh "docker tag my-pipeline ${env.dockerHubUser}/my-pipeline:latest"
                // sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                // sh "docker push ${env.dockerHubUser}/my-pipeline:latest"}
            }
        }
        stage('Docker-depoy') {
            steps {
                echo "Deploying the container"
                // sh "docker-compose down && docker-compose up -d"
            }
        }
		
    }
}
