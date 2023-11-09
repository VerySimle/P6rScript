#Connect to Kafka
$Broker = "IP:PORT"
$Topic = "TOPIC"

$UnixTimeBegin = 1698758478674 # Begin read time
#Begin time unix
$EpochStart = Get-Date -Day 1 -Month 1 -Year 1970 -Hour 0 -Minute 0 -Second 0 -Millisecond 0
#Consumer CLI
.\kafka-console-consumer.bat --bootstrap-server $Broker --from-beginning --topic $Topic --property print.timestamp=true --timeout-ms 1000 | Select-String -Pattern "^CreateTime:(\d+)" | Where-Object { [double]$_.Matches.Groups[1].Value -ge $UnixTimeBegin } >> timeOver.txt

$timeUnix = Get-Content -Path 'timeOver.txt'
foreach ($line in $timeUnix) {
     if ($line -match '^CreateTime:(\d+)') {
         ($EpochStart.AddMilliseconds([long]$matches[1])).ToShortDateString() >> time.txt
     }
}

#counting messages from a certain time
Get-Content -Path 'time.txt' | Group-Object -noelement | Format-Table -Autosize >> CountMessage.log
