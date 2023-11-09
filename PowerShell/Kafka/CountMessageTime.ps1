#Connect to Kafka
$Broker = "IP:PORT"
$Topic = "TOPIC"

# Beggin time unix 
$EpochStart = Get-Date -Day 1 -Month 1 -Year 1970 -Hour 0 -Minute 0 -Second 0 -Millisecond 0

.\kafka-console-consumer.bat --bootstrap-server $Broker --from-beginning --topic $Topic --property print.timestamp=true --timeout-ms 1000 >> timeUnix.txt

$timeUnix = Get-Content -Path 'timeUnix.txt'
foreach ($line in $timeUnix) {
    if ($line -match '^CreateTime:(\d+)') {
        ($EpochStart.AddMilliseconds([long]$matches[1])).ToShortDateString() >> Ztime.txt
    }
}

#Count Time
Get-Content -Path 'time.txt' | Group-Object -noelement | Format-Table -Autosize >> CountMessageToDate.log