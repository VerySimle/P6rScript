
# Composite - File and LDAP-based Users/Groups

## Deployment

To deploy Nifi 1.20 / ApacheDS
## 1. Stage
1.1 Sign in root
``` bash
sudo su
```
1.2 Add user nifi and create password
``` bash 
echo -e '<password>\n<password>\n' | adduser nifi
```
1.3 install java-11
``` bash
apt install openjdk-11-jre-headless -y
```
1.4 Add path in ~/.bashrc
``` bash
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >> /home/nifi/.bashrc; source /home/nifi/.bashrc
```
1.5 Download Nifi, unzip, rename, move to /opt folder and assign nifi user rights
``` bash
wget https://archive.apache.org/dist/nifi/1.20.0/nifi-1.20.0-bin.zip; unzip nifi-1.20.0-bin.zip; mv nifi-1.20.0 nifi; mv nifi/ /opt/; cd /opt/; chown -R nifi:nifi nifi/
```
1.6 Create service nifi.service
``` bash
echo -e "[Unit]\nDescription=Apache NiFi\nAfter=network.target\n\n[Service]\nType=forking\nUser=nifi\nGroup=nifi\nExecStart=/opt/nifi/bin/nifi.sh start\nExecStop=/opt/nifi/bin/nifi.sh stop\nExecRestart=/opt/nifi/bin/nifi.sh restart\nEnvironment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\n\n[Install]\nWantedBy=multi-user.target" >> /etc/systemd/system/nifi.service
```
1.7 Reload,start,View log 
``` bash
systemctl daemon-reload; systemctl start nifi; tail -f nifi/logs/nifi-app.log; systemctl stop nifi
```
1.8 Minimal configuration
``` bash
sudo -u nifi nano nifi/conf/nifi.properties
nifi.remote.input.secure=false
nifi.web.http.host=<ip>
nifi.web.http.port=<port>
```
1.9 Add user nifi
``` bash
sudo -u nifi nifi/bin/nifi.sh set-single-user-credentials Admin Admin123456789
```
1.10 Step 
``` bash
systemctl enable nifi
```
1.11 Step 
``` bash
reboot
```
1.12 Test
``` 
https://<ip>:<port>/nifi/
Admin Admin123456789
```

## 2. Stage
2.1 Sign in root and stop Nifi
``` bash
sudo su
systemctl stop nifi
```
2.2 Install ApacheDS
``` bash
apt install apacheds
```
2.3 Download to your local computer Apache Directory Studio and Connect to server LDAP 

Apache Directory Studio - https://directory.apache.org/

Connect server (login:password - uid=admin,ou=system:secret)

2.4 Right click on the connection name > Open Configuration > Partititions > Add
## Partitition General Details
![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)

2.5 Restart ApacheDS
``` bash
systemctl restart apacheds
```
2.6 Connect server (login:password - uid=admin,ou=system:secret) and import LDIF 

Example (test.ldif)
```
dn: ou=people,dc=nifi,dc=com
objectclass: organizationalUnit
objectClass: extensibleObject
objectclass: top
ou: people

dn: ou=groups,dc=nifi,dc=com
objectclass: organizationalUnit
objectClass: extensibleObject
objectclass: top
ou: groups

dn: cn=users,ou=groups,dc=nifi,dc=com
objectClass: groupOfUniqueNames
objectClass: top
cn: users
uniqueMember: cn=user,ou=people,dc=nifi,dc=com

dn: cn=admins,ou=groups,dc=nifi,dc=com
objectClass: groupOfUniqueNames
objectClass: top
cn: admins
uniqueMember: cn=TestAdminOne,ou=people,dc=nifi,dc=com
uniqueMember: cn=TestAdminTwo,ou=people,dc=nifi,dc=com

dn: cn=test,ou=people,dc=nifi,dc=com
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
cn: user
description: A user
sn: user
uid: user
mail: user@nifi.com
userpassword: user

dn: cn=TestAdminOne,ou=people,dc=nifi,dc=com
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
cn: TestAdminOne
description: A TestAdminOne user
sn: TestAdminOne
uid: TestAdminOne
mail: TestAdminOne@nifi.com
userpassword: TestAdminOne

dn: cn=TestAdminTwo,ou=people,dc=nifi,dc=com
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: top
cn: TestAdminTwo
description: A TestAdminTwo user
sn: TestAdminTwo
uid: TestAdminTwo
mail: TestAdminTwo@nifi.com
userpassword: TestAdminTwo
```

## 3. Stage

3.1 Delete users.xml,authorizations.xml
``` bash
sudo rm /opt/nifi/conf/users.xml /opt/nifi/conf/authorizations.xml
```
3.2 Correct configuration (nifi.properties,login-identity-providers.xml,authorizers.xml)

### nifi.properties
``` bash
nifi.login.identity.provider.configuration.file=./conf/login-identity-providers.xml
nifi.security.user.authorizer=managed-authorizer
nifi.security.user.login.identity.provider=ldap-provider
```
### login-identity-providers.xml
``` bash
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<loginIdentityProviders>
    <provider>
        <identifier>ldap-provider</identifier>
        <class>org.apache.nifi.ldap.LdapProvider</class>
        <property name="Authentication Strategy">SIMPLE</property>

        <property name="Manager DN">uid=admin,ou=system</property>
        <property name="Manager Password">secret</property>

        <property name="TLS - Keystore"></property>
        <property name="TLS - Keystore Password"></property>
        <property name="TLS - Keystore Type"></property>
        <property name="TLS - Truststore"></property>
        <property name="TLS - Truststore Password"></property>
        <property name="TLS - Truststore Type"></property>
        <property name="TLS - Client Auth"></property>
        <property name="TLS - Protocol"></property>
        <property name="TLS - Shutdown Gracefully"></property>

        <property name="Referral Strategy">FOLLOW</property>
        <property name="Connect Timeout">10 secs</property>
        <property name="Read Timeout">10 secs</property>

        <property name="Url">ldap://<ip>:<port></property>
        <property name="User Search Base">ou=people,dc=nifi,dc=com</property>
        <property name="User Search Filter">(uid={0})</property>

        <property name="Identity Strategy">USE_USERNAME</property>
        <property name="Authentication Expiration">12 hours</property>
    </provider>
</loginIdentityProviders>
```
### authorizers.xml
``` bash
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<authorizers>
    <userGroupProvider>
        <identifier>file-user-group-provider</identifier>
        <class>org.apache.nifi.authorization.FileUserGroupProvider</class>
        <property name="Users File">./conf/users.xml</property>
        <property name="Legacy Authorized Users File"></property>
        <property name="Initial User Identity 1"></property>
    </userGroupProvider>
    <userGroupProvider>
        <identifier>ldap-user-group-provider</identifier>
        <class>org.apache.nifi.ldap.tenants.LdapUserGroupProvider</class>
        <property name="Authentication Strategy">SIMPLE</property>

        <property name="Manager DN">uid=admin,ou=system</property>
        <property name="Manager Password">secret</property>

        <property name="TLS - Keystore"></property>
        <property name="TLS - Keystore Password"></property>
        <property name="TLS - Keystore Type"></property>
        <property name="TLS - Truststore"></property>
        <property name="TLS - Truststore Password"></property>
        <property name="TLS - Truststore Type"></property>
        <property name="TLS - Client Auth"></property>
        <property name="TLS - Protocol"></property>
        <property name="TLS - Shutdown Gracefully"></property>

        <property name="Referral Strategy">FOLLOW</property>
        <property name="Connect Timeout">10 secs</property>
        <property name="Read Timeout">10 secs</property>

        <property name="Url">ldap://<ip>:<port></property>
        <property name="Page Size"></property>
        <property name="Sync Interval">1 mins</property>
        <property name="Group Membership - Enforce Case Sensitivity">false</property>

        <property name="User Search Base">ou=people,dc=nifi,dc=com</property>
        <property name="User Object Class">person</property>
        <property name="User Search Scope">ONE_LEVEL</property>
        <property name="User Search Filter"></property>
        <property name="User Identity Attribute">cn</property>
        <property name="User Group Name Attribute"></property>
        <property name="User Group Name Attribute - Referenced Group Attribute"></property>

        <property name="Group Search Base">ou=groups,dc=nifi,dc=com</property>
        <property name="Group Object Class">groupOfUniqueNames</property>
        <property name="Group Search Scope">ONE_LEVEL</property>
        <property name="Group Search Filter"></property>
        <property name="Group Name Attribute">cn</property>
        <property name="Group Member Attribute">uniqueMember</property>
        <property name="Group Member Attribute - Referenced User Attribute"></property>
    </userGroupProvider>

    <accessPolicyProvider>
        <identifier>file-access-policy-provider</identifier>
        <class>org.apache.nifi.authorization.FileAccessPolicyProvider</class>
        <property name="User Group Provider">ldap-user-group-provider</property>
        <property name="Authorizations File">./conf/authorizations.xml</property>
        <property name="Initial Admin Identity">TestAdminOne</property>
        <property name="Legacy Authorized Users File"></property>
        <property name="Node Identity 1"></property>
        <property name="Node Group"></property>
    </accessPolicyProvider>

    <authorizer>
        <identifier>managed-authorizer</identifier>
        <class>org.apache.nifi.authorization.StandardManagedAuthorizer</class>
        <property name="Access Policy Provider">file-access-policy-provider</property>
    </authorizer>
</authorizers>
```

3.3 Test
``` 
https://<ip>:<port>/nifi/
TestAdminOne TestAdminOne
```
