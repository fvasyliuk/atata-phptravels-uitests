node
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
}    
    