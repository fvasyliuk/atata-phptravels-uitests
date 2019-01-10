properties([
    parameters([
        string (name: 'branchName', defaultValue: 'master', description: 'Branch to get the tests from')
    ])
])

def isFailed = false
def buildArtifactsFolder = "C:/BuildPackagesFromPipeline/$BUILD_ID"
def branch = params.branchName
currentBuild.description = "Branch: $branch"

def RunNUnitTests(String pathToDll, String condition, String reportXmlName)
{
    try
    {
        bat "C:/Dev/NUnit.Console-3.9.0/nunit3-console.exe $pathToDll $condition --result=$reportXmlName"
    }
    finally
    {
        stash name: reportXmlName, includes: reportXmlName
    }
}

node('master')
{
    stage('Checkout')
    {
        git branch: branch, url: 'https://github.com/PixelScrounger/atata-phptravels-uitests.git'
        // checkout scm
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
                RunNUnitTests("$buildArtifactsFolder/PhpTravels.UITests.dll", "--where cat==FirstTest", "TestResult1.xml")
            }
        }, SecondTest: {
            node('Slave1')
            {
                RunNUnitTests("$buildArtifactsFolder/PhpTravels.UITests.dll", "--where cat==SecondTest", "TestResult2.xml")
            }
        }
    }
    isFailed = false
}

node('master')
{
    stage('Reporting')
    {
        dir('NUnitResults')     
        {
            unstash "TestResult1.xml"
            unstash "TestResult2.xml"

            archiveArtifacts '*.xml'
            nunit testResultsPattern: 'TestResult1.xml, TestResult2.xml'
        }
        
        if (!isFailed)
        {
            slackSend color: "good", message: "All tests passed.\nBranch: $branch\bBuild number: $env.BUILD_NUMBER"
        }
        else
        {
            slackSend color: "danger", message: "Tests failed.\nBranch: $branch\bBuild number: $env.BUILD_NUMBER"
        }
    }    
}