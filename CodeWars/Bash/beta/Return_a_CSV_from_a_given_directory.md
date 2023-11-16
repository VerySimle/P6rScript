## Description

Make a Function that returns a comma separated list in the order of

`"DirectoryName, Filename, FileExtension"`

## Sample Tests

```bash
output = run_shell args: ["/Users/Tech/Desktop/backup/Nutters_with_Putters_Revenge_of_the_Nutters2.avi"]
describe "Solution" do
  it "Should return Comma Separated List" do
    expect(output).to include("/Users/Tech/Desktop/backup, Nutters_with_Putters_Revenge_of_the_Nutters2, avi")
  end
end
```

## My solutions

```bash
echo $1 | sed -e 's:/:, :5' -e 's_\._, _'
```