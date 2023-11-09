#Connect to Kafka
$Broker = "IP:PORT"
$Replication = 4
$Topics = @(
    'test1'
    'test2'
)

$regex = '"size":\d+'
foreach ($topic in $Topics){
    $KafkaLogDirs = .\kafka-log-dirs.bat --describe --bootstrap-server $Broker --topic-list $topic
    $values = $KafkaLogDirs | Select-String -Pattern $regex -AllMatches | ForEach-Object {$_.Matches.Value}
    $sum = ($values | ForEach-Object {$_ -replace '"size":', ''} | Measure-Object -Sum).Sum / 1MB / $Replication
    $output = "Name - $topic`r`nTotal size:$sum`r`n`r`n"
    Add-Content -Path "size.txt" -Value $output
}
