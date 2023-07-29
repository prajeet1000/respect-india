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
	stage ("Docker Pull Dastardly from Burp Suite container image") {
            steps {
                sh 'docker pull public.ecr.aws/portswigger/dastardly:latest'
            }
        }
        stage ("Docker run Dastardly from Burp Suite Scan") {
            steps {
                cleanWs()
                sh '''
                    docker run --user $(id -u) -v ${WORKSPACE}:${WORKSPACE}:rw \
                    -e DASTARDLY_TARGET_URL=https://ginandjuice.shop/ \
                    -e DASTARDLY_OUTPUT_FILE=${WORKSPACE}/dastardly-report.xml \
                    public.ecr.aws/portswigger/dastardly:latest
                '''
            }
        }
    }
    post {
        always {
            junit testResults: 'dastardly-report.xml', skipPublishingChecks: true
        }
    }
    }
}
