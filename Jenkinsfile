pipeline {
    agent any
    stages {
        stage('Env setup') {
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
 
        stage('create cf stack'){
            steps{
                withEnv(["ENV_NAME=${params.EnvironmentName}"]){
                    sh "make create-stack"
                }
            }
        }
    }
}
}
