try {
	$ErrorActionPreference = 'Stop'
	
	$Path = 'C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeDisks.ps1'
	$instanceId = Invoke-RestMethod -uri http://169.254.169.254/latest/meta-data/instance-id
    $volumes = (get-ec2volume).Attachments | where InstanceId -eq $instanceId
    $attached = $false
    $countSleep = 0;
    while (-Not ($attached)) {
    	$count = 0
    	foreach ($volume in $volumes) {
    		if ($volume.State -eq "attached") {
    			$count = $count + 1
    		}
    	}
    	if ($count -eq $volumes.length) {
    		$attached = $true
    	} else {
    		$countSleep = $countSleep + 1
    		Start-Sleep -s 1
    	}

    	if ($countSleep -gt 15) {
    		throw "It is taking unusually longer for volumes to get attached. Aborting the program."
    	}

    }
    
	if (Test-Path -Path $Path) {
		C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeDisks.ps1
	}

    Start-Sleep -s 60


} catch {
	$_ | Write-AWSLaunchWizardException
}
