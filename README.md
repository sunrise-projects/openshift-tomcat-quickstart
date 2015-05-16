Run your Tomcat on OpenShift
============================
This git repository helps you get up and running quickly with a Tomcat 7.0.42 installation on OpenShift.

Create a Do It Yourself (DIY) app on OpenShift
----------------------------------------------
<a href="https://www.openshift.com/">Create an account</a> and install the <a href="https://www.openshift.com/get-started">command-line client tools</a>.

Create a DIY application:
    rhc app create tomcat diy-0.1

Get Tomcat running
----------------------------
Grab this quickstart project and make it work for you!

    cd tomcat
    git remote add upstream -m master git://github.com/openshift-quickstart/openshift-tomcat-quickstart.git
    git pull -s recursive -X theirs upstream master
    git push

That's it, you can now checkout your tomcat at:
    http://tomcat-$yournamespace.rhcloud.com

By placing WARs (either WAR archives or exploded WARs) in the diy/tomcat/webapps folder,
those applications will be deployed and redeployed upon each <code>git push</code>.  Likewise,
applications (including the sample applications provided by Tomcat) can be deleted from that
folder so they will no longer be deployed.

The default managing account is tomcat/openshift; this can be changed by altering the 
diy/tomcat/conf/tomcat-users.xml file, committing the change within your secure OpenShift
Git account and issuing another <code>git push</code>.

Forking this Quickstart to use a newer Tomcat version
-----------------------------------------------------
See [here](HowToUpdate.md) for information.

License
-------
This code is dedicated to the public domain to the maximum extent
permitted by applicable law, pursuant to CC0
http://creativecommons.org/publicdomain/zero/1.0/

Quick DIY Installation
---------
1. Generate Public and Private Key

```
$ ssh-keygen -b 2048
Generating public/private rsa key pair.
Enter file in which to save the key (/usr/home/user/.ssh/id_rsa): 
Created directory '/usr/home/user/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /usr/home/user/.ssh/id_rsa.
Your public key has been saved in /usr/home/user/.ssh/id_rsa.pub.
```

2. Upload your public key to openshift dashboard

3. Issue the following command on your host:

```
cd $OPENSHIFT_DATA_DIR && wget https://raw.githubusercontent.com/sunrise-projects/openshift-tomcat-quickstart/master/install-diy.sh && sh install-diy.sh && rm -rf install-diy.sh
```
