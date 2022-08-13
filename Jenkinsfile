pipeline {
    agent any
    stages {
        stage('Build') {
            steps{
                script{
                    properties([
                        parameters
                            ([
                                    choice(choices: ['nonprod', 'prod'],
                                    description: 'Used to set the environment',
                                    name: 'EnvironmentName')
                            ])
                        ])
                    }
            }
        }
 
        stage('Upload in s3'){
            steps{
                withEnv(["ENV_NAME=${params.EnvironmentName}"]){
                    sh "make create-stack"
                }
            }
        }
    }
}
