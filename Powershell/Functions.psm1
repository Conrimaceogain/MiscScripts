﻿function Send-Windows10Notification {
    param (
        [String]$NotificationTitle = ("Notification: " + [DateTime]::Now.ToShortTimeString()),
        [String[]]$NotificationText
    )
    $ErrorActionPreference = "Stop"


    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)

    #Convert to .NET type for XML manipuration

    $toastXml = [xml] $template.GetXml()
    $toastXml.toast.visual.binding.SetAttribute("template","ToastGeneric")
    $title = $toastXml.toast.visual.binding.text.Clone()
    $title.InnerText = $NotificationTitle
    $title.RemoveAttribute("id")
    $toastXml.toast.visual.binding.AppendChild($title) > $null
    $text = $toastXml.toast.visual.binding.text[0].Clone()
    $text.InnerText = $NotificationText
    $text.RemoveAttribute("id")
    $toastXml.toast.visual.binding.AppendChild($text) > $null
    write-host $toastXML.toast.visual.binding.RemoveChild($toastXml.toast.visual.binding.text[0])
    $toastXML.OuterXml


    
    #Convert back to WinRT type
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($toastXml.OuterXml)

    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    $toast.Tag = "PowerShell"
    $toast.Group = "PowerShell"
    $toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)
    #$toast.SuppressPopup = $true

    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
    $notifier.Show($toast);
}
