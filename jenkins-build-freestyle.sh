#/bin/sh

#1. check jenkins worker
#Manage Jenkins -> Manage nodes -> Advance -> # of executors -> 1

#2.build new item. Free-style

#3. git repo

#4. build script

# delete old files on jenkin server

export BUILD_NAME=question-app-build
export REMOTE_HOST=555498a35973ca6a260000d0@portal-mindelements.rhcloud.com

rm -rf $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/*

mkdir -p $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/

# go to maven build directory
cd $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/

git clone https://github.com/sunrise-projects/question-application.git

cd question-application

# build 
mvn clean install

# delete war file from remote repo
ssh -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $REMOTE_HOST 'rm -rf $OPENSHIFT_HOMEDIR/app-root/repo/diy/tomcat/webapps/*.war'

# copy war file from maven to remote repo
scp -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $OPENSHIFT_DATA_DIR/workspace/$BUILD_NAME/*/*/target/*.war $REMOTE_HOST:$OPENSHIFT_HOMEDIR/app-root/repo/diy/tomcat/webapps

# stop server
ssh -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $REMOTE_HOST '$OPENSHIFT_HOMEDIR/app-root/repo/.openshift/action_hooks/stop'

sleep 30

# sleep server
ssh -o StrictHostKeyChecking=no -i $OPENSHIFT_DATA_DIR\private.key $REMOTE_HOST '$OPENSHIFT_HOMEDIR/app-root/repo/.openshift/action_hooks/start'




