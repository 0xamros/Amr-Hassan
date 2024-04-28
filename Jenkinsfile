pipeline {
    agent any

    stages {
        stage('Install and Configure Apache') {
            steps {
                // Add steps to execute Ansible playbook for Apache setup
                sh 'sudo ansible-playbook -i /ansible/inventory /ansible/WebServerSetup.yml'
            }
        }
    }
    
    environment {
        def date = sh(script: "echo `date +%Y/%m/%d:::%H:%M:%S`", returnStdout: true).trim()
        def listusers = sh(script: "sudo ssh 192.168.75.149 '/opt/GroupMembers.sh'", returnStdout: true).trim()
    }

    post {
        failure {

            // Send email notification on pipeline failure
                mail to: "amrhassan55555@gmail.com",
                subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                body: "Pipeline failed due to: ${currentBuild.rawBuild.getLog(30)}\n\n Current build date:  $date \n\n List of users in the webAdmins group:\n $listusers"
                }
                   
        }
}
