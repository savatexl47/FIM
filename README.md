# File Monitoring Script

## Description

This PowerShell script allows you to monitor changes in files within a specific folder. It uses SHA512 hashes to verify the integrity of the files and detect modifications, creations, and deletions of files.

## Features

- **Create Baseline**: Generates a `baseline.txt` file that contains the hashes of the files in the target folder.
- **Continuous Monitoring**: Compares the hashes of the files in real-time with those stored in `baseline.txt` to detect changes.
- **Notifications**: Informs the user about the creation, modification, and deletion of files.

## Requirements

- PowerShell 5.1 or later (pre-installed on Windows 10 and later).
- Read and write access to the target folder and the `baseline.txt` file.

## Usage

### Step 1: Clone the Repository

```sh
git clone https://github.com/your-username/file-monitoring-script.git
cd file-monitoring-script
```

### Step 2: Run the Script

Open PowerShell in the script directory.
Run the script with the following command:
```
powershell
.\fim.ps1
```

### Step 3: Specify the Target Folder

The script will prompt you to enter the path of the folder you want to monitor. For example:
```
powershell
Please enter the target folder path: C:\Users\User\Documents\TargetFolder
```

### Step 4: Choose an Option

The script will give you two options:

1) Collect new Baseline: Creates a new baseline.txt file with the hashes of the files in the target folder.
2) Begin monitoring files with saved Baseline: Starts monitoring the files using the existing baseline.txt file.

### Example Usage

**Create a New Baseline**
```
powershell
Please enter the target folder path: C:\Users\User\Documents\TargetFolder
```

### What would you like to do?
    1) Collect new Baseline?
    2) Begin monitoring files with saved Baseline?

Please enter '1' or '2': 1

### Monitor Files
```
powershell
Please enter the target folder path: C:\Users\User\Documents\TargetFolder
```

### What would you like to do?

    1) Collect new Baseline?
    2) Begin monitoring files with saved Baseline?

Please enter '1' or '2': 2

### Functions

**Calculate-File-Hash($filepath)**
Calculates the SHA512 hash of a given file.

**Erase-Baseline-If-Already-Exists()**
Deletes the baseline.txt file if it already exists.

### License

This project is licensed under the MIT License. 

### Contact
 If you have any questions or suggestions, feel free to contact me:

<!--Email: your.email@example.com
GitHub: @your-username-->
Thank you for using the File Monitoring Script!
