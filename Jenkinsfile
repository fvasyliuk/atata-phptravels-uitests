properties([
    parameters([
        string (name: 'branchName', defaultValue: 'master', description: 'Branch to get the tests from')
    ])
])

def failedBuildStatus = "FAILURE"
def succeededBuildStatus = "SUCCEESS"
def branch = params.branchName
currentBuild.description = "Branch: $branch"

node('master')
{
    stage('Checkout')
    {
        git branch: branch, url: 'https://github.com/PixelScrounger/atata-phptravels-uitests.git'
    }

    stage('Restore NuGet')
    {
        bat 'C:/Dev/nuget.exe restore src/PhpTravels.UITests.sln'
    }

    stage('Build Solution')
    {
        bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/msbuild.exe" src/PhpTravels.UITests.sln'
    }

    catchError
    {
        currentBuild.result = failedBuildStatus
        stage('Run Tests')
        {
            bat '"C:/Dev/NUnit.Console-3.9.0/nunit3-console.exe" src/PhpTravels.UITests/bin/Debug/PhpTravels.UITests.dll'
        }
        currentBuild.result = succeededBuildStatus
    }

    stage('Reporting')
    {
        if (currentBuild.result == succeededBuildStatus)
        {
            slackSend color: "good", message: "All tests passed.\nBranch: $branch\bBuild number: $env.BUILD_NUMBER"
        }
        else
        {
            slackSend color: "danger", message: "Tests failed.\nBranch: $branch\bBuild number: $env.BUILD_NUMBER"
        }
    }
    
    stage('Copy Build Artifacts')
    {
        if(currentBuild.result == succeededBuildStatus)
        {
            bat '(robocopy src/PhpTravels.UITests/bin/Debug C:/BuildPackagesFromPipeline/%BUILD_ID% /MIR /XO) ^& IF %ERRORLEVEL% LEQ 1 exit 0'
        }
    }
}    
    