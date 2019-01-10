#Requires -Version 5.0

param
(
    [Parameter()]
    [String[]] $TaskList = @("RestorePackages", "Build", "CopyArtifacts"),

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
        Throw "An error occured while building a project."
    }
}

Function CopyBuildArtifacts()
{
    param
    (
        [Parameter(Mandatory)]
        [String] $SourceFolder,
        [Parameter(Mandatory)]
        [String] $DestinationFolder
    )

    Write-Output "Copying build artifacts from '$SourceFolder' into '$DestinationFolder' folder..."
    if (Test-Path $DestinationFolder)
    {
       Remove-Item $DestinationFolder -Force -Recurse
    }
    New-Item -ItemType directory -Path $DestinationFolder
    Get-ChildItem -Path $SourceFolder -Recurse | Copy-Item -Destination $DestinationFolder
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
        $error.clear()
        CopyBuildArtifacts "src/PhpTravels.UITests/bin/Debug" "$BuildArtifactsFolder"
        if($error)
        {
            Throw "An error occured while copying build artifacts."
        }
    }
}