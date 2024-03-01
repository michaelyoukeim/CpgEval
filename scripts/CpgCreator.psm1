
function New-Cpg {
    [CmdletBinding()]
    param (
        [string] $InputFilePath
    )

    # Check if the file is a JAR file
    if (-not $InputFilePath.EndsWith(".jar")) {
        return "File is not a jar"
    }

    # Generate the output CPG path
    $OutCpgPath = [IO.Path]::ChangeExtension($InputFilePath, "bin")

    # Check if CPG already exists
    if (Test-Path $OutCpgPath) {
        return "CPG already exists!"
    }

    # Backup current JAVA_HOME and set new one
    $initJavaHome = $env:JAVA_HOME
    $env:JAVA_HOME = "C:\Program Files\OpenJDK\jdk-20.0.1"

    # Create CPG
    joern-parse.bat --output $OutCpgPath $InputFilePath --language java

    # Restore JAVA_HOME
    $env:JAVA_HOME = $initJavaHome
}
