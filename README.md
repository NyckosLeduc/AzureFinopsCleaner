# AzureFinopsCleaner
Azure Finops Subscription Cleaning

From the Azure Portal (azure.portal.com), click the "+" sign in the top left of the screen, and search for automation. Click Azure Automation to create a new one.

Make sure to select yes at the create an Azure Run account

From the left panel click on Runbook, the type should be PowerShell.

Copy-paste the content of the script

Remove the -WhatIf at line 29 and 38, to really delete the resources.
Save and Publish

From the left panel click on Modules. You will need to import those three module (the order is important because of dependency)

Az.Accounts
Az.ResourceGraph
Az.Resources
Create a schedules, to have the script executed every day. Click on the Schedules from the left panel. Select the frequency you like, and save it.
