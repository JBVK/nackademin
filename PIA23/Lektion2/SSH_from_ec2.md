# Adding a SSH key to a Linux user on EC2
In this lab you will team up with another student. 
We will replicate many steps from the previous lab, AddSSHkeyToUser, but in this lab you will create the SSH key on your "other user" (not ec2-user) on your EC2 instance and SSH to your classmate EC2.

The lab is divided on steps the connecting student (student1) shall do and what the student owning the EC2 that will be connected to (student2) will do.

All steps in this lab will be done on EC2 instances. Not on your laptop.

## Notes about the lesson
You will see a lot of commands in this lesson, like sudo, su, chmod, that I will not describe in great details. These we will look at in upcoming lessons.

## Student 1

### SSH to the EC2
SSH to the EC2.

```bash
ssh ec2-user@EC2-external-ip -i your_ec2_pem_key
```

### Become the new user
To add the ssh key to your other Linux user we will need to become them.
This is done by running this command:

```bash
sudo su - username
```

You will see that your terminal changes from writing ec2-user@ip-address to username@ip-address at the beginning of the terminal line.

You can also verity that you are your new user by running the command:

```bash
whoami
```

It will print your username

### Create a SSH key
First we must create a SSH key to use. This should be done on the EC2 from where you will be connecting on your other user (not ec2-user).

To create the ssh-key you will run this command:

```bash
ssh-keygen
```

You will be prompted to specify in what file the key should be saved (specify filenamn and location).
It will default to your SSH folder (/home/username/.ssh) and filename id_rsa.

I would recommend creating all SSH-keys in your .ssh folder but give it a name so you easily can see what the key is for.
This will create the SSH key ec2_mynewuser in my .ssh folder (username is your username).

```bash
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/username/.ssh/id_rsa): /home/username/.ssh/ec2_mynewuser
```

You will be promted to add a passphrase (password). This will need to be entered every time you use the SSH-key.

As a best practice you should always add a passphrase to a SSH key that you will use for anything important. But since this is just a test server we can skip it.
Just press enter without enter a passphrase.


If you check your .ssh folder you will see that you have two new files.
```bash
ls .ssh/
authorized_keys  ec2_mynewuser  ec2_mynewuser.pub
```

The key with .pub is your public key and the one without is your private key.

We are now done with creating the SSH-key.

### Give the public key to your classmate
In this example my key is called ec2_mynewuser

Lets copy the public key. The easiest way to do this is to use a command called cat to print the file to the terminal.

```bash
cat .ssh/ec2_mynewuser.pub
```

The output will be somthing like this:
```bash
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRidALpfSR711pBhDhzlj2sF8hBmkvK92NNaISxAI
fwkUOSEOphVnofz80mnwRPM56rCX0hpRoahy4f3/U9reJzBjGsgs2LhCZv0f5Ss7MfwR4G/rIGfhyLp
Wi1h3ygl98uffroqOzpZFjHfDErQe0N4T3qCuwHCZ9XBC3XGGtrYWIe0xLiGYpbMz1SF54nHnDV5Aul
5t3cnEv68PZz0vu3Q3yEUrGiXWJXPNOJ22WKo/+kUFSpad0+aTk4+7DLQeiLXKHW4mG/EyobaMSyZ461
zSJIj1HuI+5XaIWWeTL7cuOFrakcM2S5cAZU2K/AMF54Z2ok37Ivs9yZxmok7PLnHqu7qfSpA7dhkYOc
MkZeirB8GNWI+1El3i8cuCVfZA0n11emiBxijd+s8SSKGC+awg0P9FTegI4PKUuBlGX983yVAOoiT8N/
HHqzHSz+8MSwNxYWzN25oIcdx9B4zfMpfvozCptHvEO87lv5qkcFI8CGM= ec2-user@jenkinsserver
```

Highlight everything from ssh-rsa to the end of the key, in my case ec2-user@jenkinsserver (this will be your username and computername), with your mouse and copy it (ctrl + c for Windows/Linux and CMD + c for Mac).

Send the output to your classmate (mail or on Discord).



## Student 2

### SSH to the EC2
SSH to the EC2.

```bash
ssh ec2-user@EC2-external-ip -i your_ec2_pem_key
```

### Become the new user
To add the ssh key to your other Linux user we will need to become them.
This is done by running this command:

```bash
sudo su - username
```

You will see that your terminal changes from writing ec2-user@ip-address to username@ip-address at the beginning of the terminal line.

You can also verity that you are your new user by running the command:

```bash
whoami
```

It will print your username

### SSH folder and authorized_keys
Creating a .ssh folder and authorized_keys file should already be done.




### Add the public key from student1 to authorized_keys
Get the public key from Student1. 

Start with writing echo "", in between the " " we will copy the SSH-key. We will then add >> after the key and after that write .ssh/authorized_keys. 
This will then echo everything between "" to .ssh/authorized_keys.

I will shorten my SSH-key to make it easier to read here.
```bash
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRidALpfSR7....CGM= ec2-user@jenkinsserver" >> .ssh/authorized_keys
```

To verify that it worked, lets check authorized_keys.
```bash
cat .ssh/authorized_keys
```
You should see your public key be printed to the terminal.


## Student 1


### SSH with the new key

You should now be able to ssh to student2 EC2 instace. Remember to use the username that Student2 has selected.

```bash
ssh student2newuser@EC2-external-ip -i .ssh/ec2_mynewuser
```
