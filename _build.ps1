#Requires -Version 5.0

$NugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$NugetExe = Join-Path $PSScriptRoot "nuget.exe"
$MSBuildExe = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
$Solution = "src/PhpTravels.UITests.sln"

Write-Verbose "Script Root is: $PSScriptRoot"

Write-Verbose "Checking for NuGet in tools path..."
if (-Not (Test-Path $NugetExe -Verbose:$VerbosePreference)) 
{
    Write-Output "Installing NuGet from $NugetUrl..."
    Invoke-WebRequest $NugetUrl -OutFile $NugetExe -Verbose:$VerbosePreference -ErrorAction Stop
}

Write-Verbose "Restoring NuGet packages..."
& $NugetExe restore $Solution
if ($LastExitCode -ne 0) 
{
    Throw "An error occured while restoring NuGet packages."
}

Write-Verbose "Building a project..."
& $MSBuildExe $Solution
if ($LastExitCode -ne 0) 
{
    Throw "An error occured while restoring building a project."
}