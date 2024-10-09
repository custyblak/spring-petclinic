pipeline {
    agent any
    tools {
        maven "maven_3.9.9"
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
        stage('Build && Test') {
            steps {
                echo 'Building && Testing..'
                sh 'mvn build' && 'mvn test'
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
                withSonarQubeEnv(credentialsId: 'sonartoken', installationName: 'sonarserver') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectName=petclinic \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/classes/ \
                    -Dsonar.exclusions=src/test/java/****/*.java \
                    -Dsonar.java.libraries=/var/lib/jenkins/.m2/**/*.jar \
                    -Dsonar.projectVersion=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}'''
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