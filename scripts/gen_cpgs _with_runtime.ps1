# Import the module containing the Create-Cpg function
$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module "$scriptPath\CpgCreator.psm1"

# Get all jar files in the current directory
$jarFiles = Get-ChildItem -Path "$scriptPath\lib_jars" -Filter *.jar

# Initialize an array to hold the runtime for each file
$executionTimes = @()
# Initialize totalDuration to zero. It will hold the total runtime of the script.
$totalDuration = [timespan]::Zero

# Measure total script runtime
$totalScriptTime = Measure-Command {
    foreach ($jarFile in $jarFiles) {
        $filePath = $jarFile.FullName
        Write-Host "Creating CPG for: $filePath"

        # Measure the time taken by New-Cpg command
        $executionTime = Measure-Command {
            New-Cpg -InputFilePath $filePath
        }

        # Create a custom object to hold the file name and its execution time
        $executionTimes += @{
            FileName = $jarFile.Name
            Duration = "{0:hh\:mm\:ss\.fff}" -f $executionTime
        }
    }
}

# Add total script runtime to the object
$executionSummary = @{
    FileRuntimes = $executionTimes
    TotalScriptRuntime = "{0:hh\:mm\:ss\.fff}" -f $totalScriptTime
}

# Convert the execution summary to JSON and save it to a file
$executionSummary | ConvertTo-Json -Depth 3 | Out-File -FilePath "joern_runtime.json"

Write-Host "CPG creation report saved to joern_runtime.json"
