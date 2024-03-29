param (
    [Parameter(Mandatory = $true)]
    [string]$filename
)

# powershell tip:
# ls IMG* | % { .\fix-img-date.ps1 $_ }

if (Test-Path -Path $filename -PathType Leaf) {
    $basename = (Get-Item $filename).Basename
    if ($basename -match '^IMG_([0-9]{4})([0-9]{2})([0-9]{2})_([0-9]{2})([0-9]{2})([0-9]{2})') {
        $year = $Matches.1
        $month = $Matches.2
        $day = $Matches.3
        $hour = $Matches.4
        $minute = $Matches.5
        $second = $Matches.6
        $date = "${year}:${month}:${day} ${hour}:${minute}:${second}"
        exiftool -overwrite_original_in_place -AllDates="$date" $filename
    } elseif ($basename -match '^IMG-([0-9]{4})([0-9]{2})([0-9]{2})-') {
        $year = $Matches.1
        $month = $Matches.2
        $day = $Matches.3
        $date = "${year}:${month}:${day} 00:00:00"
        exiftool -overwrite_original_in_place -AllDates="$date" $filename
    } elseif ($basename -match '^([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2})([0-9]{2})([0-9]{2})') {
        $year = $Matches.1
        $month = $Matches.2
        $day = $Matches.3
        $hour = $Matches.4
        $minute = $Matches.5
        $second = $Matches.6
        $date = "${year}:${month}:${day} ${hour}:${minute}:${second}"
        exiftool -overwrite_original_in_place -AllDates="$date" $filename
    } elseif ($basename -match '^([0-9]{4})([0-9]{2})([0-9]{2}).([0-9]{2})([0-9]{2})([0-9]{2})') {
        $year = $Matches.1
        $month = $Matches.2
        $day = $Matches.3
        $hour = $Matches.4
        $minute = $Matches.5
        $second = $Matches.6
        $date = "${year}:${month}:${day} ${hour}:${minute}:${second}"
        exiftool -overwrite_original_in_place -AllDates="$date" $filename
    } elseif ($basename -match '^([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2})([0-9]{2})') {
        $year = $Matches.1
        $month = $Matches.2
        $day = $Matches.3
        $hour = $Matches.4
        $minute = $Matches.5
        $date = "${year}:${month}:${day} ${hour}:${minute}:00"
        exiftool -overwrite_original_in_place -AllDates="$date" $filename
    } else {
        Write-Error "$basename does not match pattern"
    }
} else {
    Write-Error "$filename does not exist or is not a file"
}
