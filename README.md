# BG3_Automated-Save-Scummer
Automatically scums your Honor Mode save, shame on you

# How this works

This script watches for changes in your specified Honour Mode save file
Once it detects a change (When you save in game) it zips the save, and saves the zip to %localappdata%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Backup\UUID\ (UUID refers to your unique ID for the save)
It then copes over the screenshot made by BG3 in order to assist you with identifying saves for restoration later


The script can remain running, it will stop watching when Baldur's Gate 3 is no longer running, and check every 30 seconds to see if the game is running, then resume backing up the saves


# How to use

## Step 1: Get your Save UUID

1. Navigate to %localappdata%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Story
2. Find the save folder you want to scum (The save will have __Honour_Mode at the end of the folder name)
3. Copy the UUID String of the folder 

## Step 2: Edit the script for your UUID

1. Edit the BG3_Automated-Save-Scummer.ps1 script with your editor of choice
2. Change the first line ($uuid = "12345678-90ab-cdef-1234-567890abcdef") to match the UUID you got in step 1
3. Save the file

## Step 3: Run the script

Run the script with your preferred method
Example: Open powershell/Terminal in the same directory as the script and use .\BG3_Automated-Save-Scummer.ps1