pipeline {
    agent any
    tools {
        maven "maven-3.9.9"
        jdk "OpenJdk11"
    }

    environment {
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'

    }

    stages {
        stage('checkout') {
            steps {
                checkout changelog: false, poll: false, scm: scmGit(branches: [[name: '*/deployment']], extensions: [], userRemoteConfigs: [[credentialsId: 'github_login', url: 'https://github.com/custyblak/spring-petclinic.git']])
            }
        }
        stage('Build') {
            steps {
                echo 'Building'
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'mvn test'
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }
        stage('SonarQube analysis') {
            environment {
                SCANNER_HOME = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''$SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectName=petclinic \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/classes/ \
                    -Dsonar.exclusions=src/test/java/****/*.java \
                    -Dsonar.java.libraries=/var/lib/jenkins/.m2/**/*.jar \ '''
                }
            }
        }
        stage('SQuality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
