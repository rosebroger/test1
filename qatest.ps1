class C0 {
    [hashtable]$ht

    [hashtable]Env(){
        [hashtable]$Env = @{}
        $Env.pscommandpath = $PSCommandPath
        $Env.pscommandpathSplit = Split-Path -Path $PSCommandPath 
        $Env.pscommandpathLeaf = Split-Path -Path $PSCommandPath -Leaf
        $Env.pscommandpathLeafBase = Split-Path -Path $PSCommandPath -LeafBase
        $Env.pscommandpathParent = Split-Path -Path $PSCommandPath -Parent
        $Env.pscommandpathExtension = Split-Path -Path $PSCommandPath -Extension
        return $Env
    }

    C0(){
        $this.ht = $this.Env()

        $this.ht.default = @{}
        $this.ht.default.inputLogFile = "Input Log File"
        $this.ht.default.inputLogFile2 = "Input Log File 2"
        $this.ht.default.sourceDir = "Input Source Directory"
        $this.ht.default.destinationDir = "Input Destination Directory"   

    }

    ReadHost([string]$p1){
        #Read-Host -Prompt $p1
        (Read-Host -Prompt $p1) -as [string]
    }

    [boolean]TestPath([string]$p1){
        $a = Test-Path -Path $p1
        return $a
    }

    [string]GetDate(){
        $a = Get-Date -Format "yyyy.MM.dd HH:mm:ss.FFFFFFF"
        return $a
    }

    AddContent([string]$p1, [string]$p2){
        Add-Content -Path $p1 -Value $p2
    }

    [array]GetChildItem([string]$p1){
        $a = Get-ChildItem -Path $p1
        #$a = Get-ChildItem -Path $p1 -Force  # For Hidden files
        return $a
    }

    [array]CompareObject([array]$p1, [array]$p2){
        $a = Compare-Object -ReferenceObject $p1 -DifferenceObject $p2 -IncludeEqual -Property Name,Length,LastWriteTime
        return $a
    }

    CopyItem([string]$p1, [string]$p2){
        Copy-Item -Path $p1 -Destination $p2 -Recurse 
    }

    RemoveItem([string]$p1){
        Remove-Item -Path $p1 -Recurse -Force
    }

}

class C1:C0 {
    [string]GetInput1([string]$p1 = "ReadHost_Input", [string]$p2 = ""){
        $a=""
        do{
            $a = Read-Host -Prompt $($p1+" (Default: $p2)")

            if ((! $a) -OR ($a -eq "") -OR ($a -eq $null)){
                $a = $p2
            } else {
                $a = $a
            }
            if ($p1 -eq $this.ht.default.inputLogFile) {
            if ($this.TestPath($a) -eq $False){
                New-Item -ItemType File -Path $a
            }
            }
            if ($p1 -eq $this.ht.default.inputLogFile2) {
            if ($this.TestPath($a) -eq $True){
                Remove-Item -Path $a -Recurse -Force
            }
            New-Item -ItemType File -Path $a
            }

        } while ((! $a) -OR ($a -eq "") -OR ($a -eq $null) `
                 -OR ($this.TestPath($a) -eq $False))

        return $a
    }
}



$c0 = [C0]::new()
$c1 = [C1]::new()

# You can input default values before begining
$c0.ht.default.inputLogFilePath = ""
#$c0.ht.default.inputLogFilePath = $($c0.ht.pscommandpathParent+"\"+$c0.ht.pscommandpathLeafBase+".log")
$c0.ht.default.inputLogFilePath2 = ""
#$c0.ht.default.inputLogFilePath2 = $($c0.ht.pscommandpathParent+"\"+$c0.ht.pscommandpathLeafBase+"-"+$(Get-Date -Format "yyyyMMdd_HHmmss_FFFFFFF")+".log")
$c0.ht.default.sourceDirPath = ""
#$c0.ht.default.sourceDirPath = $($c0.ht.pscommandpathParent+"\source\")
$c0.ht.default.destinationDirPath = ""
#$c0.ht.default.destinationDirPath = $($c0.ht.pscommandpathParent+"\destination\")

$logFile = $c1.GetInput1($c0.ht.default.inputLogFile, $c0.ht.default.inputLogFilePath)

$dt1=$c0.GetDate()
$e="`n"+("="*100)+"`n["+$dt1+"]"
$e+="`n[c0] "+$($c0.toString())`
    +"`n[c0.ht] "+$($c0.ht)`
    +"`n[c0.ht.ps] "+$($c0.ht.pscommandpath)`
    +"`n[c0.ht.psLeafBase] "+$($c0.ht.pscommandpathLeafBase)`
    +"`n[c0.ht.psParent] "+$($c0.ht.pscommandpathParent)`
    +"`n[logFile] "+$logFile.toString()`
    +"`n[logFile_TestPath] "+$c0.TestPath($logFile).toString()
$e = "[$($c0.GetDate())]"+$e
$c0.AddContent($logFile, $e)
Write-Output -InputObject $e

$logFile2 = $c1.GetInput1($c0.ht.default.inputLogFile2, $c0.ht.default.inputLogFilePath2)
$c0.AddContent($logFile2, $e)
$e = "[$($c0.GetDate())]"+"`t[logFile2] "+$logFile2.toString()`
  +"`n[$($c0.GetDate())]"+"`t[logFile2_TestPath] "+$c0.TestPath($logFile2).toString()
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$sourceDir = $c1.GetInput1($c0.ht.default.sourceDir, $c0.ht.default.sourceDirPath)
$e = "[$($c0.GetDate())]"+"`t[sourceDir] "+$sourceDir.toString()`
  +"`n[$($c0.GetDate())]"+"`t[sourceDir_TestPath] "+$c0.TestPath($sourceDir).toString()
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$destinationDir = $c1.GetInput1($c0.ht.default.destinationDir, $c0.ht.default.destinationDirPath)
$e = "[$($c0.GetDate())]"+"`t[destinationDir] "+$destinationDir.toString()`
  +"`n[$($c0.GetDate())]"+"`t[destinationDir_TestPath] "+$c0.TestPath($destinationDir).toString()
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$sourceDirContent = $c0.GetChildItem($sourceDir)
$e = "[$($c0.GetDate())]"+"`t[sourceDirContent.Count] "+($sourceDirContent.Count)`
  +"`n[$($c0.GetDate())]"+"`t[sourceDirContent] "+($sourceDirContent|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$destinationDirContent = $c0.GetChildItem($destinationDir)
$e = "[$($c0.GetDate())]"+"`t[destinationDirContent.Count] "+($destinationDirContent.Count)`
  +"`n[$($c0.GetDate())]"+"`t[destinationDirContent] "+($destinationDirContent|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

if ($sourceDirContent.count -eq 0) {
    $e = "[$($c0.GetDate())]"+"`t[sourceDir is Empty]"
    $c0.AddContent($logFile, $e)
    $c0.AddContent($logFile2, $e)
    Write-Output -InputObject $e
} else {

    if ($destinationDirContent.count -eq 0) {
        # Copy all files to Empty Destination directory
        $c0.CopyItem($sourceDir+"\*", $destinationDir)
        $e = "[$($c0.GetDate())]"+"`t[destinationDir initial is Empty and Now sourceDir was copied to destinationDir] "
        $c0.AddContent($logFile, $e)
        $c0.AddContent($logFile2, $e)
        Write-Output -InputObject $e
    } else {
        # Compare files
        $comp = $c0.CompareObject($sourceDirContent, $destinationDirContent)
        $e = "[$($c0.GetDate())]"+"`t[compareObject.Count] "+($comp.Count)`
          +"`n[$($c0.GetDate())]"+"`t[compareObject] "+($comp|Out-String)
          
        $c0.AddContent($logFile, $e)
        Write-Output -InputObject $e

        $comp_eq = $comp | Where-Object {$_.SideIndicator -eq "=="}
        $e = "[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '==' .Count] "+($comp_eq.Count)`
          +"`n[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '=='] "+($comp_eq|Out-String)       
        $c0.AddContent($logFile, $e)
        $c0.AddContent($logFile2, $e)
        Write-Output -InputObject $e
        $comp_l = $comp | Where-Object {$_.SideIndicator -eq "<="}
        $e = "[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '<=' .Count] "+($comp_l.Count)`
          +"`n[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '<='] "+($comp_l|Out-String)
        $c0.AddContent($logFile, $e)
        $c0.AddContent($logFile2, $e)
        Write-Output -InputObject $e
        $comp_r = $comp | Where-Object {$_.SideIndicator -eq "=>"}
        $e = "[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '=>' .Count] "+($comp_r.Count)`
          +"`n[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '=>'] "+($comp_r|Out-String)
        $c0.AddContent($logFile, $e)
        $c0.AddContent($logFile2, $e)
        Write-Output -InputObject $e

        $comp | foreach {
            # Copy file from Source to Destination
            if ($_.SideIndicator -eq "<=") {
                $c0.CopyItem($sourceDir+"\"+$_.Name, $destinationDir)
                $e = "[$($c0.GetDate())]"+"`t[compareObject] [Source_Copy] [The file $($sourceDir+$_.Name) was copied to $($destinationDir+$_.Name)]"
                $c0.AddContent($logFile, $e)
                $c0.AddContent($logFile2, $e)
                Write-Output -InputObject $e
            }
            # Remove file from Destination
            if ($_.SideIndicator -eq "=>") {
                $c0.RemoveItem($destinationDir+"\"+$_.Name)
                $e = "[$($c0.GetDate())]"+"`t[compareObject] [Destination_Remove] [The file $($destinationDir+$_.Name) was removed]"
                $c0.AddContent($logFile, $e)
                $c0.AddContent($logFile2, $e)
                Write-Output -InputObject $e
            }
        }
    }

}

# Check replication
$sourceDirContent = $c0.GetChildItem($sourceDir)
$e = "[$($c0.GetDate())]"+"`t[sourceDirContent.Count: Check] "+($sourceDirContent.Count)`
  +"`n[$($c0.GetDate())]"+"`t[sourceDirContent: Check] "+($sourceDirContent|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$destinationDirContent = $c0.GetChildItem($destinationDir)
$e = "[$($c0.GetDate())]"+"`t[destinationDirContent.Count: Check] "+($destinationDirContent.Count)`
  +"`n[$($c0.GetDate())]"+"`t[destinationDirContent: Check] "+($destinationDirContent|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$comp = $c0.CompareObject($sourceDirContent, $destinationDirContent)
$e = "[$($c0.GetDate())]"+"`t[compareObject: Check] "+($comp|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e

$comp_eq = $comp | Where-Object {$_.SideIndicator -eq "=="}
$e = "[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '==' .Count: Check] "+($comp_eq.Count)`
  +"`n[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '==': Check] "+($comp_eq|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e
$comp_l = $comp | Where-Object {$_.SideIndicator -eq "<="}
$e = "[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '<=' .Count: Check] "+($comp_l.Count)`
  +"`n[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '<=': Check] "+($comp_l|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e
$comp_r = $comp | Where-Object {$_.SideIndicator -eq "=>"}
$e = "[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '=>' .Count: Check] "+($comp_r.Count)`
  +"`n[$($c0.GetDate())]"+"`t[compareObject: SideIndicator -eq '=>': Check] "+($comp_r|Out-String)
$c0.AddContent($logFile, $e)
$c0.AddContent($logFile2, $e)
Write-Output -InputObject $e


