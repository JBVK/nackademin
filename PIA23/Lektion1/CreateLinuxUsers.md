# Create user on EC2
This guide will show you how to create a user on your EC2 (linux).


## Log in
Log in to the EC2 with the ec2-user account.


## Create user

Decide on a username for the new user, in the examples I have selected the username to be mynewuser so change that to the username you selected. 
Then create it with this command.

```bash
sudo adduser mynewuser
```

You will not recieve any confirmation if it worked, but you will if it failed. So if you didnt get any feedback you are all good.
But if you want to doublecheck if it worked you can check if the new user has gotten a new home folder.

```bash
ls /home
```

In the output you should see the username of your user. That is the homefolder of that user.

## Create password for user

We need to give the new user a password. 
To do so run this command.

<span style="color:red">DO NOT FORGET TO ADD THE USERNAME TO THE COMMAND. OTHERWISE YOU WILL CHANGE THE ROOT ACCOUNTS PASSWORD</span>

```bash
sudo passwd mynewuser
```
You will be promted to write the new password and retype it. If all went well you will get this response.
```bash
passwd: all authentication tokens updated successfully.
```

## Changing password on your current user
The previous command is for changing another users password. To change your own users password you can do that by just running
```bash
passwd 
```
You will be promted to write your current password and then a new one.
