properties([
    parameters([
        string (name: 'branchName', defaultValue: 'master', description: 'Branch to get the tests from')
    ])
])

def isFailed = false
def branch = params.branchName
currentBuild.description = "Branch: $branch"

node
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

    stage('Copy Build Artifacts')
    {
        bat '(robocopy src/PhpTravels.UITests/bin/Debug C:/BuildPackagesFromPipeline/%BUILD_ID% /MIR /XO) ^& IF %ERRORLEVEL% LEQ 1 exit 0'
    }
}

catchError
{
    isFailed = true
    stage('Tests')
    {
        parallel FirstTest: {
            node('master')
            {
                bat '"C:/Dev/NUnit.Console-3.9.0/nunit3-console.exe" C:/BuildPackagesFromPipeline/%BUILD_ID%/PhpTravels.UITests.dll --where "cat==FirstTest"'
            }
        }, SecondTest: {
            node('Slave1')
            {
                bat '"C:/Dev/NUnit.Console-3.9.0/nunit3-console.exe" C:/BuildPackagesFromPipeline/%BUILD_ID%/PhpTravels.UITests.dll --where "cat==SecondTest"'
            }
        }
    }
    isFailed = false
}

node
{
    stage('Reporting')
    {
        archiveArtifacts 'TestResults.xml'
        nunit testResultsPattern: 'TestResults.xml'

        /*
        if (!isFailed)
        {
            slackSend color: "good", message: "All tests passed.\nBranch: $branch\bBuild number: $env.BUILD_NUMBER"
        }
        else
        {
            slackSend color: "danger", message: "Tests failed.\nBranch: $branch\bBuild number: $env.BUILD_NUMBER"
        }*/
    }    
}