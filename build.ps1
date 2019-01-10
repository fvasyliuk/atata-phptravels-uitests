param(
    [Parameter(Mandatory)]
    [String[]] $TaskList,

    [ValidateSet('Release', 'Debug')]
    [String] $Configuration,
    
    # Other project configuration related params

    [Parameter()]
    [String] $BuildArtifactsFolder
)

$NugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$NugetExe = Join-Path $PSScriptRoot "nuget.exe"
$MSBuildExe = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
$Solution = "src\PhpTravels.UITests.sln"

Function DownloadNuGet()
{
    if (-Not (Test-Path $NugetExe)) 
    {
        Write-Output "Installing NuGet from $NugetUrl..."
        Invoke-WebRequest $NugetUrl -OutFile $NugetExe -ErrorAction Stop
    }
}

Function RestoreNuGetPackages()
{
    DownloadNuGet
    Write-Output 'Restoring NuGet packages...'
    & $NugetExe restore $Solution

    if ($LastExitCode -ne 0) 
    {
        Throw "An error occured while restoring NuGet packages."
    }
}

Function BuildSolution()
{
    Write-Output "Building '$Solution' solution..."
    & $MSBuildExe $Solution
    if ($LastExitCode -ne 0) 
    {
        Throw "An error occured while restoring building a project."
    }
}

Function CopyBuildArtifacts()
{
    Write-Output "Copying build artifacts into '$BuildArtifactsFolder' folder..."
}

Function RunTests()
{
    Write-Output 'Running tests...'
}

foreach ($Task in $TaskList) {
    if ($Task.ToLower() -eq 'restorepackages')
    {
        RestoreNuGetPackages
    }
    if ($Task.ToLower() -eq 'build')
    {
        BuildSolution
    }
    if ($Task.ToLower() -eq 'copyartifacts')
    {
        CopyBuildArtifacts
    }
    if ($Task.ToLower() -eq 'runtests')
    {
        RunTests
    }
}