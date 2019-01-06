currentBuild.description = "Setting description from Jenkinsfile script"

node('master')
{
    stage('Checkout')
    {
        git 'https://github.com/PixelScrounger/atata-phptravels-uitests.git'
    }

    stage('Restore NuGet')
    {
        bat 'C:/Dev/nuget.exe restore src/PhpTravels.UITests.sln'
    }

    stage('Build Solution')
    {
        bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/msbuild.exe" src/PhpTravels.UITests.sln'
    }

    stage('Run Tests')
    {
        bat '"C:/Dev/NUnit.Console-3.9.0/nunit3-console.exe" src/PhpTravels.UITests/bin/Debug/PhpTravels.UITests.dll'
    }

    stage('Reporting')
    {
        //slackSend message: 'Buid'
    }

    stage('')
    {
        bat '(robocopy src/PhpTravels.UITests/bin/Debug C:/BuildPackagesFromPipeline/%BUILD_ID% /MIR /XO) ^& IF %ERRORLEVEL% LEQ 1 exit 0'
    }
}    
    