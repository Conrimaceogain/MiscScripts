Import-Module C:\GIT\MiscScripts\Powershell\Functions.psm1 -Force
$CurrentCount = (Get-ChildItem ~\Dropbox\Wallpapers).count
Send-Windows10Notification -NotificationTitle "Python Reddit Image Scrape Starting" -NotificationText "There are currently $((Get-ChildItem ~\Dropbox\Wallpapers).count) backgrounds."


python .\redditdl.py  kygan/m/imaginarywallpapers ~\Dropbox\Wallpapers --multireddit --sfw --skipAlbums --score 100 --sort tophoir --num 10 -update | Out-File "C:\TEMP\RedditImgLog-$([DateTime]::Now.ToShortTimeString())"
Get-ChildItem ~\Dropbox\Wallpapers | sort Length | % {
    if ($_.Length -lt 1000) {
        $CleanupCount++
        rm $_.FullName
    }
}
$NewCount = (Get-ChildItem ~\Dropbox\Wallpapers).count
$DCount = $NewCount - $CurrentCount

Send-Windows10Notification -NotificationTitle "Python Reddit Image Scrape Completed" -NotificationText "There are now $NewCount backgrounds.`nAdded $DCount`nCleaned Up $CleanupCount"
