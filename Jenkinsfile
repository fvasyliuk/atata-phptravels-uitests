node('master') {
    stage("Checkout"){
        git 'https://github.com/fvasyliuk/atata-phptravels-uitests.git'
    }
    
    stage("Restore NuGet"){
        bat '"A:\\Dev\\nuget.exe" restore src/PhpTravels.UITests.sln'
    }
}