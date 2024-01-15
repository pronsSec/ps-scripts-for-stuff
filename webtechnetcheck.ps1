# Requires RSAT-AD-PowerShell module or Active Directory module for Windows PowerShell
Import-Module ActiveDirectory

# Define general web server technology keywords
$webServiceKeywords = @(
    "IIS",       # For Microsoft IIS
    "Apache",    # For Apache HTTP Server
    "nginx",     # For Nginx
    "Tomcat",    # For Apache Tomcat
    "Node",      # For Node.js
    "Jetty",     # For Eclipse Jetty
    "gunicorn"   # For Gunicorn (Python)
    # Add more keywords as needed
)

# Get all computers from AD
$computers = Get-ADComputer -Filter *

# Function to check for web service using WMI
function Check-WebService {
    param (
        [string]$computerName,
        [string[]]$keywords
    )
    $services = Get-WmiObject -Class Win32_Service -ComputerName $computerName
    foreach ($keyword in $keywords) {
        $matchedServices = $services | Where-Object { $_.Name -like "*$keyword*" -and $_.State -eq "Running" }
        foreach ($service in $matchedServices) {
            Write-Output "$computerName has a web server: $($service.DisplayName)"
        }
    }
}

# Check each computer
foreach ($computer in $computers) {
    Check-WebService -computerName $computer.Name -keywords $webServiceKeywords
}

# End of script
