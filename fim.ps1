Function Calculate-File-Hash($filepath) {
    try {
        $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
        return $filehash
    } catch {
        Write-Host "Error calculating hash for file: $filepath" -ForegroundColor Red
        return $null
    }
}

Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\baseline.txt

    if ($baselineExists) {
        # Delete it
        Remove-Item -Path .\baseline.txt -ErrorAction SilentlyContinue
    }
}

# Prompt the user to enter the target folder path
$targetFolder = Read-Host -Prompt "Please enter the target folder path"

if (-Not (Test-Path -Path $targetFolder)) {
    Write-Host "The specified folder does not exist: $targetFolder" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    1) Collect new Baseline?"
Write-Host "    2) Begin monitoring files with saved Baseline?"
Write-Host ""
$response = Read-Host -Prompt "Please enter '1' or '2'"
Write-Host ""

if ($response -eq "1") {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    # Calculate Hash from the target files and store in baseline.txt
    # Collect all files in the target folder
    $files = Get-ChildItem -Path $targetFolder -Recurse -File

    # For each file, calculate the hash, and write to baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        if ($hash) {
            "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
        }
    }
    
} elseif ($response -eq "2") {
    
    $fileHashDictionary = @{}

    # Load file|hash from baseline.txt and store them in a dictionary
    try {
        $filePathsAndHashes = Get-Content -Path .\baseline.txt
        foreach ($f in $filePathsAndHashes) {
            $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
        }
    } catch {
        Write-Host "Error loading baseline.txt" -ForegroundColor Red
        exit
    }

    # Begin (continuously) monitoring files with saved Baseline
    while ($true) {
        Start-Sleep -Seconds 1
        
        $files = Get-ChildItem -Path $targetFolder -Recurse -File

        # For each file, calculate the hash and compare with the baseline
        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName
            if ($hash) {
                if ($fileHashDictionary.ContainsKey($hash.Path)) {
                    if ($fileHashDictionary[$hash.Path] -ne $hash.Hash) {
                        # File has been modified
                        Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                    }
                } else {
                    # New file has been created
                    Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
                }
            }
        }

        # Check for deleted files
        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                # One of the baseline files has been deleted
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
} else {
    Write-Host "Invalid option. Please enter '1' or '2'." -ForegroundColor Red
}
