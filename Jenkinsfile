pipeline {
    agent any
    tools {
        maven "maven-3.9.9"
        jdk "OpenJdk17"
    }

    environment {
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
        SCANNER_HOME = tool("${SONARSCANNER}")
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
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=sonartoken \
                    -Dsonar.projectName=petclinic \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes/org/springframework/samples/petclinic \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
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
