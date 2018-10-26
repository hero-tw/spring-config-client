# k8s-sonar
This project runs a configuration server using AWS parameter store as a backend

##Build
- ./gradlew clean
- ./gradlew bootJar 

##Jenkins
-- Requires security scan against a sonar server
-- echo $(kubectl get svc/svc-sonarqube | grep svc-sonarqube | awk -F" " '{print $4}'):9000/sonar returns sonar url
-- login to url from above as admin/admin and create a token
-- Replace the sonar.login.url and sonar.login variables in Jenkinsfile with the new values from above
 
## Outstanding Items
- Sonar token and url should be provided from an external configuration store