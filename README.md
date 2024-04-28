This Jenkinsfile defines the CI/CD pipeline for the Web Server Setup project. It automates the deployment of the Apache HTTP Server on the target VM (VM3) using the Ansible playbook, and sends email notifications in case of pipeline failures.


```markdown
# Jenkinsfile


## Pipeline Structure

```groovy
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
        body: "Pipeline failed due to: ${currentBuild.rawBuild.getLog(30)}\\n\\n Current build date: $date \\n\\n List of users in the webAdmins group:\\n $listusers"
    }
  }
}
```

## Pipeline Explanation

1. **Agent Selection**:
   - `agent any`: Specifies that the pipeline can run on any available Jenkins agent or node.

2. **Stages**:
   - `stage('Install and Configure Apache')`: Defines a stage for installing and configuring the Apache HTTP Server.
     - `steps`: Contains the steps to be executed in this stage.
       - `sh 'sudo ansible-playbook -i /ansible/inventory /ansible/WebServerSetup.yml'`: Runs the `ansible-playbook` command to execute the `WebServerSetup.yml` Ansible playbook, which installs and configures the Apache HTTP Server on the target VM.

3. **Environment Variables**:
   - `environment`: Defines environment variables for the pipeline.
     - `def date = ...`: Captures the current date and time using a Bash script.
     - `def listusers = ...`: Retrieves the list of users in the "webAdmins" group by executing a remote Bash script on the target VM.

4. **Post-Build Actions**:
   - `post`: Defines post-build actions for the pipeline.
     - `failure`: Specifies actions to be taken in case of pipeline failure.
       - `mail`: Sends an email notification with the following details:
         - `to`: The recipient email address.
         - `subject`: The email subject, including the current build display name.
         - `body`: The email body, containing:
           - The pipeline failure reason (using the last 30 lines of the build log).
           - The current build date (using the `date` environment variable).
           - The list of users in the "webAdmins" group (using the `listusers` environment variable).

This Jenkinsfile demonstrates how to automate the deployment of the Apache HTTP Server using an Ansible playbook and send email notifications in case of pipeline failures. The environment variables capture relevant information, such as the current date and the list of users in the "webAdmins" group, which are included in the email notification.



 Ansible playbook:

```markdown
# Apache HTTP Server Installation and Configuration

This Ansible playbook is designed to install and configure the Apache HTTP Server on the target hosts.

## Playbook Structure

```yaml
- name: Install and configure Apache HTTP Server
  hosts: all
  become: true

  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: present

    - name: Start Apache service
      service:
        name: httpd
        state: started
        enabled: yes
```

## Playbook Explanation

1. **Play Definition**:
   - `name: Install and configure Apache HTTP Server`: Descriptive name for the play.
   - `hosts: all`: Specifies that the play should be executed on all hosts in the inventory.
   - `become: true`: Enables privilege escalation to run tasks with administrative privileges.

2. **Tasks**:
   - **Install Apache**:
     - `name: Install Apache`: Descriptive name for the task.
     - `yum`: Module used for package management on RHEL-based systems.
       - `name: httpd`: Specifies the name of the package to be installed (Apache HTTP Server).
       - `state: present`: Ensures that the package is installed on the target hosts.

   - **Start Apache service**:
     - `name: Start Apache service`: Descriptive name for the task.
     - `service`: Module used for managing services on Linux systems.
       - `name: httpd`: Specifies the name of the service to be managed (Apache HTTP Server).
       - `state: started`: Ensures that the Apache HTTP Server service is started.
       - `enabled: yes`: Ensures that the Apache HTTP Server service is enabled to start automatically on system boot.

## Usage

1. Make sure you have Ansible installed on your control machine.
2. Update the `hosts` inventory file with the IP addresses or hostnames of the target machines where you want to install and configure Apache HTTP Server.
3. Run the playbook using the following command:

```
ansible-playbook apache-playbook.yml
```

This playbook will install the Apache HTTP Server package on the target hosts and start the service. It will also ensure that the Apache HTTP Server service is enabled to start automatically on system boot.

