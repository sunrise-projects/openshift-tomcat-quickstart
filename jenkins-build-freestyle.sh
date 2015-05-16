#/bin/sh

#add this 2 plugin on jenkins
#https://wiki.jenkins-ci.org/display/JENKINS/GitHub+API+Plugin
#https://wiki.jenkins-ci.org/display/JENKINS/Github+Plugin


#1. check jenkins worker
#Manage Jenkins -> Manage nodes -> Advance -> # of executors -> 1

#2.build new item. Free-style

#3. git repo

#4. build script

# delete old files on jenkin server

export BUILD_NAME=question-app-build
export REMOTE_HOST=555498a35973ca6a260000d0@portal-mindelements.rhcloud.com
export REMOTE_OPENSHIFT_HOMEDIR=/var/lib/openshift/555498a35973ca6a260000d0/
rm -rf $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/*

mkdir -p $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/

# go to maven build directory
cd $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/

git clone https://github.com/sunrise-projects/question-application.git

cd question-application

#fix env variables
sed -ig s/portal-librequestion.rhcloud.com/portal-mindelements.rhcloud.com/ question-rest/src/main/webapp/apidocs/index.html
sed -ig s/localhost:8080/portal-mindelements.rhcloud.com/ question-rest/src/main/webapp/apidocs/index.html

sed -ig s/portal-librequestion.rhcloud.com/portal-mindelements.rhcloud.com/ question-rest/src/main/resources/swagger.properties
sed -ig s/localhost:8080/portal-mindelements.rhcloud.com/ question-rest/src/main/resources/swagger.properties

sed -ig s/portal-librequestion.rhcloud.com/portal-mindelements.rhcloud.com/ question-web/src/main/java/com/question/web/services/QuestionService.java
sed -ig s/localhost:8080/portal-mindelements.rhcloud.com/ question-web/src/main/java/com/question/web/services/QuestionService.java


# build 
mvn clean install

# delete war file from remote repo
ssh -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $REMOTE_HOST 'rm -rf $REMOTE_OPENSHIFT_HOMEDIR/app-root/repo/diy/tomcat/webapps/*.war'

# copy war file from maven to remote repo
scp -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/*/*/target/*.war $REMOTE_HOST:$REMOTE_OPENSHIFT_HOMEDIR/app-root/repo/diy/tomcat/webapps

# stop server
ssh -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $REMOTE_HOST $REMOTE_OPENSHIFT_HOMEDIR/app-root/runtime/repo/.openshift/action_hooks/stop

sleep 30

# sleep server
ssh -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $REMOTE_HOST $REMOTE_OPENSHIFT_HOMEDIR/app-root/runtime/repo/.openshift/action_hooks/start



