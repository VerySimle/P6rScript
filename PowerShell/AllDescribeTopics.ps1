#Connect to Kafka
$Broker = "IP:PORT"

#CLI all describe
$KAFKA_DES = .\kafka-topics.bat --bootstrap-server $Broker --describe

#Parser date describe
$fileName = 'Config-' + $((Get-Date).ToString("yyyyMMdd_HHmmss")) + '.csv'
New-Item .\$fileName -ItemType File
Add-Content .\$fileName 'Topic;PartitionCount;ReplicationFactor;Configs'
$DESK = $KAFKA_DES | Select-String -Pattern 'Leader' -NotMatch
foreach ($record in $DESK) {
    $record -match ':\s(?<Topic>.+)\s+\w+:\s(?<Partition>.+)\s+\w+:\s(?<Replica>.+)\s+\w+:\s(?<Conf>.+)$'
    $line = $Matches.Topic + ";" + $Matches.Partition + ";" + $Matches.Replica + ";" + $Matches.Conf
    Add-Content .\$fileName $line
}