def isFailed = false

node('master') {
    stage('Checkout')
    {
        git 'https://github.com/PixelScrounger/atata-phptravels-uitests.git'
    }
    
    stage('Restore NuGet')
    {
        bat '"C:/Dev/nuget.exe" restore src/PhpTravels.UITests.sln'
    }

    stage('Build Solution')
    {
        bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/MSBuild.exe" src/PhpTravels.UITests.sln'
    }
    
    catchError
    {
        isFailed = true
        stage('Run Tests')
        {
            bat '"C:/Dev/NUnit.Console-3.9.0/nunit3-console.exe" src/PhpTravels.UITests/bin/Debug/PhpTravels.UITests.dll'
        }
        isFailed = false
    }

    stage('Reporting')
    {
        if(isFailed)
        {
            slackSend color: 'danger', message: 'Tests failed.'
        }
        else
        {
            slackSend color: 'good', message: 'Tests passed.'
        }
    }
}