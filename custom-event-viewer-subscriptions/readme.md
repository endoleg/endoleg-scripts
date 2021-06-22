To insert some great custom event views in the windows event log viewer 

copy the xml files from

https://github.com/palantir/windows-event-forwarding/tree/master/wef-subscriptions

and 

https://github.com/nsacyber/Event-Forwarding-Guidance/tree/master/Subscriptions/samples

to

%ProgramData%\Microsoft\Event Viewer\Views

%LocalAppData%\Microsoft\Event Viewer\Views

(Each custom view is linked to an XML file located in one of the folders)
