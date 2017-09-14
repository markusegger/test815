function CloneOrPull
{
    param([string]$gitRepo, [string]$branch, [string]$folderName)

    if (Test-Path $folderName\.git)
    {
        Push-Location $folderName
        & git pull
        Pop-Location
    }
    else
    {
        & git clone -q --branch=$branch $gitRepo $folderName
    }
}

$ErrorActionPreference = 'Stop'

$scriptPath = $MyInvocation.MyCommand.Path
$rootFolder = Split-Path $scriptPath | Split-Path
$src = "src"
md -Force $rootFolder\$src
Push-Location $rootFolder\$src

$config = Get-Content $rootFolder\repo.json -Raw | ConvertFrom-Json
Foreach($repo in $config.repo){
    CloneOrPull $($repo.url) $($repo.branch) $($repo.name)
    if ($repo.build_script)
    {
        Push-Location $($repo.name)
        Invoke-Expression $repo.build_script
        Pop-Location
    }
}

Pop-Location
