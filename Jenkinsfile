properties([
	parameters([
		string(name: 'branchName', defaultValue: 'master', description: 'Branch to get the tests from')
	])
])

def isFailed = false
def branch = params.branchName
def $buildArtifactsFolder = "A:/BuildPackagesFromPipeline/$BUILD_ID"
currentBuild.description = "Branch: $branch "
node('master') {
    stage("Checkout"){
        git branch: branch, url: 'https://github.com/fvasyliuk/atata-phptravels-uitests.git'
    }
    
    stage("Restore NuGet"){
        bat '"A:/Dev/nuget.exe" restore src/PhpTravels.UITests.sln'
    }
	stage('Build Solution'){
		bat '"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/MSBuild/15.0/Bin/MSBuild.exe" src/PhpTravels.UITests.sln'
	}
	stage('Copy Artifacts'){
		bat "(robocopy src/PhpTravels.UITests/bin/Debug $buildArtifactsFolder /MIR /XO ^& IF %ERRORLEVEL% LEQ 1 exit 0"
	}
	
}

catchError
	{
		isFailed = true
		stage('Run Test'){
		parallel FirstTest: {
			node('master'){
				bat "A:/Dev/NUnit.Console-3.9.0/nunit3-console.exe $buildArtifactsFolder/PhpTravels.UITests.dll --where cat==FirstTest"
			}
		}, SecondTest:{
			node('Slave'){
				bat "A:/Dev/NUnit.Console-3.9.0/nunit3-console.exe $buildArtifactsFolder/PhpTravels.UITests.dll --where cat==SecondTest" 
			}
		}
		}
		isFailed = false
	}