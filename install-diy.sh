#/bin/sh

#login using putty/ssh

#stop the ruby default server
sh $OPENSHIFT_REPO_DIR/.openshift/action_hooks/stop

#move ruby diy repo to backuup 
mv $OPENSHIFT_HOMEDIR/app-root/runtime/repo $OPENSHIFT_HOMEDIR/app-root/runtime/repo.ruby.bak 

# create tempory folder at data folder
mkdir $OPENSHIFT_DATA_DIR/tmp
cd $OPENSHIFT_DATA_DIR/tmp
git clone https://github.com/sunrise-projects/openshift-tomcat-quickstart.git
mv $OPENSHIFT_DATA_DIR/tmp/openshift-tomcat-quickstart $OPENSHIFT_DATA_DIR/tmp/repo
mv $OPENSHIFT_DATA_DIR/tmp/repo $OPENSHIFT_HOMEDIR/app-root/runtime/
cd ..
rm -rf tmp

#deploy tomcat from repo to data directory
sh $OPENSHIFT_REPO_DIR/.openshift/action_hooks/deploy

# start the server
sh $OPENSHIFT_REPO_DIR/.openshift/action_hooks/start

# test stop/start
sh $OPENSHIFT_REPO_DIR/.openshift/action_hooks/stop
sh $OPENSHIFT_REPO_DIR/.openshift/action_hooks/start

echo $OPENSHIFT_APP_DNS

