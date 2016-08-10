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
        $device | foreach {

            if (Test-Connection $_ -Count 1 -Quiet) {
            
                #if getobject is not specified, show online if it pings and offline if not. Still dont and this
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

                    #why is the 2nd foreach loop required here? - Look at this. Dont want this now.
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

"mfg-ky-man-s01" | get-pingstatus
# SIG # Begin signature block
# MIIT9QYJKoZIhvcNAQcCoIIT5jCCE+ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUX52E4BLwzMXhNtkOrbayOzwy
# 6OSggg8GMIIEmTCCA4GgAwIBAgIPFojwOSVeY45pFDkH5jMLMA0GCSqGSIb3DQEB
# BQUAMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQg
# TGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNV
# BAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVROLVVTRVJG
# aXJzdC1PYmplY3QwHhcNMTUxMjMxMDAwMDAwWhcNMTkwNzA5MTg0MDM2WjCBhDEL
# MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
# BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKjAoBgNVBAMT
# IUNPTU9ETyBTSEEtMSBUaW1lIFN0YW1waW5nIFNpZ25lcjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAOnpPd/XNwjJHjiyUlNCbSLxscQGBGue/YJ0UEN9
# xqC7H075AnEmse9D2IOMSPznD5d6muuc3qajDjscRBh1jnilF2n+SRik4rtcTv6O
# KlR6UPDV9syR55l51955lNeWM/4Og74iv2MWLKPdKBuvPavql9LxvwQQ5z1IRf0f
# aGXBf1mZacAiMQxibqdcZQEhsGPEIhgn7ub80gA9Ry6ouIZWXQTcExclbhzfRA8V
# zbfbpVd2Qm8AaIKZ0uPB3vCLlFdM7AiQIiHOIiuYDELmQpOUmJPv/QbZP7xbm1Q8
# ILHuatZHesWrgOkwmt7xpD9VTQoJNIp1KdJprZcPUL/4ygkCAwEAAaOB9DCB8TAf
# BgNVHSMEGDAWgBTa7WR0FJwUPKvdmam9WyhNizzJ2DAdBgNVHQ4EFgQUjmstM2v0
# M6eTsxOapeAK9xI1aogwDgYDVR0PAQH/BAQDAgbAMAwGA1UdEwEB/wQCMAAwFgYD
# VR0lAQH/BAwwCgYIKwYBBQUHAwgwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL2Ny
# bC51c2VydHJ1c3QuY29tL1VUTi1VU0VSRmlyc3QtT2JqZWN0LmNybDA1BggrBgEF
# BQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20w
# DQYJKoZIhvcNAQEFBQADggEBALozJEBAjHzbWJ+zYJiy9cAx/usfblD2CuDk5oGt
# Joei3/2z2vRz8wD7KRuJGxU+22tSkyvErDmB1zxnV5o5NuAoCJrjOU+biQl/e8Vh
# f1mJMiUKaq4aPvCiJ6i2w7iH9xYESEE9XNjsn00gMQTZZaHtzWkHUxY93TYCCojr
# QOUGMAu4Fkvc77xVCf/GPhIudrPczkLv+XZX4bcKBUCYWJpdcRaTcYxlgepv84n3
# +3OttOe/2Y5vqgtPJfO44dXddZhogfiqwNGAwsTEOYnB9smebNd0+dmX+E/CmgrN
# Xo/4GengpZ/E8JIh5i15Jcki+cPwOoRXrToW9GOUEB1d0MYwggUvMIIDF6ADAgEC
# AhMSAAAACbhrgg8m7vn6AAEAAAAJMA0GCSqGSIb3DQEBCwUAMCgxJjAkBgNVBAMT
# HU1pdGNoZWxsIEZhcnJhciBHcm91cCBSb290IENBMB4XDTE2MDYxNzEzMTgwNFoX
# DTE4MDYxNzEzMjgwNFowWjEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRMwEQYKCZIm
# iZPyLGQBGRYDREFMMSwwKgYDVQQDEyNNaXRjaGVsbCBGYXJyYXIgR3JvdXAgVmFs
# aWRhdGlvbiBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALM+DErE
# rbs114wd6R7ih3H2azqFz92qRkFMBurjekhzS6M67aCCutTw2htYt/q0Cagr2lJR
# 8mP1EJub/l7+L+LV4/wLjmsG5XsSC3FBGtC12zJP1H24gxrlgNkA82MWFIRULnDd
# lCaYBucahY2Bg+26XDjSg6RKTAL0D9TfCdGeFrlO8FtdJ7VMfByv4vyov9pNqAj6
# mzBZiYNpcathoq51lZRpGoccmXQcLLg/lWSORFzjzHV1rmi4DR5AqKQ52R2fWVDD
# H5GcTV0/GFIdkxrFItHbElJnGDHadfcDhCxqPA0Q7rP0wyT1JpNkuPRDxoupsr9J
# OVteUzwP8mRg9qUCAwEAAaOCAR4wggEaMBIGCSsGAQQBgjcVAQQFAgMFAAYwIwYJ
# KwYBBAGCNxUCBBYEFFdT9F+Js4KDsZ3LEXC0Rq+3RI/YMB0GA1UdDgQWBBTFACbR
# YccRUhshEUIhaQNrvZVu1jARBgNVHSAECjAIMAYGBFUdIAAwGQYJKwYBBAGCNxQC
# BAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYD
# VR0jBBgwFoAU3JzLDOCNc+TqA1sImDcPcXNpP24wUwYDVR0fBEwwSjBIoEagRIZC
# aHR0cDovL3BraS5tZmdyb3VwLmNvLnVrL01pdGNoZWxsJTIwRmFycmFyJTIwR3Jv
# dXAlMjBSb290JTIwQ0EuY3JsMA0GCSqGSIb3DQEBCwUAA4ICAQCq1R65loCo+4Hz
# NbYayfR0aLVX7OjJLdKgZWGWU0AND18AuqkL8o5tokxkV0GfXyBWXZVn27fzM7RG
# jWVVj6edxP8+hnehp5MMbLPmgR+0fh2Pqj9xyPY0RZxbHDZpkul8pbNEDI64RxPp
# /IvNgjfmBsPxeUYiwGxjFWbR6l792N9AdWxIlal87+Pa/BNNfQtZYpwwnLPEMJFL
# xkZtlHun5B5qG0zSB7WXLyMRs1rUk5uOPOqUkySpKMmSdQnLOaX9CEq4anRvaaCz
# YBbmvtAZEXlPMcGA0py8ocIcudaFdG1qEOuZ9ykJpS7Wct9IqZvw4xWBxGe51L1E
# OAYCPkq86jymDUkFqPrTfrE0s83d//+dtxKvAIxgZ6eERFXYaAfXJSbCARVfFQpW
# u2r5TU+8ktUT6+BK6lQYdunq3P9Ru96Fkm2EFQGLsVsdDt4uRQoHn9O3bd2x174A
# /Vf8o+yIsbJOZTlNiTLRKOFmoirffMSXEyB15sp29BmvIuMr/ShP0+ZuAqIN9Khz
# DAdaquul/rFkeBYI8VjuLO3IDB2HvDCc0Na4lSsfMSFwnfJv4ijEVmUwSPb0P4Gg
# FOY2b7x+rO2wEbZpOzSJrBLGC+hkIodFyqziQquF74059zrmss+mhdH7fLXxUOhC
# 06n+IeZZvejvJYVWdFDOHi4vyxF4bDCCBTIwggQaoAMCAQICEz8AAAAZuxxXrrIk
# uAkABQAAABkwDQYJKoZIhvcNAQELBQAwWjEVMBMGCgmSJomT8ixkARkWBWxvY2Fs
# MRMwEQYKCZImiZPyLGQBGRYDREFMMSwwKgYDVQQDEyNNaXRjaGVsbCBGYXJyYXIg
# R3JvdXAgVmFsaWRhdGlvbiBDQTAeFw0xNjA1MjYxNDUzMThaFw0xNzA1MjYxNDUz
# MThaMIGRMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZFgNE
# QUwxHjAcBgNVBAsTFU1pdGNoZWxsIEZhcnJhciBHcm91cDEaMBgGA1UECxMRU2Vu
# aW9yIE1hbmFnZW1lbnQxDjAMBgNVBAsTBVVzZXJzMRcwFQYDVQQDEw5CcmVuZGFu
# IE1hcnRpbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKxBDEBfdvCg
# pbPBuxZ7Ec8SXs+zW3HONaUrpC8r79BSfbX/UxNJNXC7Gy5IcFTQwp9dOxY0/Whw
# TIaVdpswnN6FkxnEpluSFjt55OFDVHqMRfDw5WhJqOaiHaSg8AMEaLGC3CPF7OG7
# VkOJXVOmE4VnpYJHXXYSqNZF60d848fTZ4SDZeKGagsoENc9PoSUOFOW61GlCTea
# lWPT6uZ3Q0smWJM5p8GtCQt+OgPgw3yvq+Ezb2N7/HL2e3KLal/+pVTvokdu0afG
# 6EnByXQKQcMmYBfgjBCr7e+8sbeTRN9i8M7zJfGGUAt58V53f9hgEI0tyMu3M+j5
# dsjHXOGowCkCAwEAAaOCAbcwggGzMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcV
# CIKU2RmF06kTh9mLCYGZ0SCF/KBEZ+rRLoWlyisCAWUCAQMwEwYDVR0lBAwwCgYI
# KwYBBQUHAwMwCwYDVR0PBAQDAgeAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYBBQUH
# AwMwHQYDVR0OBBYEFMQAt3O80DtrmBb/ftBY5BqER4SBMB8GA1UdIwQYMBaAFMUA
# JtFhxxFSGyERQiFpA2u9lW7WMFwGA1UdHwRVMFMwUaBPoE2GS2h0dHA6Ly9wa2ku
# bWZncm91cC5jby51ay9NaXRjaGVsbCUyMEZhcnJhciUyMEdyb3VwJTIwVmFsaWRh
# dGlvbiUyMENBKDUpLmNybDBnBggrBgEFBQcBAQRbMFkwVwYIKwYBBQUHMAKGS2h0
# dHA6Ly9wa2kubWZncm91cC5jby51ay9NaXRjaGVsbCUyMEZhcnJhciUyMEdyb3Vw
# JTIwVmFsaWRhdGlvbiUyMENBKDUpLmNydDAtBgNVHREEJjAkoCIGCisGAQQBgjcU
# AgOgFAwSQnJlbmRhbk1AREFMLmxvY2FsMA0GCSqGSIb3DQEBCwUAA4IBAQAmkzcL
# q2Z/iZkpvJn4a/wkEMDGOtBOtK9BzNL/csfECL3XpGG7T4WsKTvmmgnoRcEaLB5S
# oFaMa7ZJNRTHgeA9Syi9ceYFp6poRoxfJvGiZVmgB7VTmlFQxne8P4sIUnokPVdk
# ST/xofZTDbIQjj36QN45RLJf43mOzrupfDtOzK00aFWQL8MCDLZZMRnzEe48tCC+
# JPg2Frq8RJvnwqo6z+xTmIiMQmgH0uK4t50zOJCdbqa4cSDhhUMq0DHf8vVe+W0w
# +0CHdWNK2ERmLPfSyafBT9T6ztQGJzvPp3mwh7mOfPioYSDPFuqaIl0VYmrR+Jod
# 1hMmw8pqk14Rw4ZzMYIEWTCCBFUCAQEwcTBaMRUwEwYKCZImiZPyLGQBGRYFbG9j
# YWwxEzARBgoJkiaJk/IsZAEZFgNEQUwxLDAqBgNVBAMTI01pdGNoZWxsIEZhcnJh
# ciBHcm91cCBWYWxpZGF0aW9uIENBAhM/AAAAGbscV66yJLgJAAUAAAAZMAkGBSsO
# AwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqG
# SIb3DQEJBDEWBBRxqyvc5p9ALD9oFRTAWaLjTpQomjANBgkqhkiG9w0BAQEFAASC
# AQBFzsxTVimvzE0IyfJyOpZnllhPTdUPtRMpiJjY8m5fkU81BAwwDTh0HvTkz0+X
# n1pF4kDkZg/qvy25yXigBNaSsNzPQmiIJV6Jl4s+hJwfSr8Rhey69gSmXXJHgOFU
# tiU6AEoqr6kTHycZ1+wLsFa43hBdkYPI1Qc0VZYK6qGgWC0fnQscentp+BW4fQ54
# EInFjvdyaM6VAY4oVRY5962YQRN9rf6HILOTlpG7j/5XKwef9SZkUsPPhcviUWKS
# N3YMw7vKEZ90vZ9q8IGqb3v3Fi4re36/Z6kHzah/fhG1+RbSuLcEoUKHZLFD0z8A
# //zcpj8zCMsIbNSlG/dF33bioYICQzCCAj8GCSqGSIb3DQEJBjGCAjAwggIsAgEA
# MIGpMIGVMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQg
# TGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNV
# BAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTEdMBsGA1UEAxMUVVROLVVTRVJG
# aXJzdC1PYmplY3QCDxaI8DklXmOOaRQ5B+YzCzAJBgUrDgMCGgUAoF0wGAYJKoZI
# hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwODEwMTE1MjQ5
# WjAjBgkqhkiG9w0BCQQxFgQUfbcNvkdPl363DKobU8tTzoQ+gJ4wDQYJKoZIhvcN
# AQEBBQAEggEAtOMurA1hzKXgUlOWP7alD4zO52JaZ6eoEMw2DGiiPoRPWuweLaq3
# zMT24QC2bfAlJeNpZFqNoyq5UiOmbYTwPRD+Rrzgu9UXRwSSCn2YwC+cDspjWJDq
# 2eJ+QauNOAg7TZXhgL2XR+MnacPot4dTdAy2PepIggd1qaMiGcVc+0g7ULB4h63D
# nw6uBTl+s1w3mliI50tcMLfp8+j8SLJ5xbnXxtvh+hExZqLZIPS9ALQ5+qlt8kMx
# PNJR8HfdeL0s6s89oQGwHDbGLujV7KBymHszBg6Kr/GGcw6PECpbcTU3GIApRo5d
# 88Cw4iJmbQrYkgsUcQFUfuQ0rVCOnDxY3Q==
# SIG # End signature block
