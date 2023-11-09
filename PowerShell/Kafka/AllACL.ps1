#Connect to Kafka
$Broker = "IP:PORT"

#CLI all ACL
$KAFKA_ACLS = .\kafka-acls.bat --list --bootstrap-server $Broker

#Pattern
$PATTERN_ACLS_LIST = '(?m)^Current ACLs for resource \`ResourcePattern\(resourceType=TOPIC[\n\r\s\S]*?(\r\n\r\n)'
#Group acl
#$PATTERN_ACLS_LIST = '(?m)^Current ACLs for resource \`ResourcePattern\(resourceType=GROUP[\n\r\s\S]*?(\r\n\r\n)'
$PATTERN_NAME_OF_TOPIC = 'name=(.*), patternType=LITERAL'
$PATTERN_LIST_OF_VALUE = '(?m).*principal=.*$'

#Create file
$fileName = 'resultACL' + $((Get-Date).ToString("yyyyMMdd")) + 'csv'
New-Item .\$fileName -ItemType File
Add-Content .\$fileName 'Topic;CN;Operation;Permission'
#Group acl
#Add-Content .\$fileName 'Name Group;CN;Operation;Permission'

#Get ACLs data on Kafka
$kafkaAclsResult = $KAFKA_ACLS | Out-String

$arrayACLs = $kafkaAclsResult | Select-String $PATTERN_ACLS_LIST -AllMatches | foreach {$_.Matches.Value}
$resultArr = @{}
foreach ($record in $arrayACLs) {
    $topicName = $record | Select-String $PATTERN_NAME_OF_TOPIC -AllMatches | foreach {$_.Matches.groups[1].Value}
    $arrOfValue = $record | Select-String $PATTERN_LIST_OF_VALUE -AllMatches | foreach {$_.Matches.Value}
    if ($resultArr.ContainsKey($topicName))
    {
        $arr = $resultArr[$topicName]
        $arr += , $arrOfValue
        $resultArr.Add($topicName, $arr)
    }
    else {
        $resultArr.Add($topicName, $arrOfValue)
    }
}

foreach ($entry in $resultArr.GetEnumerator()) {
    $count = 0
    $line = $entry.key + ';'
    foreach ($value in $entry.Value) {
        $mapOfvalue = @{}
        $value.Replica("(","").Replica(")","").split(',') | foreach {
            $i = $_.Trim().split('=')
            $mapOfvalue.Add($i[0], $i[1])
        }
        if ($count -ne 0) {
            $line = ';'
        }
        $line = $line + $mapOfvalue['principal'] + ";" + $mapOfvalue['operation'] + ";" + $mapOfvalue['permissionType']
        $count++
        Add-Content .\$fileName $line
    }
}