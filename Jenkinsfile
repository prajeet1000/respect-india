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
        stage ('maven Clean and Install'){
            steps {
                sh 'mvn clean install'
            }
        }
        stage("Docker Image-Build"){
            steps {
                echo "Building the image"
                sh "docker build -t my-test-image ."
            }
        }
        // stage('Push to Docker Hub') {
        //     steps {
                // echo "Pushing the image to docker hub"
                // withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                // sh "docker tag my-testing-image ${env.dockerHubUser}/my-testing-image:latest"
                // sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                // sh "docker push ${env.dockerHubUser}/my-testing-image:latest"}
        //     }
        // }
        stage('Docker-depoy') {
            steps {
                // echo "Deploying the container"
                script {
                    def sshCommand = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "/.sshkey/private-key/project01.pem" ubuntu@ec2-3-111-245-246.ap-south-1.compute.amazonaws.com"
                    withCredentials([usernamePassword(credentialsId:"dockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                    sh "${sshCommand} 'sudo docker build -t my-testing-image .'"
                    sh "${sshCommand} 'sudo docker tag my-testing-image ${env.dockerHubUser}/my-testing-image:latest'"
                    sh "${sshCommand} 'sudo docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}'"
                    sh "${sshCommand} 'sudo docker push ${env.dockerHubUser}/my-testing-image:latest'"
                    sh "${sshCommand} 'sudo docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}'"
                    sh "${sshCommand} 'sudo docker pull my-pipeline-image'"
                    sh "${sshCommand} 'sudo docker-compose down && docker-compose up -d'"}
                }
            }
        }
		
    }
}
