Custom event log views:

To insert some great custom event views in the windows event log viewer 

copy the xml files from

https://github.com/palantir/windows-event-forwarding/tree/master/wef-subscriptions
(Download URL for full repository in a zip-file: https://codeload.github.com/palantir/windows-event-forwarding/zip/master )

and 

https://github.com/nsacyber/Event-Forwarding-Guidance/tree/master/Subscriptions/samples

(Download URL for full repository in a zip-file: https://codeload.github.com/nsacyber/Event-Forwarding-Guidance/zip/master )

to

%ProgramData%\Microsoft\Event Viewer\Views
or
%LocalAppData%\Microsoft\Event Viewer\Views

(Each custom view is linked to an XML file located in one of the folders)

Now start 
eventvwr.msc
and the custom views will appear.

To jump directly to a custom view, 
you need to use the eventvwr.msc command-line with the /v parameter. And, you need to mention the XML file name of that particular custom view item.

-----------------

Advanced security audit policy settings:
https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings

------------------------------------

Bonus:
Jump Directly to a Specific Event Log in Event Viewer:

If you’re going to check this File History event log channel many times in a day, then there is an easier option for you. 
Simply create a desktop shortcut with the following command-line.

The command-line would open the Event Viewer and jump to the mentioned log or channel directly.

mmc.exe eventvwr.msc /c:"Microsoft-Windows-FileHistory-Engine/BackupLog"


--------------------------------------------------


https://thedavecarroll.com/powershell/windows-event-logs-eventdata/

https://evotec.pl/powershell-everything-you-wanted-to-know-about-event-logs/

https://raw.githubusercontent.com/EvotecIT/PSEventViewer/master/Public/Get-EventsFilter.ps1


