$runaz = "AzureRunAsConnection"
try
{
    $servicePrincipalConnection=Get-AutomationConnection -Name $runaz
    Connect-AzAccount `
        -ServicePrincipal `
        -Tenant $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "ERROR $runaz not found."
        throw $ErrorMessage
    } else{
        write-host -Message $_.Exception
        throw $_.Exception
    }
}
$expResources= Search-AzGraph -Query 'where todatetime(tags.expireOn) < now() | project id'
foreach ($r in $expResources) {
    write-host "Deleting Resource with ID: $r.id"
    #Remove whatif for delete ressources
    Remove-AzResource -ResourceId $r.id -Force -WhatIf 
}
$rgs = Get-AzResourceGroup;
foreach($resourceGroup in $rgs){
    $name=  $resourceGroup.ResourceGroupName;
    $count = (Get-AzResource | Where-Object{ $_.ResourceGroupName -match $name }).Count;
    if($count -eq 0){
        write-host "Delete RG $name"
        #Remove whatif for delete ressources
        Remove-AzResourceGroup -Name $name -Force -WhatIf 
    }
}
