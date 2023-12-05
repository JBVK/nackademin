# Create folders and files
In your home folder, create the following folders using mkdir:

```bash
folder1
folder2
```
Navigate to folder1 using cd.

Check your current location with pwd. You should see:

```bash
/home/ec2-user/folder1
```

In folder1, create a subfolder named subfolder1 using mkdir.

Navigate to subfolder1 using cd. 

Confirm your location with pwd. You should see:

```bash
/home/ec2-user/folder1
```

Create a file named mystuff in subfolder1 using touch. 

Verify that the file is created with ls. You should see:

```bash
mystuff
```

Navigate back to the home folder using cd.

Attempt to navigate directly back to subfolder1 without stopping in folder1.

# Clean Up
Start by removing folder2 using rmdir.

Confirm the removal by listing everything in the home folder with ls.

Next, try to remove folder1. You might receive an error like 
```bash
rmdir: failed to remove 'folder1': Directory not empty. How do you resolve this?
```
