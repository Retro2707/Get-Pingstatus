Function Get-Pingstatus
{
    param(
    #allows value from pipeline
        [Parameter(ValueFromPipeline=$true)]
        [string]$device,

        #allows only certain items to be passed to getobject
        [validateSet("Online","Offline","ObjectTable")]
        [String]$getobject
    )

    begin {

        #create the hashtable
        $hash = @()

    } process {

        #takes the input from device and passes to a foreach loop
        device | foreach {

            if (Test-Connection $_ -Count 1 -Quiet) {
            
                #if getobject is not specified, show online if it pings and offline if not.
                if(-not($Getobject)) {Write-host -foregroundColor Green "Online: $_ "}
                
                    #add to the current hashtable array the device is online.
                    $Hash = $Hash += @{Online = "$_"}
            } else {

                if(-not(Getobject)) {Write-host -ForegroundColor Red "Offline: $_ "}

                    #add to the current hashtable array the device is offline
                    $Hash = $Hash +=@{Offline = "$_"}
            }
        }

    } end {
 
        #if you have put something in getobject
        if($Getobject) {

            #This allows the object to be used outside of the script
            $Global:Objects = $Hash | foreach { 
        
                [PSCustomObject]@{

                    #why is the 2nd foreach loop required here?
                    DeviceName = $_.Values | foreach { "$_" }
                    Online     = $_.Keys | where {$_ -eq "Online"}
                    Offline    = $_.Keys | where {$_ -eq "Offline"}
                }
            }

            Switch -Exact ($Getobject) {

                'Online'     { $Global:Objects | where 'online' | select -ExpandProperty DeviceName }
                'Offline'     { $Global:Objects | where 'offline' | select -ExpandProperty DeviceName }
                'ObjectTable' { return $Global:Objects}
            }

        }

    }

}
