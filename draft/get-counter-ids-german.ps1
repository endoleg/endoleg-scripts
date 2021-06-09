
function Get-PerformanceCounterID
{
    param
    (
        [Parameter(Mandatory=$true)]
        $Name
    )
    if ($script:perfHash -eq $null)
    {
        Write-Progress -Activity 'Retrieving PerfIDs' -Status 'Working'

        $key = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib\CurrentLanguage'
        $counters = (Get-ItemProperty -Path $key -Name Counter).Counter
        $script:perfHash = @{}
        $all = $counters.Count

        for($i = 0; $i -lt $all; $i+=2)
        {
           Write-Progress -Activity 'Retrieving PerfIDs' -Status 'Working' -PercentComplete ($i*100/$all)
           $script:perfHash.$($counters[$i+1]) = $counters[$i]
        }
    }

    $script:perfHash.$Name
}
$counters 

<#

1
1847
2
System
4
Arbeitsspeicher
6
Prozessorzeit (%)
10
Lesevorgänge/s
12
Schreibvorgänge/s
14
Dateisteuervorgänge/s
16
Bytes gelesen/s
18
Bytes geschrieben/s
20
Dateisteuerbytes/s
24
Verfügbare Bytes
26
Zugesicherte Bytes
28
Seitenfehler/s
30
Zusagegrenze
32
Schreibkopien/s
34
Wechselfehler/s
36
Cachefehler/s
38
Nullforderungsfehler/s
40
Seiten/s
42
Seitenlesevorgänge/s
44
Prozessor-Warteschlangenlänge
46
Threadstatus
48
Geänderte Seiten/s
50
Seiten-Schreibvorgänge/s
52
Suchdienst
54
Serverankündigungen/s
56
Auslagerungsseiten (Bytes)
58
Nicht-Auslagerungsseiten (Bytes)
60
Auslagerungsseiten reserviert
64
Nichtauslagerungsseiten reserviert
66
Auslagerungsseiten: Residente Bytes
68
Systemcode: Gesamtanzahl Bytes
70
Systemcode: Residente Bytes
72
Systemtreiber: Gesamtanzahl Bytes
74
Systemtreiber: Residente Bytes
76
Systemcache: Residente Bytes
78
Domänenankündigungen/s
80
Wahlpakete/s
82
Mailslot-Schreibvorgänge/s
84
Serverlistenanforderungen/s
86
Cache
88
Datenzuordnungen/s
90
Datenzuordnungen/s (sync.)
92
Datenzuordnungen/s (async.)
94
Datenzuordnungstreffer (%)
96
Datenzuordnung - Festsetzungen/s
98
Festsetzung - Lesevorgänge/s
100
Festsetzung - Lesevorgänge/s (sync.)
102
Festsetzung - Lesevorgänge/s (async.)
104
Festsetzung - Lesetreffer (%)
106
Kopieren - Lesevorgänge/s
108
Kopieren - Lesevorgänge/s (sync.)
110
Kopieren - Lesevorgänge/s (async.)
112
Kopieren - Lesetreffer (%)
114
MDL-Lesevorgänge/s
116
MDL-Lesevorgänge/s (sync.)
118
MDL-Lesevorgänge/s (async.)
120
MDL-Lesetreffer (%)
122
Vorauslesevorgänge/s
124
Schnelle Lesevorgänge/s
126
Schnelle Lesevorgänge/s (sync.)
128
Schnelle Lesevorgänge/s (async.)
130
Schnelllesen-Ressourcefehltreffer/s
132
Schnelllesen nicht möglich/s
134
Verzögertes Schreiben - Leerungen/s
136
Verzögertes Schreiben - Seiten/s
138
Datenleerungen/s
140
Datenleerung - Seiten/s
142
Benutzerzeit (%)
144
Privilegierte Zeit (%)
146
Kontextwechsel/s
148
Interrupts/s
150
Systemaufrufe/s
152
Ebene 1 Auffüllen des TLB/s
154
Ebene 2 Auffüllen des TLB/s
156
Serveraufzählungen/s
158
Domänenaufzählungen/s
160
Sonstige Aufzählungen/s
162
Nicht erhaltene Serverankündigungen
164
Nicht erhaltene Mailslotdatagramme
166
Nicht verarbeitete Serverlistenanforderungen
168
Zuordnungsfehler bei Serverankündigungen/s
170
Mailslot-Zuordnungsfehler
172
Virtuelle Bytes (max.)
174
Virtuelle Größe
178
Arbeitsseiten (max.)
180
Arbeitsseiten
182
Auslagerungsdatei (max. Bytes)
184
Auslagerungsdatei (Bytes)
186
Private Bytes
188
Gesamtanzahl Ankündigungen/s
190
Gesamtanzahl Aufzählungen/s
198
Aktuelle Warteschlangenlänge
200
Zeit (%)
202
Lesezeit (%)
204
Schreibzeit (%)
206
Mittlere Sek./Übertragung
208
Mittlere Sek./Lesevorgänge
210
Mittlere Sek./Schreibvorgänge
212
Übertragungen/s
214
Lesevorgänge/s
216
Schreibvorgänge/s
218
Bytes/s
220
Bytes gelesen/s
222
Bytes geschrieben/s
224
Mittlere Bytes/Übertragung
226
Mittlere Bytes/Lesevorgang
228
Mittlere Bytes/Schreibvorgang
230
Prozess
232
Thread
234
Physikalischer Datenträger
236
Logischer Datenträger
238
Prozessor
240
Gesamtprozessorzeit (%)
242
Gesamtbenutzerzeit (%)
244
Gesamte privilegierte Zeit (%)
246
Gesamtanzahl Interrupts/s
248
Prozesse
250
Threads
252
Ereignisse
254
Semaphore
256
Mutexe
258
Abschnitte
260
Objekte
262
Redirectordienst
264
Empfangene Bytes/s
266
Empfangene Pakete/s
268
Ausgelagerte Bytes gelesen/s
270
Nicht-ausgelagerte Bytes gelesen/s
272
Cachebytes gelesen/s
274
Netzwerkbytes gelesen/s
276
Übertragene Bytes/s
278
Übertragene Pakete/s
280
Ausgelagerte Bytes geschrieben/s
282
Nicht-ausgelagerte Bytes geschrieben/s
284
Cachebytes geschrieben/s
286
Netzwerkbytes geschrieben/s
288
Lesevorgänge/s
290
Zufällige Lesevorgänge/s
292
Pakete gelesen/s
294
Große Pakete gelesen/s
296
Kleine Pakete gelesen/s
298
Schreibvorgänge/s
300
Zufällige Schreibvorgänge/s
302
Pakete geschrieben/s
304
Große Pakete geschrieben/s
306
Kleine Pakete geschrieben/s
308
Lesevorgänge verweigert/s
310
Schreibvorgänge verweigert/s
312
Netzwerkfehler/s
314
Serversitzungen
316
Erneute Serververbindungen
318
Kernverbindungen
320
Lan Manager 2.0-Verbindungen
322
Lan Manager 2.1-Verbindungen
324
Windows-Verbindungen
326
Servertrennungen
328
Nicht reagierende Serversitzungen
330
Server
336
Threadverzögerungsursache
340
Sitzungen mit Zeitüberschreitung
342
Sitzungen mit zu vielen Fehlern
344
Abgemeldete Sitzungen
346
Getrennte Sitzungen
348
Anmeldefehler
350
Zugriffsberechtigungsfehler
352
Zugriffsfehler
354
Systemfehler
356
Abgelehnte Sperranforderungen
358
Nicht genügend Arbeitselemente
360
Gesamtanzahl geöffneter Dateien
362
Geöffnete Dateien
366
Offene Suchvorgänge
370
Nicht-Auslagerungsseitenfehler
372
Nicht-Auslagerungsseiten (max.)
376
Auslagerungsseitenfehler
378
Auslagerungsseiten (max.)
388
Gesamtanzahl Bytes/s
392
Aktuelle Befehle
398
NWLink-NetBIOS
400
Pakete/s
404
Kontextblöcke in Warteschlange/s
406
Dateivorgänge/s
408
Freier Speicherplatz (%)
410
MB frei
412
Geöffnete Verbindungen
414
Verbindungen ohne Wiederholungen
416
Verbindungen mit Wiederholungen
418
Lokale Trennungen
420
Remotetrennungen
422
Verbindungsfehler
424
Adapterfehler
426
Verbindung mit Zeitüberschreitung
428
Abgebrochene Verbindungen
430
Remote-Ressourcenfehler
432
Lokaler Ressourcenfehler
434
Fehler, nicht gefunden
436
Fehler, keine Reaktion
438
Datagramme/s
440
Datagrammbytes/s
442
Datagramme gesendet/s
444
Datagrammbytes gesendet/s
446
Datagramme empfangen/s
448
Datagrammbytes empfangen/s
452
Pakete gesendet/s
456
Rahmen/s
458
Rahmenbytes/s
460
Rahmen gesendet/s
462
Rahmenbytes gesendet/s
464
Rahmen empfangen/s
466
Rahmenbytes empfangen/s
468
Rahmen erneut gesendet/s
470
Rahmenbytes erneut gesendet/s
472
Rahmen abgelehnt/s
474
Rahmenbytes abgelehnt/s
476
Reaktionen verfallen
478
Bestätigung verfallen
480
Maximales Sendefenster
482
Durchschnittliches Sendefenster
484
Piggyback-Bestätigung in Warteschlange/s
486
Piggyback-Bestätigung: Zeitüberschreitung
488
NWLink-IPX
490
NWLink-SPX
492
NetBEUI
494
NetBEUI-Ressource
496
Maximal verwendet
498
Durchschnittlich verwendet
500
Zeiten erschöpft
502
NBT-Verbindung
506
Bytes gesendet/s
508
Gesamtanzahl Bytes/s
510
Netzwerkschnittstelle
512
Bytes/s
520
Aktuelle Bandbreite
524
Unicastpakete empfangen/s
526
Nicht-Unicastpakete empfangen/s
528
Empfangene Pakete, verworfen
530
Empfangene Pakete, Fehler
532
Empfangene Pakete, unbekannt
536
Unicastpakete gesendet/s
538
Nicht-Unicastpakete gesendet/s
540
Ausgehende Pakete, verworfen
542
Ausgehende Pakete, Fehler
544
Ausgabewarteschlangenlänge
546
IPv4
548
IPv6
552
Erhaltene Datagramme, Vorspannfehler
554
Erhaltene Datagramme, Adressfehler
556
Weitergeleitete Datagramme/s
558
Empfangene Datagramme mit unbekanntem Protokoll
560
Empfangene Datagramme verworfen
562
Empfangene Datagramme übergeben/s
566
Ausgehende Datagramme verworfen
568
Ausgehende Datagramme ohne Route
570
Fragmente empfangen/s
572
Fragmente zusammengesetzt/s
574
Fragment-Zusammensetzungsfehler
576
Fragmentierte Datagramme/s
578
Fragmentierungsfehler
580
Erzeugte Fragmente/s
582
ICMP
584
Meldungen/s
586
Meldungen empfangen/s
588
Meldungen empfangen, Fehler
590
Empfangene ""Ziel nicht erreichbar""-Meldung
592
Empfangene Zeitüberschreitungsmeldungen
594
Empfangene Parameterproblemmeldungen
596
Empfangene Quelldrosselungsmeldungen
598
Empfangene umgeleitete Meldungen/s
600
Empfangene Echomeldungen/s
602
Empfangene Echoantwortmeldungen/s
604
Empfangene Zeiteintragsmeldungen/s
606
Empfangene Zeiteintragsantwortmeldungen/s
608
Empfangene Adressmaskenmeldungen
610
Empfangene Adressmaskenantwortmeldungen
612
Meldungen gesendet/s
614
Meldungen gesendet, Fehler
616
Gesendete ""Ziel nicht erreichbar""-Meldung
618
Gesendete Zeitüberschreitungsmeldungen
620
Gesendete Parameterproblemmeldungen
622
Gesendete Quelldrosselungsmeldungen
624
Gesendete umgeleitete Meldungen/s
626
Gesendete Echomeldungen/s
628
Gesendete Echoantwortmeldungen/s
630
Gesendete Zeiteintragsmeldungen/s
632
Gesendete Zeiteintragsantwortmeldungen/s
634
Gesendete Adressmaskenmeldungen
636
Gesendete Adressmaskenantwortmeldungen
638
TCPv4
640
Segmente/s
642
Hergestellte Verbindungen
644
Aktive Verbindungen
646
Passive Verbindungen
648
Verbindungsfehler
650
Zurückgesetzte Verbindungen
652
Segmente empfangen/s
654
Segmente gesendet/s
656
Erneut übertragene Segmente/s
658
UDPv4
660
Gesamte DPC-Zeit (%)
662
Gesamte Interruptzeit (%)
664
Erhaltene Datagramme, kein Port/s
666
Erhaltene Datagramme, Fehler
670
Speicherplatz
672
Zuordungsfehler
674
Systembetriebszeit
676
Systemhandleanzahl
678
Freie Seitentabelleneinträge
680
Threadanzahl
682
Basispriorität
684
Verstrichene Zeit
686
Ausrichtungskorrekturen/s
688
Ausnahmeverteilungen/s
690
Gleitkommaemulationen/s
692
Anmeldungen/s
694
Aktuelle Priorität
696
DPC-Zeit (%)
698
Interruptzeit (%)
700
Auslagerungsdatei
702
Belegung (%)
704
Maximale Belegung (%)
706
Startadresse
708
Benutzer-PC
710
Zugeordneter Speicherplatz - Kein Zugriff
712
Zugeordneter Speicherplatz - Nur Lesen
714
Zugeordneter Speicherplatz - Lesen/Schreiben
716
Zugeordneter Speicherplatz - Kopieren-beim-Schreiben
718
Zugeordneter Speicherplatz - Ausführen
720
Zugeordneter Speicherplatz - Ausführen, nur Lesen
722
Zugeordneter Speicherplatz - Ausführen, Lesen/Schreiben
724
Zugeordneter Speicherplatz - Ausführen, Kopieren-beim-Schreiben
726
Reservierter Speicherplatz - Kein Zugriff
728
Reservierter Speicherplatz - Nur Lesen
730
Reservierter Speicherplatz - Lesen/Schreiben
732
Reservierter Speicherplatz - Kopieren beim Schreiben
734
Reservierter Speicherplatz - Ausführen
736
Reservierter Speicherplatz - Ausführen, nur Lesen
738
Reservierter Speicherplatz - Ausführen, Lesen/Schreiben
740
Abbild
742
Reservierter Speicherplatz - Ausführen, Kopieren-beim-Schreiben
744
Nicht zugeordneter Speicherplatz - Kein Zugriff
746
Nicht zugeordneter Speicherplatz - Nur Lesen
748
Nicht zugeordneter Speicherplatz - Lesen/Schreiben
750
Nicht zugeordneter Speicherplatz - Kopieren-beim-Schreiben
752
Nicht zugeordneter Speicherplatz - Ausführen
754
Nicht zugeordneter Speicherplatz - Ausführen, nur Lesen
756
Nicht zugeordneter Speicherplatz - Ausführen, Lesen/Schreiben
758
Nicht zugeordneter Speicherplatz - Ausführen, Kopieren-beim-Schreiben
760
Image-Speicherplatz - Kein Zugriff
762
Image-Speicherplatz - Nur Lesen
764
Image-Speicherplatz - Lesen/Schreiben
766
Image-Speicherplatz - Kopieren-beim-Schreiben
768
Image-Speicherplatz - Ausführen
770
Image-Speicherplatz - Ausführen, nur Lesen
772
Image-Speicherplatz - Ausführen, Lesen/Schreiben
774
Image-Speicherplatz - Ausführen, Kopieren-beim-Schreiben
776
Image, reservierte Bytes
778
Image, freie Bytes
780
Reservierte Bytes
782
Freie Bytes
784
Prozesskennung
786
Prozessadressraum
788
Kein Zugriff
790
Nur Lesen
792
Lesen/Schreiben
794
Kopieren-beim-Schreiben
796
Ausführen
798
Ausführen, nur Lesen
800
Ausführen, Lesen/Schreiben
802
Ausführen, Kopieren-beim-Schreiben
804
Threadkennung
806
Mailslot-Empfangsfehler
808
Mailslot-Schreibfehler
810
Fehler beim Öffnen der Mailslots/s
812
Doppelte Hauptankündigungen
814
Unzulässige Datagramme/s
816
Threaddetails
818
Cachebytes
820
Cachebytes (max.)
822
Seiteneingabe/s
824
Übergangsseiten mit neuem Zweck/s
872
Übertragene Bytes
874
Empfangene Bytes
876
Rahmen gesendet
878
Rahmen empfangen
880
Komprimierung gesendeter Bytes (%)
882
Komprimierung empfangener Bytes (%)
884
CRC-Fehler
886
Zeitüberschreitungsfehler
888
Serieller Überlauffehler
890
Ausrichtungsfehler
892
Pufferüberlauffehler
894
Fehler insgesamt
896
Übertragene Bytes/s
898
Empfangene Bytes/s
900
Rahmen gesendet/s
902
Rahmen empfangen/s
904
Fehler insgesamt/s
908
Verbindungen insgesamt
920
WINS-Server
922
Einzelregistrierungen/s
924
Gruppenregistrierungen/s
926
Registrierungen insgesamt/s
928
Einzelerneuerungen/s
930
Gruppenerneuerungen/s
932
Erneuerungen insgesamt/s
934
Freigaben/s
936
Abfragen/s
938
Einzelkonflikte/s
940
Gruppenkonflikte/s
942
Konflikte insgesamt/s
944
Erfolgreiche Freigaben/s
946
Fehlgeschlagene Freigaben/s
948
Erfolgreiche Abfragen/s
950
Fehlgeschlagene Abfragen/s
952
Handleanzahl
1000
MacFile-Server
1002
Maximaler Auslagerungsspeicher
1004
Aktueller Auslagerungsspeicher
1006
Maximaler Nicht-Auslagerungsspeicher
1008
Aktueller Nicht-Auslagerungsspeicher
1010
Aktuelle Sitzungen
1012
Maximale Sitzungen
1014
Aktuell geöffnete Dateien
1016
Maximal geöffnete Dateien
1018
Fehlgeschlagene Anmeldungen
1020
Gelesene Daten/s
1022
Geschriebene Daten/s
1024
Erhaltene Daten/s
1026
Gesendete Daten/s
1028
Aktuelle Warteschlangenlänge
1030
Maximale Warteschlangenlänge
1032
Aktuelle Threads
1034
Maximale Threads
1050
AppleTalk
1052
Empfangene Pakete/s
1054
Gesendete Pakete/s
1056
Empfangene Bytes/s
1058
Gesendete Bytes/s
1060
Durchschnittliche Zeit/DDP-Paket
1062
DDP-Pakete/s
1064
Durchschnittliche Zeit/AARP-Paket
1066
AARP-Pakete/s
1068
Durchschnittliche Zeit/ATP-Paket
1070
ATP-Pakete/s
1072
Durchschnittliche Zeit/NBP-Paket
1074
NBP-Pakete/s
1076
Durchschnittliche Zeit/ZIP-Paket
1078
ZIP-Pakete/s
1080
Durchschnittliche Zeit/RTMP-Paket
1082
RTMP-Pakete/s
1084
Lokale ATP-Wiederholungen
1086
ATP-Antwortzeitüberschreitungen
1088
ATP-XO-Antwort/s
1090
ATP-ALO-Antwort/s
1092
Empfangene ATP-Freigaben/s
1094
Aktueller Nicht-Auslagerungsspeicher
1096
Vom Router empfangene Pakete/s
1098
Ausgelassene Pakete
1100
Netzwerk-ATP-Wiederholungen
1102
An Router gesendete Pakete/s
1110
Netzwerksegment
1112
Gesamtanzahl empfangener Rahmen/s
1114
Gesamtanzahl empfangener Bytes/s
1116
Empfangene Rundsendungsrahmen/s
1118
Empfangene Multicastrahmen/s
1120
Netzwerknutzung (%)
1124
Broadcastrahmen (%)
1126
Multicastrahmen (%)
1150
Telefonie
1152
Leitungen
1154
Telefongeräte
1156
Belegte Leitungen
1158
Aktive Telefone
1160
Ausgehende Anrufe/s
1162
Eingehende Anrufe/s
1164
Clientanwendungen
1166
Aktuelle ausgehende Anrufe
1168
Aktuelle eingehende Anrufe
1232
NCP-Leseanforderungen für Packet Burst/s
1234
Zeitüberschreitungen bei Packet Burst-Leseanforderung/s
1236
NCP-Schreibanforderungen für Packet Burst/s
1238
Zeitüberschreitungen bei Packet Burst-Schreibanforderung/s
1240
Packet Burst-E/A/s
1260
Anmeldungen insgesamt
1262
Gesamtanzahl permanenter Handles
1264
Anzahl permanenter Handles mit Verbindungswiederherstellung
1266
Hashheaderanforderungen für SMB-BranchCache
1268
Hashgenerierungsanforderungen für SMB-BranchCache
1270
Empfangene Hashanforderungen für SMB-BranchCache
1272
Gesendete Hashantworten für SMB-BranchCache
1274
Gesendete Hashbytes für SMB-BranchCache
1276
Stabile Handles gesamt
1278
Stabile Handles mit wiederhergestellter Verbindung
1300
Serverwarteschlangen
1302
Warteschlangenlänge
1304
Aktive Threads
1306
Verfügbare Threads
1308
Verfügbare Arbeitselemente
1310
Geliehene Arbeitselemente
1312
Nicht genügend Arbeitselemente
1314
Aktuelle Clients
1320
Bytes übertragen/s
1324
Bytes gelesen/s
1328
Bytes geschrieben/s
1332
Vorgänge insgesamt/s
1334
DPCs in Warteschlange/s
1336
DPC-Rate
1342
Gesamtanzahl DPCs in Warteschlange/s
1344
DPC-Rate insgesamt
1350
Max. verwendete Registrierungsgröße (%)
1360
VL-Speicher
1362
VLM - belegte virtuelle Größe (%)
1364
VLM - virtuelle Größe
1366
VLM - virtuelle Größe (max.)
1368
VLM - verfügbare virtuelle Größe
1370
VLM - festgelegter virtueller Speicher
1372
VLM - festgelegter virtueller Speicher (max.)
1374
System-VLM - festgelegter virtueller Speicher
1376
System-VLM - festgelegter virtueller Speicher (max.)
1378
System-VLM - festgelegter, gemeinsam genutzter virtueller Speicher
1380
Verfügbare KB
1382
Verfügbare MB
1400
Durchschnittl. Warteschlangenlänge des Datenträgers
1402
Durchschnittl. Warteschlangenlänge der Datenträger-Lesevorgänge
1404
Durchschnittl. Warteschlangenlänge der Datenträger-Schreibvorgänge
1406
Zugesicherte verwendete Bytes (%)
1408
Volles Image
1410
Prozesskennung erstellen
1412
E/A-Lesevorgänge/s
1414
E/A-Schreibvorgänge/s
1416
E/A-Datenvorgänge/s
1418
Andere E/A-Vorgänge/s
1420
E/A-Bytes gelesen/s
1422
E/A-Bytes geschrieben/s
1424
E/A-Datenbytes/s
1426
Andere E/A-Bytes/s
1450
Druckerwarteschlange
1452
Gesamtanzahl gedruckter Aufträge
1454
Bytes gedruckt/s
1456
Gesamtanzahl gedruckter Seiten
1458
Aufträge
1460
Referenzen
1462
Referenzenmaximum
1464
Aufträge in Warteschlange
1466
Maximale Auftragsanzahl in Warteschlange
1468
Kein Papier
1470
Nicht bereit
1472
Auftragsfehler
1474
Netzwerkdrucker aufzählen
1476
Netzwerkdrucker hinzufügen
1478
Arbeitsseiten - privat
1480
Arbeitsseiten - gemeinsam genutzt
1482
Leerlaufzeit (%)
1484
Teil-E/A/s
1500
Auftragsobjekt
1502
Aktuelle Prozessorzeit (%)
1504
Aktuelle Benutzermoduszeit (%)
1506
Aktuelle Kernelmoduszeit (%)
1508
Dieser Zeitraum (ms) - Prozessor
1510
Dieser Zeitraum (ms) - Benutzermodus
1512
Dieser Zeitraum (ms) - Kernelmodus
1514
Seiten/s
1516
Prozesse insgesamt
1518
Prozessanzahl - aktiv
1520
Prozessanzahl - abgebrochen
1522
Gesamtzeit (ms) - Prozessor
1524
Gesamtzeit (ms) - Benutzermodus
1526
Gesamtzeit (ms) - Kernelmodus
1530
TCPv6
1532
UDPv6
1534
ICMPv6
1536
Erhaltenes Paket zu groß
1538
Erhaltene Mitgliedsabfrage
1540
Erhaltener Mitgliedsbericht
1542
Erhaltene Mitgliedschaftskündigung
1544
Erhaltene Routeranfrage
1546
Erhaltene Routerankündigung
1548
Auftragsobjektdetails
1550
Erhaltene Nachbaranfrage
1552
Erhaltene Nachbarankündigung
1554
Gesendetes Paket zu groß
1556
Gesendete Mitgliedschaftsanfrage
1558
Gesendetes Mitgliedsbericht
1560
Gesendete Mitgliedschaftskündigung
1562
Gesendete Routeranfrage
1564
Gesendete Routerankündigung
1566
Gesendete Nachbaranfrage
1568
Gesendete Nachbarankündigung
1570
Systemweite Sicherheitsstatistiken
1572
NTLM-Authentifizierung
1574
Kerberos-Authentifizierungen
1576
KDC-AS-Anforderungen
1578
KDC-TGS-Anforderungen
1580
SChannel-Sitzungscacheeinträge
1582
Aktive SChannel-Sitzungscacheeinträge
1584
Clientseitige vollständige SSL-Handshakes
1586
Clientseitige SSL-Handshakes zur erneuten Verbindungsherstellung
1588
Serverseitige vollständige SSL-Handshakes
1590
Serverseitige SSL-Handshakes zur erneuten Verbindungsherstellung
1592
Digestauthentifizierung
1594
Weitergeleitete Kerberos-Anforderungen
1596
Abgeladene Verbindungen
1598
Aktive TCP-Verbindungen für RSC
1600
TCP-RSC: zusammengefügte Pakete/Sek.
1602
TCP-RSC: Ausnahmen/Sek.
1604
TCP RSC: durchschnittliche Paketgröße
1620
AS-Anforderungen mit KDC-Armoring
1622
TGS-Anforderungen mit KDC-Armoring
1624
KDC-Ansprüche unterstützende AS-Anforderungen
1626
KDC-Ansprüche unterstützende TGS-Anforderungen für vom Dienst bestätigte ID
1628
KDC-TGS-Anforderungen für klassische eingeschränkte Delegierung
1630
KDC-TGS-Anforderungen für eingeschränkte Delegierung vom Typ "resource"
1632
KDC-Ansprüche unterstützende TGS-Anforderungen
1634
/*/AS-Anforderungen für vertrauenswürdige Schlüssel von KDC
1670
Sicherheitsstatistiken pro Prozess
1672
Anmeldeinformationshandles
1674
Kontexthandles
1676
Freie und Nullseitenlisten - Bytes
1678
Geänderte Seitenliste - Bytes
1680
Standbycache-Reservebytes
1682
Standbycache- Bytes mit normaler Priorität
1684
Standbycache-Kernbytes
1686
Langfristige durchschnittliche Lebensdauer im Standbycache (Sek.)
1746
Leerlaufzeit (%)
1748
% C1-Zeit
1750
% C2-Zeit
1752
% C3-Zeit
1754
C1-Übergänge/s
1756
C2-Übergänge/s
1758
C3-Übergänge/s
1760
Heap
1762
Zugesicherte Bytes
1764
Reservierte Bytes
1766
Virtuelle Größe
1768
Freie Bytes
1770
Freie Listenlänge
1772
Durchschnittl. Zuweisungsrate
1774
Durchschnittl. freie Rate
1776
Länge des nicht zugewiesenen Bereichs
1778
Freie Zuweisungen
1780
Zwischengespeicherte Zuweisungen/s
1782
Zwischengespeicherte Bytes/s
1784
Zuweisungen <1K/s
1786
Frei <1K/s
1788
Zuweisungen 1-8K/s
1790
Frei 1-8K/s
1792
Zuweisungen über 8K/s
1794
Frei über 8K/s
1796
Zuweisungen gesamt/s
1798
Frei insgesamt/s
1800
Blöcke im Heapcache
1802
Größte Cachetiefe
1804
% Fragmentierung
1806
% VA-Fragmentierung
1808
Heapsperrungskonflikt
1810
Modifizierte Seiten
1812
Schwellenwert für modifizierte Seite
1814
Arbeitsspeicher für NUMA-Knoten
1816
MB gesamt
1818
Freie und Nullseitenlisten - MB
1820
Netzwerkadapter
1822
Standbyliste MB
1824
Verfügbare MB
1826
Hash-V2-Headeranforderungen für SMB-BranchCache
1828
Hash-V2-Generierungsanforderungen für SMB-BranchCache
1830
Empfangene Hash-V2-Anforderungen für SMB-BranchCache
1832
Gesendete Hash-V2-Antworten für SMB-BranchCache
1834
Gesendete Hash-V2-Bytes für SMB-BranchCache
1836
Hash-V2-Anforderungen für SMB-BranchCache, die von Deduplizierung verarbeitet wurden
1846
End Marker
6776
Distributed Transaction Coordinator
6778
Aktive Transaktionen
6780
Durchgeführte Transaktionen
6782
Abgebrochene Transaktionen
6784
Unsichere Transaktionen
6786
Max. aktive Transaktionen
6788
Zwangsweise durchgeführte Transaktionen
6790
Zwangsweise abgebrochene Transaktionen
6792
Antwortzeit -- Minimum
6794
Antwortzeit -- Durchschnitt
6796
Antwortzeit -- Maximum
6798
Transaktionen/Sek
6800
Durchgeführte Transaktionen/Sek.
6802
Abgebrochene Transaktionen/Sek.
6804
MSDTC Bridge 4.0.0.0
6806
Nachrichtensendefehler/Sekunde
6808
Prepare-Retry-Anzahl/Sekunde
6810
Commit-Retry-Anzahl/Sekunde
6812
Prepared-Retry-Anzahl/Sekunde
6814
Replay-Retry-Anzahl/Sekunde
6816
Anzahl der empfangenen Faults/Sekunde
6818
Anzahl der gesendeten Faults/Sekunde
6820
Durchschnittliche Zeit für Antwort eines Teilnehmers auf Prepare-Nachricht
6822
Basisindikator für die durchschnittliche Zeit für Antwort eines Teilnehmers auf Prepare-Nachricht
6824
Durchschnittliche Zeit für Antwort eines Teilnehmers auf Commit-Nachricht
6826
Basisindikator für die durchschnittliche Zeit für Antwort eines Teilnehmers auf Commit-Nachricht
6828
.NET CLR-Netzwerk
6830
Hergestellte Verbindungen
6832
Empfangene Bytes
6834
Gesendete Bytes
6836
Empfangene Datenpakete
6838
Gesendete Datenpakete
6840
.NET CLR-Daten
6842
SqlClient: Aktuelle Anzahl der Verbindungen im Pool und außerhalb des Pools
6844
SqlClient: Aktuelle Anzahl der Verbindungen im Pool
6846
SqlClient: Aktuelle Anzahl der Verbindungspools
6848
SqlClient: Maximale Anzahl der Verbindungen im Pool
6850
SqlClient: Gesamtanzahl der Verbindungsfehler
6852
SqlClient: Gesamtanzahl der Fehler bei der Befehlsausführung
6854
.NET-Datenanbieter für SqlServer
6856
HardConnectsPerSecond
6858
HardDisconnectsPerSecond
6860
SoftConnectsPerSecond
6862
SoftDisconnectsPerSecond
6864
NumberOfNonPooledConnections
6866
NumberOfPooledConnections
6868
NumberOfActiveConnectionPoolGroups
6870
NumberOfInactiveConnectionPoolGroups
6872
NumberOfActiveConnectionPools
6874
NumberOfInactiveConnectionPools
6876
NumberOfActiveConnections
6878
NumberOfFreeConnections
6880
NumberOfStasisConnections
6882
NumberOfReclaimedConnections
6884
.NET Memory Cache 4.0
6886
Cache Hits
6888
Cache Misses
6890
Cache Hit Ratio
6892
Cache Hit Ratio Base
6894
Cache Trims
6896
Cache Entries
6898
Cache Turnover Rate
6900
.NET CLR-Netzwerk 4.0.0.0
6902
Hergestellte Verbindungen
6904
Empfangene Bytes
6906
Gesendete Bytes
6908
Empfangene Datenpakete
6910
Gesendete Datenpakete
6912
Erstellte HttpWebRequests/s
6914
Durchschnittliche Dauer der HttpWebRequests
6916
Basis für durchschnittliche Lebensdauer der HttpWebRequests
6918
HttpWebRequests in Warteschlange/s
6920
Durchschnittliche Wartezeit der HttpWebRequests
6922
Basis für  durchschnittliche Warteschlangenzeit der HttpWebRequests
6924
Abgebrochene HttpWebRequests/s
6926
HttpWebRequest-Fehler/s
6928
Datenbank
6930
Defragmentierungstasks
6932
Ausstehende Defragmentierungstasks
6934
Verschobene Defragmentierungstasks
6936
Defragmentation Tasks Scheduled/sec
6938
Defragmentation Tasks Completed/sec
6940
Heap Allocs/sec
6942
Heap Frees/sec
6944
Heap Allocations
6946
Heap Bytes Allocated
6948
Page Bytes Reserved
6950
Page Bytes Committed
6952
FCB Async Scan/sec
6954
FCB Async Purge/sec
6956
FCB Async Purge Failures/sec
6958
FCB Sync Purge/sec
6960
FCB Sync Purge Stalls/sec
6962
FCB Allocations Wait For Version Cleanup/sec
6964
FCB Purge On Cursor Close/sec
6966
FCB Cache % Hit
6968
Kein Name
6970
FCB Cache Stalls/sec
6972
FCB Cache Maximum
6974
FCB Cache Preferred
6976
FCB Cache Allocated
6978
FCB Cache Allocated/sec
6980
FCB Cache Available
6982
FCB Attached RCEs
6984
Sitzungen in Verwendung
6986
Sitzungen % in Verwendung
6988
Kein Name
6990
Resource Manager FCB Allocated
6992
Resource Manager FCB Allocated Used
6994
Resource Manager FCB Quota
6996
Resource Manager FUCB Allocated
6998
Resource Manager FUCB Allocated Used
7000
Resource Manager FUCB Quota
7002
Resource Manager TDB Allocated
7004
Resource Manager TDB Allocated Used
7006
Resource Manager TDB Quota
7008
Resource Manager IDB Allocated
7010
Resource Manager IDB Allocated Used
7012
Resource Manager IDB Quota
7014
Tabelle öffnen: % Cachetreffer
7016
Kein Name
7018
Tabelle öffnen: Cachetreffer/Sek.
7020
Tabelle öffnen: Cachefehler/Sek.
7022
Table Open Pages Read/sec
7024
Table Open Pages Preread/sec
7026
Tabelle öffnen: Vorgänge/Sek.
7028
Tabelle schließen: Vorgänge/Sek.
7030
Geöffnete Tabellen
7032
Protokoll: Geschriebene Bytes/Sek.
7034
Generierte Protokollbytes/Sek.
7036
Log Buffer Bytes Used
7038
Log Buffer Bytes Free
7040
Übergebene Bytes im Protokollpuffer
7042
Wartende Protokollthreads
7044
Log Checkpoint Depth
7046
Log Generation Checkpoint Depth
7048
Log Checkpoint Maintenance Outstanding IO Max
7050
User Read Only Transaction Commits to Level 0/sec
7052
User Read/Write Transaction Commits to Level 0 (Durable)/sec
7054
User Read/Write Transaction Commits to Level 0 (Lazy)/sec
7056
User Wait All Transaction Commits/sec
7058
User Wait Last Transaction Commits/sec
7060
User Transaction Commits to Level 0/sec
7062
User Read Only Transaction Rollbacks to Level 0/sec
7064
User Read/Write Transaction Rollbacks to Level 0/sec
7066
User Transaction Rollbacks to Level 0/sec
7068
System Read Only Transaction Commits to Level 0/sec
7070
System Read/Write Transaction Commits to Level 0 (Durable)/sec
7072
System Read/Write Transaction Commits to Level 0 (Lazy)/sec
7074
System Transaction Commits to Level 0/sec
7076
System Read Only Transaction Rollbacks to Level 0/sec
7078
System Read/Write Transaction Rollbacks to Level 0/sec
7080
System Transaction Rollbacks to Level 0/sec
7082
Recovery Stalls for Read-only Transactions/sec
7084
Recovery Long Stalls for Read-only Transactions/sec
7086
Recovery Stalls for Read-only Transactions (ms)/sec
7088
Recovery Throttles For IO Smoothing/sec
7090
Recovery Throttles For IO Smoothing Time (ms)/sec
7092
Database Page Allocation File Extension Stalls/sec
7094
Log Records/sec
7096
Log Buffer Capacity Writes/sec
7098
Log Buffer Commit Writes/sec
7100
Log Buffer Writes Skipped/sec
7102
Log Buffer Writes Blocked/sec
7104
Protokollschreibvorgänge/Sek.
7106
Log Full Segment Writes/sec
7108
Log Partial Segment Writes/sec
7110
Log Bytes Wasted/sec
7112
Protokolldatensatzverzögerungen/Sek.
7114
Zugewiesene Versionsbuckets
7116
Version Buckets Allocated for Deletes
7118
VER Bucket Allocations Wait For Version Cleanup/sec
7120
Version Store Average RCE Bookmark Length
7122
Version Store Unnecessary Calls/sec
7124
Version Store Cleanup Tasks Asynchronously Dispatched/sec
7126
Version Store Cleanup Tasks Synchronously Dispatched/sec
7128
Version Store Cleanup Tasks Discarded/sec
7130
Version Store Cleanup Tasks Failures/sec
7132
Record Inserts/sec
7134
Record Deletes/sec
7136
Record Replaces/sec
7138
Record Unnecessary Replaces/sec
7140
Record Redundant Replaces/sec
7142
Record Escrow-Updates/sec
7144
Secondary Index Inserts/sec
7146
Secondary Index Deletes/sec
7148
False Index Column Updates/sec
7150
False Tuple Index Column Updates/sec
7152
Record Intrinsic Long-Values Updated/sec
7154
Record Separated Long-Values Added/sec
7156
Record Separated Long-Values Forced/sec
7158
Record Separated Long-Values All Forced/sec
7160
Record Separated Long-Values Reference All/sec
7162
Record Separated Long-Values Dereference All/sec
7164
Separated Long-Value Seeks/sec
7166
Separated Long-Value Retrieves/sec
7168
Separated Long-Value Creates/sec
7170
Long-Value Maximum LID
7172
Separated Long-Value Updates/sec
7174
Separated Long-Value Deletes/sec
7176
Separated Long-Value Copies/sec
7178
Separated Long-Value Chunk Seeks/sec
7180
Separated Long-Value Chunk Retrieves/sec
7182
Separated Long-Value Chunk Appends/sec
7184
Separated Long-Value Chunk Replaces/sec
7186
Separated Long-Value Chunk Deletes/sec
7188
Separated Long-Value Chunk Copies/sec
7190
B+ Tree Append Splits/sec
7192
B+ Tree Right Splits/sec
7194
B+ Tree Right Hotpoint Splits/sec
7196
B+ Tree Vertical Splits/sec
7198
B+ Tree Splits/sec
7200
B+ Tree Empty Page Merges/sec
7202
B+ Tree Right Merges/sec
7204
B+ Tree Partial Merges/sec
7206
B+ Tree Left Merges/sec
7208
B+ Tree Partial Left Merges/sec
7210
B+ Tree Page Moves/sec
7212
B+ Tree Merges/sec
7214
B+ Tree Failed Simple Page Cleanup Attempts/sec
7216
B+ Tree Seek Short Circuits/sec
7218
B+ Tree Opportune Prereads/sec
7220
B+ Tree Unnecessary Sibling Latches/sec
7222
B+ Tree Move Nexts/sec
7224
B+ Tree Move Nexts (Non-Visible Nodes Skipped)/sec
7226
B+ Tree Move Nexts (Nodes Filtered)/sec
7228
B+ Tree Move Prevs/sec
7230
B+ Tree Move Prevs (Non-Visible Nodes Skipped)/sec
7232
B+ Tree Move Prevs (Nodes Filtered)/sec
7234
B+ Tree Seeks/sec
7236
B+ Tree Inserts/sec
7238
B+ Tree Replaces/sec
7240
B+ Tree Flag Deletes/sec
7242
B+ Tree Deletes/sec
7244
B+ Tree Appends/sec
7246
Pages Trimmed/sec
7248
Pages Not Trimmed Unaligned/sec
7250
Datenbankcachefehler/Sek.
7252
Datenbankcache % Treffer
7254
Kein Name
7256
Database Cache % Hit (Unique)
7258
No name
7260
Database Cache Requests/sec (Unique)
7262
Datenbankcacheanforderungen/Sek.
7264
Database Cache % Pinned
7266
Kein Name
7268
Database Cache % Clean
7270
Kein Name
7272
Database Pages Read Async/sec
7274
Database Pages Read Sync/sec
7276
Database Pages Dirtied/sec
7278
Database Pages Dirtied (Repeatedly)/sec
7280
Database Pages Written/sec
7282
Database Opportune Write Issued (Total)
7284
Database Pages Transferred/sec
7286
Database Pages Non-Resident Trimmed by OS/sec
7288
Database Pages Non-Resident Reclaimed (Soft Faulted)/sec
7290
Database Pages Non-Resident Reclaimed (Failed)/sec
7292
Database Pages Non-Resident Re-read/sec
7294
Database Pages Non-Resident Evicted (Normally)/sec
7296
Database Pages Non-Resident Reclaimed (Hard Faulted)/sec
7298
Database Pages Non-Resident Hard Faulted In Latency (us)/sec
7300
Database Page Latches/sec
7302
Database Page Fast Latches/sec
7304
Database Page Bad Latch Hints/sec
7306
Database Cache % Fast Latch
7308
Kein Name
7310
Database Pages Colded (Ext)/sec
7312
Database Pages Colded (Int)/sec
7314
Database Page Latch Conflicts/sec
7316
Database Page Latch Stalls/sec
7318
Database Cache % Available
7320
Kein Name
7322
Datenbank: Seitenfehler/Sek.
7324
Datenbank: Erzwungene Seitenfreigaben/Sek.
7326
Database Page Evictions (Preread Untouched)/sec
7328
Database Page Evictions (k=1)/sec
7330
Database Page Evictions (k=2)/sec
7332
Database Page Evictions (Scavenging.AvailPool)/sec
7334
Database Page Evictions (Scavenging.SuperCold.Int)/sec
7336
Database Page Evictions (Scavenging.SuperCold.Ext)/sec
7338
Database Page Evictions (Scavenging.Shrink)/sec
7340
Database Page Evictions (Other)/sec
7342
Datenbank: Seitenfehlerverzögerungen/Sek.
7344
Datenbankcachegröße (MB)
7346
Datenbank: Cachegröße
7348
Datenbankcache: Effektive Größe (MB)
7350
Datenbankcache: Effektive Größe
7352
Datenbankcache: Zugesicherter Arbeitsspeicher (MB)
7354
Datenbankcache: Zugesicherter Arbeitsspeicher
7356
Datenbankcache: Reservierter Arbeitsspeicher (MB)
7358
Datenbankcache: Reservierter Arbeitsspeicher
7360
Database Cache Size Target (MB)
7362
Database Cache Size Target
7364
Database Cache Size Min
7366
Database Cache Size Max
7368
Datenbankcache: Residente Größe
7370
Datenbankcache: Residente Größe (MB)
7372
Database Cache Size Unattached (MB)
7374
Database Cache Sizing Duration
7376
Database Cache % Available Min
7378
Kein Name
7380
Database Cache % Available Max
7382
Kein Name
7384
Database Pages Preread/sec
7386
Database Page Preread Stalls/sec
7388
Database Pages Preread (Unnecessary)/sec
7390
Database Pages Dehydrated/sec
7392
Database Pages Rehydrated/sec
7394
Database Pages Versioned/sec
7396
Database Pages Version Copied/sec
7398
Database Cache % Versioned
7400
Kein Name
7402
Database Pages Repeatedly Written/sec
7404
Database Pages Flushed (Scavenging.Shrink)/sec
7406
Database Pages Flushed (Checkpoint)/sec
7408
Database Pages Flushed (Checkpoint Foreground)/sec
7410
Database Pages Flushed (Context Flush)/sec
7412
Database Pages Flushed (Filthy Foreground)/sec
7414
Database Pages Flushed (Scavenging.AvailPool)/sec
7416
Database Pages Flushed (Scavenging.SuperCold.Int)/sec
7418
Database Pages Flushed (Scavenging.SuperCold.Ext)/sec
7420
Database Pages Flushed Opportunely/sec
7422
Database Pages Flushed Opportunely Clean/sec
7424
Database Pages Coalesced Written/sec
7426
Database Pages Coalesced Read/sec
7428
Database Cache Lifetime
7430
Database Cache Lifetime (Smooth)
7432
Database Cache Lifetime (Max)
7434
Database Cache Lifetime Estimate Variance
7436
Database Cache Lifetime (K1)
7438
Database Cache Lifetime (K2)
7440
Database Cache Scan Pages Evaluated/sec
7442
Database Cache Scan Pages Moved/sec
7444
Database Cache Scan Page Evaluated Out-of-Order/sec
7446
Kein Name
7448
Database Cache Scan Entries/scan
7450
Database Cache Scan Buckets Scanned/scan
7452
Database Cache Scan Empty Buckets Scanned/scan
7454
Database Cache Scan ID Range/scan
7456
Database Cache Scan Time (ms)/scan
7458
Database Cache Scan Found-to-Evict Range
7460
Database Cache Super Colded Resources
7462
Database Cache Super Cold Attempts/sec
7464
Database Cache Super Cold Successes/sec
7466
Database Page History Records
7468
Database Page History % Hit
7470
Kein Name
7472
Database Cache % Resident
7474
Kein Name
7476
Datenbankcache: % komprimierte Seiten
7478
Kein Name
7480
Database Pages Repeatedly Read/sec
7482
Streaming Backup Pages Read/sec
7484
Online Defrag Pages Read/sec
7486
Online Defrag Pages Preread/sec
7488
Online Defrag Pages Dirtied/sec
7490
Online Defrag Pages Freed/sec
7492
Online Defrag Data Moves/sec
7494
Online Defrag Pages Moved/sec
7496
Online Defrag Log Bytes/sec
7498
Datenbankwartung: Dauer seit letzter
7500
Database Maintenance Pages Read
7502
Database Maintenance Pages Read/sec
7504
Database Maintenance Pages Zeroed
7506
Database Maintenance Pages Zeroed/sec
7508
Database Maintenance Zero Ref Count LVs Deleted
7510
Database Maintenance Pages with Flag Deleted LVs Reclaimed
7512
Database Maintenance IO Reads/sec
7514
Database Maintenance IO Reads Average Bytes
7516
Kein Name
7518
Database Maintenance IO Re-Reads/sec
7520
Database Tasks Pages Referenced/sec
7522
Database Tasks Pages Read/sec
7524
Database Tasks Pages Preread/sec
7526
Database Tasks Pages Dirtied/sec
7528
Database Tasks Pages Re-Dirtied/sec
7530
Database Tasks Log Records/sec
7532
Database Tasks Average Log Bytes
7534
Kein Name
7536
Database Tasks Log Bytes/sec
7538
E/A: Datenbanklesevorgänge (Angefügt)/Sek.
7540
E/A: Durchschnittliche Wartezeit für Datenbanklesevorgänge (Angefügt)
7542
Kein Name
7544
I/O Database Reads (Attached) Average Bytes
7546
Kein Name
7548
I/O Database Reads (Attached) In Heap
7550
I/O Database Reads (Attached) Async Pending
7552
E/A: Datenbanklesevorgänge (Wiederherstellung)/Sek.
7554
E/A: Durchschnittliche Wartezeit für Datenbanklesevorgänge (Wiederherstellung)
7556
Kein Name
7558
I/O Database Reads (Recovery) Average Bytes
7560
Kein Name
7562
I/O Database Reads (Recovery) In Heap
7564
I/O Database Reads (Recovery) Async Pending
7566
E/A: Datenbanklesevorgänge/Sek.
7568
E/A: Durchschnittliche Wartezeit für Datenbanklesevorgänge
7570
Kein Name
7572
I/O Database Reads Average Bytes
7574
Kein Name
7576
I/O Database Reads In Heap
7578
I/O Database Reads Async Pending
7580
E/A: Protokolllesevorgänge/Sek.
7582
E/A: Durchschnittliche Wartezeit für Protokolllesevorgänge
7584
Kein Name
7586
I/O Log Reads Average Bytes
7588
Kein Name
7590
I/O Log Reads In Heap
7592
I/O Log Reads Async Pending
7594
E/A: Datenbankschreibvorgänge (Angefügt)/Sek.
7596
E/A: Durchschnittliche Wartezeit für Datenbankschreibvorgänge (Angefügt)
7598
Kein Name
7600
I/O Database Writes (Attached) Average Bytes
7602
Kein Name
7604
I/O Database Writes (Attached) In Heap
7606
I/O Database Writes (Attached) Async Pending
7608
E/A: Datenbankschreibvorgänge (Wiederherstellung)/Sek.
7610
E/A: Durchschnittliche Wartezeit für Datenbankschreibvorgänge (Wiederherstellung)
7612
Kein Name
7614
I/O Database Writes (Recovery) Average Bytes
7616
Kein Name
7618
I/O Database Writes (Recovery) In Heap
7620
I/O Database Writes (Recovery) Async Pending
7622
E/A: Datenbankschreibvorgänge/Sek.
7624
E/A: Durchschnittliche Wartezeit für Datenbankschreibvorgänge
7626
Kein Name
7628
I/O Database Writes Average Bytes
7630
Kein Name
7632
I/O Database Writes In Heap
7634
I/O Database Writes Async Pending
7636
E/A: Leerungszuordnungs-Schreibvorgänge/Sek.
7638
E/A: Durchschnittliche Wartezeit für Leerungszuordnungs-Schreibvorgänge
7640
Kein Name
7642
E/A: Durchschnittliche Bytes bei Leerungszuordnungs-Schreibvorgängen
7644
Kein Name
7646
E/A: Protokollschreibvorgänge/Sek.
7648
E/A: Durchschnittliche Wartezeit für Protokollschreibvorgänge
7650
Kein Name
7652
I/O Log Writes Average Bytes
7654
Kein Name
7656
I/O Log Writes In Heap
7658
I/O Log Writes Async Pending
7660
FlushFileBuffers ops/sec
7662
FlushFileBuffers Average Latency
7664
No name
7666
Threads Blocked/sec
7668
Threads Blocked
7670
Verschlüsselungsbytes/Sek.
7672
Verschlüsselungsvorgänge/Sek.
7674
Encryption average latency (us)
7676
Kein Name
7678
Entschlüsselungsbytes/Sek.
7680
Entschlüsselungsvorgänge/Sek.
7682
Decryption average latency (us)
7684
Kein Name
7686
Pages Reorganized (Other)/sec
7688
Pages Reorganized (Free Space Request)/sec
7690
Pages Reorganized (Page Move Logging)/sec
7692
Pages Reorganized (Dehydrate Buffer)/sec
7694
Program Marker
7696
Mittlere Wartezeit bei Datenbank-Cachefehlern (Anhängend)
7698
Kein Name
7700
Database Cache Size Unused
7702
Datenbank ==> TableClasses
7704
Record Inserts/sec
7706
Record Deletes/sec
7708
Record Replaces/sec
7710
Record Unnecessary Replaces/sec
7712
Record Redundant Replaces/sec
7714
Record Escrow-Updates/sec
7716
Secondary Index Inserts/sec
7718
Secondary Index Deletes/sec
7720
False Index Column Updates/sec
7722
False Tuple Index Column Updates/sec
7724
Record Intrinsic Long-Values Updated/sec
7726
Record Separated Long-Values Added/sec
7728
Record Separated Long-Values Forced/sec
7730
Record Separated Long-Values All Forced/sec
7732
Record Separated Long-Values Reference All/sec
7734
Record Separated Long-Values Dereference All/sec
7736
Separated Long-Value Seeks/sec
7738
Separated Long-Value Retrieves/sec
7740
Separated Long-Value Creates/sec
7742
Long-Value Maximum LID
7744
Separated Long-Value Updates/sec
7746
Separated Long-Value Deletes/sec
7748
Separated Long-Value Copies/sec
7750
Separated Long-Value Chunk Seeks/sec
7752
Separated Long-Value Chunk Retrieves/sec
7754
Separated Long-Value Chunk Appends/sec
7756
Separated Long-Value Chunk Replaces/sec
7758
Separated Long-Value Chunk Deletes/sec
7760
Separated Long-Value Chunk Copies/sec
7762
B+ Tree Append Splits/sec
7764
B+ Tree Right Splits/sec
7766
B+ Tree Right Hotpoint Splits/sec
7768
B+ Tree Vertical Splits/sec
7770
B+ Tree Splits/sec
7772
B+ Tree Empty Page Merges/sec
7774
B+ Tree Right Merges/sec
7776
B+ Tree Partial Merges/sec
7778
B+ Tree Left Merges/sec
7780
B+ Tree Partial Left Merges/sec
7782
B+ Tree Page Moves/sec
7784
B+ Tree Merges/sec
7786
B+ Tree Failed Simple Page Cleanup Attempts/sec
7788
B+ Tree Seek Short Circuits/sec
7790
B+ Tree Opportune Prereads/sec
7792
B+ Tree Unnecessary Sibling Latches/sec
7794
B+ Tree Move Nexts/sec
7796
B+ Tree Move Nexts (Non-Visible Nodes Skipped)/sec
7798
B+ Tree Move Nexts (Nodes Filtered)/sec
7800
B+ Tree Move Prevs/sec
7802
B+ Tree Move Prevs (Non-Visible Nodes Skipped)/sec
7804
B+ Tree Move Prevs (Nodes Filtered)/sec
7806
B+ Tree Seeks/sec
7808
B+ Tree Inserts/sec
7810
B+ Tree Replaces/sec
7812
B+ Tree Flag Deletes/sec
7814
B+ Tree Deletes/sec
7816
B+ Tree Appends/sec
7818
Database Pages Preread Untouched/sec
7820
Database Page Evictions (k=1)/sec
7822
Database Page Evictions (k=2)/sec
7824
Database Page Evictions (Scavenging.AvailPool)/sec
7826
Database Page Evictions (Scavenging.Shrink)/sec
7828
Database Page Evictions (Other)/sec
7830
Datenbankcachegröße (MB)
7832
Datenbank: Cachegröße
7834
Datenbankcachefehler/Sek.
7836
Datenbankcache % Treffer
7838
Kein Name
7840
Database Cache % Hit (Unique)
7842
No name
7844
Database Cache Requests/sec (Unique)
7846
Datenbankcacheanforderungen/Sek.
7848
Database Pages Read Async/sec
7850
Database Pages Read Sync/sec
7852
Database Pages Dirtied/sec
7854
Database Pages Dirtied (Repeatedly)/sec
7856
Database Pages Written/sec
7858
Database Pages Transferred/sec
7860
Database Pages Colded (Ext)/sec
7862
Database Pages Colded (Int)/sec
7864
Database Pages Preread/sec
7866
Database Page Preread Stalls/sec
7868
Database Pages Preread (Unnecessary)/sec
7870
Database Pages Dehydrated/sec
7872
Database Pages Rehydrated/sec
7874
Database Pages Versioned/sec
7876
Database Pages Version Copied/sec
7878
Database Pages Repeatedly Written/sec
7880
Database Pages Flushed (Scavenging.Shrink)/sec
7882
Database Pages Flushed (Checkpoint)/sec
7884
Database Pages Flushed (Checkpoint Foreground)/sec
7886
Database Pages Flushed (Context Flush)/sec
7888
Database Pages Flushed (Filthy Foreground)/sec
7890
Database Pages Flushed (Scavenging.AvailPool)/sec
7892
Database Pages Flushed Opportunely/sec
7894
Database Pages Flushed Opportunely Clean/sec
7896
Database Pages Coalesced Written/sec
7898
Database Pages Coalesced Read/sec
7900
Database Pages Repeatedly Read/sec
7902
FCB Async Scan/sec
7904
FCB Async Purge/sec
7906
FCB Async Threshold Purge Failures/sec
7908
Table Open Pages Read/sec
7910
Table Open Pages Preread/sec
7912
Mittlere Wartezeit bei Datenbank-Cachefehlern (Anhängend)
7914
Kein Name
7916
Database Cache Size Unused
7918
Verschlüsselungsbytes/Sek.
7920
Verschlüsselungsvorgänge/Sek.
7922
Encryption average latency (us)
7924
Kein Name
7926
Entschlüsselungsbytes/Sek.
7928
Entschlüsselungsvorgänge/Sek.
7930
Decryption average latency (us)
7932
Kein Name
7934
Datenbank ==> Instanzen
7936
Defragmentierungstasks
7938
Ausstehende Defragmentierungstasks
7940
Verschobene Defragmentierungstasks
7942
Defragmentation Tasks Scheduled/sec
7944
Defragmentation Tasks Completed/sec
7946
FCB Async Scan/sec
7948
FCB Async Purge/sec
7950
FCB Async Threshold Purge Failures/sec
7952
FCB Sync Purge/sec
7954
FCB Sync Purge Stalls/sec
7956
FCB Allocations Wait For Version Cleanup/sec
7958
FCB Purge On Cursor Close/sec
7960
FCB Cache % Hit
7962
Kein Name
7964
FCB Cache Stalls/sec
7966
FCB Cache Maximum
7968
FCB Cache Preferred
7970
FCB Cache Allocated
7972
FCB Cache Allocated/sec
7974
FCB Cache Available
7976
FCB Cache Allocations Failed
7978
FCB Cache Allocation Average Latency (ms)
7980
Kein Name
7982
FCB Attached RCEs
7984
Sitzungen in Verwendung
7986
Sitzungen % in Verwendung
7988
Kein Name
7990
Tabelle öffnen: % Cachetreffer
7992
Kein Name
7994
Tabelle öffnen: Cachetreffer/Sek.
7996
Tabelle öffnen: Cachefehler/Sek.
7998
Table Open Pages Read/sec
8000
Table Open Pages Preread/sec
8002
Tabelle öffnen: Vorgänge/Sek.
8004
Tabelle schließen: Vorgänge/Sek.
8006
Geöffnete Tabellen
8008
Protokoll: Schreiben Bytes/Sek.
8010
Generierte Protokollbytes/Sek.
8012
Log Buffer Size
8014
Log Buffer Bytes Used
8016
Log Buffer Bytes Free
8018
Übergebene Bytes im Protokollpuffer
8020
Wartende Protokollthreads
8022
Log File Size
8024
Log Checkpoint Depth
8026
Prüfpunkttiefe für Protokollgenerierung
8028
Datenbankkonsistenztiefe für Protokollgenerierung
8030
Log Checkpoint Maintenance Outstanding IO Max
8032
Zielprüfpunkttiefe für Protokollgenerierung
8034
Protokollprüfpunkttiefe in % der Zieltiefe
8036
Kein Name
8038
Max. Prüfpunkttiefe für Protokollgenerierung
8040
Verlustausfalltiefe für Protokollgenerierung
8042
Generierte Protokolldateien
8044
Vorzeitig generierte Protokolldateien
8046
Aktuelle Protokolldateigenerierung
8048
User Read Only Transaction Commits to Level 0/sec
8050
User Read/Write Transaction Commits to Level 0 (Durable)/sec
8052
User Read/Write Transaction Commits to Level 0 (Lazy)/sec
8054
User Wait All Transaction Commits/sec
8056
User Wait Last Transaction Commits/sec
8058
User Transaction Commits to Level 0/sec
8060
User Read Only Transaction Rollbacks to Level 0/sec
8062
User Read/Write Transaction Rollbacks to Level 0/sec
8064
User Transaction Rollbacks to Level 0/sec
8066
System Read Only Transaction Commits to Level 0/sec
8068
System Read/Write Transaction Commits to Level 0 (Durable)/sec
8070
System Read/Write Transaction Commits to Level 0 (Lazy)/sec
8072
System Transaction Commits to Level 0/sec
8074
System Read Only Transaction Rollbacks to Level 0/sec
8076
System Read/Write Transaction Rollbacks to Level 0/sec
8078
System Transaction Rollbacks to Level 0/sec
8080
Recovery Stalls for Read-only Transactions/sec
8082
Recovery Long Stalls for Read-only Transactions/sec
8084
Recovery Stalls for Read-only Transactions (ms)/sec
8086
Recovery Throttles For IO Smoothing/sec
8088
Recovery Throttles For IO Smoothing Time (ms)/sec
8090
Database Page Allocation File Extension Stalls/sec
8092
Log Records/sec
8094
Log Buffer Capacity Writes/sec
8096
Log Buffer Commit Writes/sec
8098
Log Buffer Writes Skipped/sec
8100
Log Buffer Writes Blocked/sec
8102
Protokollschreibvorgänge/Sek.
8104
Log Full Segment Writes/sec
8106
Log Partial Segment Writes/sec
8108
Log Bytes Wasted/sec
8110
Protokolldatensatzverzögerungen/Sek.
8112
Zugewiesene Versionsbuckets
8114
Version buckets allocated for deletes
8116
VER Bucket Allocations Wait For Version Cleanup/sec
8118
Version store average RCE bookmark length
8120
Version store unnecessary calls/sec
8122
Version store cleanup tasks asynchronously dispatched/sec
8124
Version store cleanup tasks synchronously dispatched/sec
8126
Version store cleanup tasks discarded/sec
8128
Version store cleanup tasks failures/sec
8130
Record Inserts/sec
8132
Record Deletes/sec
8134
Record Replaces/sec
8136
Record Unnecessary Replaces/sec
8138
Record Redundant Replaces/sec
8140
Record Escrow-Updates/sec
8142
Secondary Index Inserts/sec
8144
Secondary Index Deletes/sec
8146
False Index Column Updates/sec
8148
False Tuple Index Column Updates/sec
8150
Record Intrinsic Long-Values Updated/sec
8152
Record Separated Long-Values Added/sec
8154
Record Separated Long-Values Forced/sec
8156
Record Separated Long-Values All Forced/sec
8158
Record Separated Long-Values Reference All/sec
8160
Record Separated Long-Values Dereference All/sec
8162
Separated Long-Value Seeks/sec
8164
Separated Long-Value Retrieves/sec
8166
Separated Long-Value Creates/sec
8168
Long-Value Maximum LID
8170
Separated Long-Value Updates/sec
8172
Separated Long-Value Deletes/sec
8174
Separated Long-Value Copies/sec
8176
Separated Long-Value Chunk Seeks/sec
8178
Separated Long-Value Chunk Retrieves/sec
8180
Separated Long-Value Chunk Appends/sec
8182
Separated Long-Value Chunk Replaces/sec
8184
Separated Long-Value Chunk Deletes/sec
8186
Separated Long-Value Chunk Copies/sec
8188
B+ Tree Append Splits/sec
8190
B+ Tree Right Splits/sec
8192
B+ Tree Right Hotpoint Splits/sec
8194
B+ Tree Vertical Splits/sec
8196
B+ Tree Splits/sec
8198
B+ Tree Empty Page Merges/sec
8200
B+ Tree Right Merges/sec
8202
B+ Tree Partial Merges/sec
8204
B+ Tree Left Merges/sec
8206
B+ Tree Partial Left Merges/sec
8208
B+ Tree Page Moves/sec
8210
B+ Tree Merges/sec
8212
B+ Tree Failed Simple Page Cleanup Attempts/sec
8214
B+ Tree Seek Short Circuits/sec
8216
B+ Tree Opportune Prereads/sec
8218
B+ Tree Unnecessary Sibling Latches/sec
8220
B+ Tree Move Nexts/sec
8222
B+ Tree Move Nexts (Non-Visible Nodes Skipped)/sec
8224
B+ Tree Move Nexts (Nodes Filtered)/sec
8226
B+ Tree Move Prevs/sec
8228
B+ Tree Move Prevs (Non-Visible Nodes Skipped)/sec
8230
B+ Tree Move Prevs (Nodes Filtered)/sec
8232
B+ Tree Seeks/sec
8234
B+ Tree Inserts/sec
8236
B+ Tree Replaces/sec
8238
B+ Tree Flag Deletes/sec
8240
B+ Tree Deletes/sec
8242
B+ Tree Appends/sec
8244
Pages Trimmed/sec
8246
Pages Not Trimmed Unaligned/sec
8248
Database Pages Preread Untouched/sec
8250
Database Page Evictions (k=1)/sec
8252
Database Page Evictions (k=2)/sec
8254
Database Page Evictions (Scavenging.AvailPool)/sec
8256
Database Page Evictions (Scavenging.Shrink)/sec
8258
Database Page Evictions (Other)/sec
8260
Datenbankcachegröße (MB)
8262
Datenbankcachefehler/Sek.
8264
Datenbankcache % Treffer
8266
Kein Name
8268
Database Cache % Hit (Unique)
8270
No name
8272
Database Cache Requests/sec (Unique)
8274
Datenbankcacheanforderungen/Sek.
8276
Instance Status
8278
Database Pages Read Async/sec
8280
Database Pages Read Sync/sec
8282
Database Pages Dirtied/sec
8284
Database Pages Dirtied (Repeatedly)/sec
8286
Database Pages Written/sec
8288
Database Pages Transferred/sec
8290
Database Pages Colded (Ext)/sec
8292
Database Pages Colded (Int)/sec
8294
Database Pages Preread/sec
8296
Database Page Preread Stalls/sec
8298
Database Pages Preread (Unnecessary)/sec
8300
Database Pages Dehydrated/sec
8302
Database Pages Rehydrated/sec
8304
Database Pages Versioned/sec
8306
Database Pages Version Copied/sec
8308
Database Pages Repeatedly Written/sec
8310
Database Pages Flushed (Scavenging.Shrink)/sec
8312
Database Pages Flushed (Checkpoint)/sec
8314
Database Pages Flushed (Checkpoint Foreground)/sec
8316
Database Pages Flushed (Context Flush)/sec
8318
Database Pages Flushed (Filthy Foreground)/sec
8320
Database Pages Flushed (Scavenging.AvailPool)/sec
8322
Database Pages Flushed Opportunely/sec
8324
Database Pages Flushed Opportunely Clean/sec
8326
Database Pages Coalesced Written/sec
8328
Database Pages Coalesced Read/sec
8330
Database Pages Repeatedly Read/sec
8332
Leerungszuordnung % geändert
8334
Kein Name
8336
Asynchron geschriebene Leerungszuordnungsseiten/Sek.
8338
Synchron geschriebene Leerungszuordnungsseiten/Sek.
8340
Streamingsicherung: Gelesene Seiten/Sek.
8342
Online Defrag Pages Read/sec
8344
Online Defrag Pages Preread/sec
8346
Online Defrag Pages Dirtied/sec
8348
Online Defrag Pages Freed/sec
8350
Online Defrag Data Moves/sec
8352
Online Defrag Pages Moved/sec
8354
Online Defrag Log Bytes/sec
8356
Datenbankwartung: Dauer seit letzter
8358
Database Maintenance Pages Read
8360
Database Maintenance Pages Read/sec
8362
Database Maintenance Pages Zeroed
8364
Database Maintenance Pages Zeroed/sec
8366
Database Maintenance Zero Ref Count LVs Deleted
8368
Database Maintenance Pages with Flag Deleted LVs Reclaimed
8370
Database Maintenance IO Reads/sec
8372
Database Maintenance IO Reads Average Bytes
8374
Kein Name
8376
Database Maintenance Throttle Setting
8378
Database Maintenance IO Re-Reads/sec
8380
Database Maintenance Pages Skipped by Recovery
8382
Database Maintenance Pages Skipped by Recovery/sec
8384
Database Maintenance Pages Checked for Divergences
8386
Database Maintenance Pages Checked for Divergences/sec
8388
Database Tasks Pages Referenced/sec
8390
Database Tasks Pages Read/sec
8392
Database Tasks Pages Preread/sec
8394
Database Tasks Pages Dirtied/sec
8396
Database Tasks Pages Re-Dirtied/sec
8398
Database Tasks Log Records/sec
8400
Database Tasks Average Log Bytes
8402
Kein Name
8404
Database Tasks Log Bytes/sec
8406
E/A: Datenbanklesevorgänge (Angefügt)/Sek.
8408
E/A: Durchschnittliche Wartezeit für Datenbanklesevorgänge (Angefügt)
8410
Kein Name
8412
I/O Database Reads (Attached) Average Bytes
8414
Kein Name
8416
I/O Database Reads (Attached) In Heap
8418
I/O Database Reads (Attached) Async Pending
8420
E/A: Datenbanklesevorgänge (Wiederherstellung)/Sek.
8422
E/A: Durchschnittliche Wartezeit für Datenbanklesevorgänge (Wiederherstellung)
8424
Kein Name
8426
I/O Database Reads (Recovery) Average Bytes
8428
Kein Name
8430
I/O Database Reads (Recovery) In Heap
8432
I/O Database Reads (Recovery) Async Pending
8434
E/A: Datenbanklesevorgänge/Sek.
8436
E/A: Durchschnittliche Wartezeit für Datenbanklesevorgänge
8438
Kein Name
8440
I/O Database Reads Average Bytes
8442
Kein Name
8444
I/O Database Reads In Heap
8446
I/O Database Reads Async Pending
8448
E/A: Protokolllesevorgänge/Sek.
8450
E/A: Durchschnittliche Wartezeit für Protokolllesevorgänge
8452
Kein Name
8454
I/O Log Reads Average Bytes
8456
Kein Name
8458
I/O Log Reads In Heap
8460
I/O Log Reads Async Pending
8462
E/A: Datenbankschreibvorgänge (Angefügt)/Sek.
8464
E/A: Durchschnittliche Wartezeit für Datenbankschreibvorgänge (Angefügt)
8466
Kein Name
8468
I/O Database Writes (Attached) Average Bytes
8470
Kein Name
8472
I/O Database Writes (Attached) In Heap
8474
I/O Database Writes (Attached) Async Pending
8476
E/A: Datenbankschreibvorgänge (Wiederherstellung)/Sek.
8478
E/A: Durchschnittliche Wartezeit für Datenbankschreibvorgänge (Wiederherstellung)
8480
Kein Name
8482
I/O Database Writes (Recovery) Average Bytes
8484
Kein Name
8486
I/O Database Writes (Recovery) In Heap
8488
I/O Database Writes (Recovery) Async Pending
8490
E/A: Datenbankschreibvorgänge/Sek.
8492
E/A: Durchschnittliche Wartezeit für Datenbankschreibvorgänge
8494
Kein Name
8496
I/O Database Writes Average Bytes
8498
Kein Name
8500
I/O Database Writes In Heap
8502
I/O Database Writes Async Pending
8504
E/A: Leerungszuordnungs-Schreibvorgänge/Sek.
8506
E/A: Durchschnittliche Wartezeit für Leerungszuordnungs-Schreibvorgänge
8508
Kein Name
8510
E/A: Durchschnittliche Bytes bei Leerungszuordnungs-Schreibvorgängen
8512
Kein Name
8514
E/A: Protokollschreibvorgänge/Sek.
8516
E/A: Durchschnittliche Wartezeit für Protokollschreibvorgänge
8518
Kein Name
8520
I/O Log Writes Average Bytes
8522
Kein Name
8524
I/O Log Writes In Heap
8526
I/O Log Writes Async Pending
8528
FlushFileBuffers ops/sec
8530
FlushFileBuffers Average Latency
8532
No name
8534
Verschlüsselungsbytes/Sek.
8536
Verschlüsselungsvorgänge/Sek.
8538
Encryption average latency (us)
8540
Kein Name
8542
Entschlüsselungsbytes/Sek.
8544
Entschlüsselungsvorgänge/Sek.
8546
Decryption average latency (us)
8548
Kein Name
8550
Komprimierte Bytes/Sek.
8552
Komprimierungsvorgänge/Sek.
8554
Durchschnittliche Komprimierungswartezeit (de)
8556
Kein Name
8558
Komprimierungsverhältnis
8560
Kein Name
8562
Dekomprimierte Bytes/Sek.
8564
Dekomprimierungsvorgänge/Sek.
8566
Durchschnittliche Dekomprimierungswartezeit (de)
8568
Kein Name
8570
Cpu Xpress9 Compressed Bytes/sec
8572
Cpu Xpress9 Compression Ops/sec
8574
Cpu Xpress9 Compression average latency (us)
8576
No name
8578
Cpu Xpress9 Compression ratio
8580
No name
8582
Cpu Xpress9 Decompressed Bytes/sec
8584
Cpu Xpress9 Decompression Ops/sec
8586
Cpu Xpress9 Decompression average latency (us)
8588
No name
8590
Fpga Xpress9 Compressed Bytes/sec
8592
Fpga Xpress9 Compression Ops/sec
8594
Fpga Xpress9 Compression average latency (us)
8596
No name
8598
Fpga Xpress9 Compression ratio
8600
No name
8602
Fpga Xpress9 Decompressed Bytes/sec
8604
Fpga Xpress9 Decompression Ops/sec
8606
Fpga Xpress9 Decompression average latency (us)
8608
No name
8610
Pages Reorganized (Other)/sec
8612
Pages Reorganized (Free Space Request)/sec
8614
Pages Reorganized (Page Move Logging)/sec
8616
Pages Reorganized (Dehydrate Buffer)/sec
8618
Mittlere Wartezeit bei Datenbank-Cachefehlern (Anhängend)
8620
Kein Name
8622
Database Cache Size Unused
8624
Database Oldest Transaction
8626
Database ==> Databases
8628
Database Cache Size (MB)
8630
I/O Database Reads/sec
8632
I/O Database Reads Average Latency
8634
No name
8636
I/O Database Reads Average Bytes
8638
No name
8640
I/O Database Writes/sec
8642
I/O Database Writes Average Latency
8644
No name
8646
I/O Database Writes Average Bytes
8648
No name
8650
I/O Database Reads (Transactional) Total IO
8652
I/O Database Reads (Transactional) Mean Latency (us)
8654
I/O Database Reads (Transactional) 50th Pct Latency (us)
8656
I/O Database Reads (Transactional) 90th Pct Latency (us)
8658
I/O Database Reads (Transactional) 99th Pct Latency (us)
8660
I/O Database Reads (Transactional) Max Pct Latency (us)
8662
I/O Database Reads (Maintenance) Total IO
8664
I/O Database Reads (Maintenance) Mean Latency (us)
8666
I/O Database Reads (Maintenance) 50th Pct Latency (us)
8668
I/O Database Reads (Maintenance) 90th Pct Latency (us)
8670
I/O Database Reads (Maintenance) 99th Pct Latency (us)
8672
I/O Database Reads (Maintenance) Max Pct Latency (us)
8674
I/O Database Writes (Transactional) Total IO
8676
I/O Database Writes (Transactional) Mean Latency (us)
8678
I/O Database Writes (Transactional) 50th Pct Latency (us)
8680
I/O Database Writes (Transactional) 90th Pct Latency (us)
8682
I/O Database Writes (Transactional) 99th Pct Latency (us)
8684
I/O Database Writes (Transactional) Max Pct Latency (us)
8686
I/O Database Writes (Maintenance) Total IO
8688
I/O Database Writes (Maintenance) Mean Latency (us)
8690
I/O Database Writes (Maintenance) 50th Pct Latency (us)
8692
I/O Database Writes (Maintenance) 90th Pct Latency (us)
8694
I/O Database Writes (Maintenance) 99th Pct Latency (us)
8696
I/O Database Writes (Maintenance) Max Pct Latency (us)
8698
I/O Database Meted Queue Depth
8700
I/O Database Meted Outstanding Max
8702
I/O Database Async Read Pending
8704
Database Cache % Hit (Unique)
8706
No name
8708
Database Cache Requests/sec (Unique)
8710
SMSvcHost 4.0.0.0
8712
Protokollfehler über "net.tcp"
8714
Protokollfehler über "net.pipe"
8716
Verteilungsfehler über "net.tcp"
8718
Verteilungsfehler über "net.pipe"
8720
Über "net.tcp" verteilte Verbindungen
8722
Über "net.pipe" verteilte Verbindungen
8724
Über "net.tcp" akzeptierte Verbindungen
8726
Über "net.pipe" akzeptierte Verbindungen
8728
Aktive Registrierungen für "net.tcp"
8730
Aktive Registrierungen für "net.pipe"
8732
Registrierte URIs für "net.tcp"
8734
Registrierte URIs für "net.pipe"
8736
URIs mit aufgehobener Registrierung für "net.tcp"
8738
URIs mit aufgehobener Registrierung für "net.pipe"
8740
.NET CLR-Speicher
8742
Sammlungsanzahl der Generation 0
8744
Sammlungsanzahl der Generation 1
8746
Sammlungsanzahl der Generation 2
8748
Von Generation 0 avancierter Speicher
8750
Von Generation 1 avancierter Speicher
8752
Von Generation 0 avancierte Bytes/Sek.
8754
Von Generation 1 avancierte Bytes/Sek.
8756
Von Gen 0 hochgestufter Finalization-Speicher
8758
Prozess-ID
8760
Heapgröße der Generation 0
8762
Heapgröße der Generation 1
8764
Heapgröße der Generation 2
8766
Objektheapgröße
8768
Aufgrund ausstehender Objektfestlegung beibehaltene Objekte
8770
Anzahl der GC-Handle
8772
Zugeordnete Bytes/Sek.
8774
Anzahl der ausgelösten GC
8776
GC-Zeitdauer in Prozent
8778
Nicht angezeigt
8780
Anzahl der Bytes in den Heaps
8782
Festgelegte Bytes insgesamt
8784
Gesamtanzahl der reservierten Bytes
8786
Anzahl der fixierten Objekte
8788
Anzahl der verwendeten Sinkblöcke
8790
.NET CLR-Ladevorgang
8792
Gesamtanzahl der geladenen Klassen
8794
Ladezeit in Prozent
8796
Assemblysuchlänge
8798
Gesamtanzahl der Ladefehler
8800
Rate der Ladefehler
8802
Bytes im Lademodulheap
8804
Gesamtanzahl der entladenen Anwendungsdomänen
8806
Rate der entladenen Anwendungsdomänen
8808
Aktuelle geladene Klassen
8810
Rate der geladenen Klassen
8812
Aktuelle Anwendungsdomänen
8814
Anwendungsdomänen insgesamt
8816
Rate der Anwendungsdomänen
8818
Aktuelle Assemblys
8820
Assemblys insgesamt
8822
Assemblyrate
8824
.NET CLR-Jit
8826
Anzahl der mit JIT kompilierten Methoden
8828
Anzahl der mit JIT kompilierten IL-Bytes
8830
Gesamtanzahl der mit JIT kompilierten IL-Bytes
8832
Mit JIT kompilierte IL-Bytes/Sek.
8834
JIT-Standardfehler
8836
JIT-Zeitdauer in Prozent
8838
Nicht angezeigt
8840
.NET CLR-Interop
8842
Anzahl der CCWs
8844
Anzahl der Stubs
8846
Anzahl der Marshallvorgänge
8848
Anzahl der TLB-Importe/Sek.
8850
Anzahl der TLB-Exporte/Sek.
8852
.NET CLR-Sperren und Threads
8854
Gesamtanzahl der Konflikte
8856
Konfliktrate/Sek.
8858
Aktuelle Warteschlangenlänge
8860
Maximale Warteschlangenlänge
8862
Warteschlangenlänge/Sek.
8864
Anzahl der aktuellen logischen Threads
8866
Anzahl der aktuellen physischen Threads
8868
Anzahl der aktuellen erkannten Threads
8870
Gesamtanzahl der erkannten Threads
8872
Erkannte Threadrate/Sek.
8874
.NET CLR-Sicherheit
8876
Laufzeitüberprüfungen insgesamt
8878
Zeit für die Signaturauthentifizierung in Prozent
8880
Anzahl der Verbindungszeitüberprüfungen
8882
Zeit für die RT-Überprüfungen in Prozent
8884
Nicht angezeigt
8886
Stapeltiefe
8888
.NET CLR-Remote
8890
Remoteaufrufe/Sek.
8892
Channel
8894
Kontextproxys
8896
Geladene kontextgebundene Klassen
8898
Kontextgebundene Objektzuordnung/Sek.
8900
Kontext
8902
Remoteaufrufe insgesamt
8904
.NET CLR-Ausnahmen
8906
Anzahl der ausgelösten Ausnahmen
8908
Anzahl der ausgelösten Ausnahmen/Sek.
8910
Anzahl der Filter/Sek.
8912
Finallyanzahl/Sek.
8914
Throw-zu-Catch-Tiefe/s
8916
.NET-Datenanbieter für Oracle
8918
HardConnectsPerSecond
8920
HardDisconnectsPerSecond
8922
SoftConnectsPerSecond
8924
SoftDisconnectsPerSecond
8926
NumberOfNonPooledConnections
8928
NumberOfPooledConnections
8930
NumberOfActiveConnectionPoolGroups
8932
NumberOfInactiveConnectionPoolGroups
8934
NumberOfActiveConnectionPools
8936
NumberOfInactiveConnectionPools
8938
NumberOfActiveConnections
8940
NumberOfFreeConnections
8942
NumberOfStasisConnections
8944
NumberOfReclaimedConnections
8946
Telefonie
8948
Anzahl Leitungen
8950
Anzahl Telefoniedienste
8952
Anzahl aktiver Leitungen
8954
Anzahl aktiver Telefone
8956
Ausgehende Anrufe/s
8958
Eingehende Anrufe/s
8960
Anzahl der Clientanwendungen
8962
Aktuelle ausgehende Anrufe
8964
Aktuelle eingehende Anrufe
8966
BITS, Netzwerknutzung
8968
Remoteservergeschwindigkeit (Bit/s)
8970
Netzwerkkartengeschwindigkeit (Bit/s)
8972
Netzwerkkarte frei (%)
8974
IGD-Geschwindigkeit (Bit/s)
8976
IGD frei (%)
8978
BITS, Downloadblockgröße (Bytes)
8980
BITS, Downloadantwortintervall (ms)
8982
Geschätzte verfügbare Bandbreite für das Remotesystem (Bit/s)
8984
ReadyBoost-Cache
8986
Zwischengespeicherte Bytes
8988
Belegter Cachespeicher
8990
Komprimierungsverhältnis
8992
Gesamte Cachegröße in Bytes
8994
Cachelesevorgänge/s
8996
Cache: gelesene Bytes/s
8998
Übersprungene Lesevorgänge/s
9000
Übersprungene Lesevorgänge: Bytes/s
9002
Gesamtanzahl Lesevorgänge/s
9004
Gelesene Bytes/s insgesamt
9006
Massenvorgang Bytes/s
9008
Isochron Bytes/s
9010
Interrupt Bytes/s
9012
Steuerungsdaten Bytes/s
9014
Controller-PCI Interrupts/s
9016
Controller Betriebssignale/s
9018
% Gesamtbandbreite für Interrupt
9020
% Gesamtbandbreite für ISO
9022
USB
9024
Durchschnitt Bytes/Übertragung
9026
ISO-Paket Fehler/s
9028
Durchschnittl. Wartezeit (ms) für ISO-Übertragungen
9030
Übertragung Fehler/s
9032
Hostcontroller im Leerlauf
9034
Hostcontroller, asynch. Zeitplan im Leerlauf
9036
Leerungszähler für asynch. Cache des Hostcontrollers
9038
Hostcontroller, period. Zeitplan im Leerlauf
9040
Leerungszähler für period. Cache des Hostcontrollers
9042
Benutzereingabeverzögerung pro Prozess
9044
Benutzereingabeverzögerung pro Sitzung
9046
Max. Eingabeverzögerung
9048
Max. Eingabeverzögerung
9050
RAS-Port
9052
Bytes gesendet
9054
Bytes empfangen
9056
Rahmen gesendet
9058
Rahmen empfangen
9060
Prozent der ausgehenden Komprimierung
9062
Prozent der eingehenden Komprimierung
9064
CRC-Fehler
9066
Zeitüberschreitungen
9068
Serieller Überlauffehler
9070
Ausrichtungsfehler
9072
Pufferüberlauffehler
9074
Fehler insgesamt
9076
Bytes gesendet/s
9078
Bytes empfangen/s
9080
Rahmen gesendet/s
9082
Rahmen empfangen/s
9084
Fehler insgesamt/s
9086
RAS insgesamt
9088
Verbindungen insgesamt
9090
WF (System.Workflow) 4.0.0.0
9092
Erstellte Workflows
9094
Erstellte Workflows/Sekunde
9096
Entladene Workflows
9098
Entladene Workflows/Sekunde
9100
Geladene Workflows
9102
Geladene Workflows/Sekunde
9104
Abgeschlossene Workflows
9106
Abgeschlossene Workflows/Sekunde
9108
Angehaltene Workflows
9110
Angehaltene Workflows/Sekunde
9112
Beendete Workflows
9114
Beendete Workflows/Sekunde
9116
Workflows im Arbeitsspeicher
9118
Abgebrochene Workflows
9120
Abgebrochene Workflows/Sekunde
9122
Persistent gespeicherte Workflows
9124
Persistent gespeicherte Workflows/Sekunde
9126
Ausgeführte Workflows
9128
Workflows im Leerlauf/Sekunde
9130
Ausführbare Workflows
9132
Ausstehende Workflows
9134
Such-Gatherer-Projekte
9136
Dokumenterweiterungen
9138
Rate der Hinzufügung von Dokumenten
9140
Gelöschte Dokumente
9142
Rate der Dokumentlöschungen
9144
Dokumentänderungen
9146
Rate der Dokumentänderungen
9148
Dokumente in der Warteschlange
9150
Dokumente in Bearbeitung
9152
Zurückgehaltene Dokumente
9154
Verzögerte Dokumente
9156
URLs in Verlauf
9158
Bearbeitete Dokumente
9160
Rate der bearbeiteten Dokumente
9162
Status: Erfolgreich
9164
Erfolgsrate
9166
Statusfehler
9168
Fehlerrate
9174
Dateifehler
9176
Rate der Dateifehler
9182
Dateizugriffe
9184
Rate der Dateizugriffe
9190
Office-Filterung
9192
Rate der Office-Filterung
9194
Textfilterung
9196
Rate der Textfilterung
9198
Laufende Crawls
9200
Kennzeichen: Gatherer angehalten
9202
Kennzeichen: Wiederherstellungsvorgang
9204
Nicht verändert
9206
Kennzeichen "Wiederholen des Verlaufs wird durchgeführt"
9208
Inkrementelle Crawls
9210
Filtern von Dokumenten
9212
Gestartete Dokumente
9214
Wiederholungen
9216
Wiederholungsrate
9224
Fehler des anpassenden Crawls
9230
Geänderte Dokumente
9232
Verschobene/umbenannte Dokumente
9234
Rate des Verschiebens und Umbenennens von Dokumenten
9236
Eindeutige Dokumente
9238
Vorgang zum Wiederherstellen des Verlaufs
9240
Such-Gatherer
9242
Benachrichtigungsquellen
9244
Empfangene externe Benachrichtigungen
9246
Externe Benachrichtigungsrate
9248
Adminclients
9250
Takte
9252
Taktrate
9254
Filtern von Threads
9256
Leerlauf-Threads
9258
Dokumenteinträge
9260
Leistungsebene
9262
Länge der aktiven Warteschlange
9264
Filterprozesse
9266
Maximum der Filterprozesse
9268
Filterprozess erstellt
9270
Verzögerte Dokumente
9272
Serverobjekte
9274
Serverobjekte erstellt
9276
Filterobjekte
9278
Gefilterte Dokumente
9280
Rate der Dokumentfilterungen
9282
Zeitüberschreitungen
9284
Server momentan nicht verfügbar
9286
Server nicht verfügbar
9288
Auf das Netzwerk zugreifende Threads
9290
Threads in Plug-Ins
9292
Erfolgreich gefilterte Dokumente
9294
Rate der erfolgreich gefilterten Dokumente
9296
Erneuter Versuch für verzögerte Dokumente
9298
Zwischengespeicherte Worttrennmodule
9300
Zwischengespeicherte Formengeneratoren
9302
Alle empfangenen Benachrichtigungen
9304
Benachrichtigungsrate
9306
System-E/A-Verkehrsrate
9308
Grund für Backoff
9310
Wegen Backoff blockierte Threads
9312
Indexerstellung für die Suche
9314
Hauptindexebene
9316
Hauptzusammenführungen bisher
9318
Fortschritt der Hauptzusammenführung
9320
Ergänzungszusammenführungsebenen
9322
Schwellenwert für Ergänzungszusammenführungsebenen
9324
Beständige Indizes
9326
Indexgröße
9328
Eindeutige Schlüssel
9330
Gefilterte Dokumente
9332
Erstellte Arbeitsobjekte
9334
Gelöschte Arbeitsobjekte
9336
Fehlerfreie WidSets
9338
Fehlerhafte WidSets
9340
Hauptzusammenführung wird ausgeführt.
9342
Aktive Verbindungen
9344
Abfragen
9346
Fehlgeschlagene Abfragen
9348
Erfolgreiche Abfragen
9350
L0-Indizes (Wortlisten)
9352
L0-Zusammenführungen (Leerungen) werden ausgeführt.
9354
Geschwindigkeit der L0-Zusammenführung (Leerung) - Durchschnitt
9356
L0-Zusammenführungen (Leerungen) - Anzahl
9358
Geschwindigkeit der L0-Zusammenführung (Leerung) - Letzte
9360
Beständige Indizes L1
9362
L1-Zusammenführungen werden ausgeführt.
9364
Geschwindigkeit für L1-Zusammenführungen - Durchschnitt
9366
L1-Zusammenführungen - Anzahl
9368
Geschwindigkeit für L1-Zusammenführungen - Letzte
9370
Beständige Indizes L2
9372
L2-Zusammenführungen werden ausgeführt.
9374
Geschwindigkeit für L2-Zusammenführungen - Durchschnitt
9376
L2-Zusammenführungen - Anzahl
9378
Geschwindigkeit für L2-Zusammenführungen - Letzte
9380
Beständige Indizes L3
9382
L3-Zusammenführungen werden ausgeführt.
9384
Geschwindigkeit für L3-Zusammenführungen - Durchschnitt
9386
L3-Zusammenführungen - Anzahl
9388
Geschwindigkeit für L3-Zusammenführungen - Letzte
9390
Beständige Indizes L4
9392
L4-Zusammenführungen werden ausgeführt.
9394
Geschwindigkeit für L4-Zusammenführungen - Durchschnitt
9396
L4-Zusammenführungen - Anzahl
9398
Geschwindigkeit für L4-Zusammenführungen - Letzte
9400
Beständige Indizes L5
9402
L4-Zusammenführungen werden ausgeführt.
9404
Geschwindigkeit für L5-Zusammenführungen - Durchschnitt
9406
L5-Zusammenführungen - Anzahl
9408
Geschwindigkeit für L5-Zusammenführungen - Letzte
9410
Beständige Indizes L6
9412
L6-Zusammenführungen werden ausgeführt.
9414
Geschwindigkeit für L6-Zusammenführungen - Durchschnitt
9416
L6-Zusammenführungen - Anzahl
9418
Geschwindigkeit für L6-Zusammenführungen - Letzte
9420
Beständige Indizes L7
9422
L7-Zusammenführungen werden ausgeführt.
9424
Geschwindigkeit für L7-Zusammenführungen - Durchschnitt
9426
L7-Zusammenführungen - Anzahl
9428
Geschwindigkeit für L7-Zusammenführungen - Letzte
9430
Beständige Indizes L8
9432
L8-Zusammenführungen werden ausgeführt.
9434
Geschwindigkeit für L8-Zusammenführungen - Durchschnitt
9436
L8-Zusammenführungen - Anzahl
9438
Geschwindigkeit für L8-Zusammenführungen - Letzte
9698
SMSvcHost 3.0.0.0
9700
Protocol Failures over net.tcp
9702
Protocol Failures over net.pipe
9704
Dispatch Failures over net.tcp
9706
Dispatch Failures over net.pipe
9708
Connections Dispatched over net.tcp
9710
Connections Dispatched over net.pipe
9712
Connections Accepted over net.tcp
9714
Connections Accepted over net.pipe
9716
Registrations Active for net.tcp
9718
Registrations Active for net.pipe
9720
Uris Registered for net.tcp
9722
Uris Registered for net.pipe
9724
Uris Unregistered for net.tcp
9726
Uris Unregistered for net.pipe
9728
ServiceModelEndpoint 3.0.0.0
9730
Calls
9732
Calls Per Second
9734
Calls Outstanding
9736
Calls Failed
9738
Calls Failed Per Second
9740
Calls Faulted
9742
Calls Faulted Per Second
9744
Calls Duration
9746
Calls Duration Base
9748
Transactions Flowed
9750
Transactions Flowed Per Second
9752
Security Validation and Authentication Failures
9754
Security Validation and Authentication Failures Per Second
9756
Security Calls Not Authorized
9758
Security Calls Not Authorized Per Second
9760
Reliable Messaging Sessions Faulted
9762
Reliable Messaging Sessions Faulted Per Second
9764
Reliable Messaging Messages Dropped
9766
Reliable Messaging Messages Dropped Per Second
9768
ServiceModelOperation 3.0.0.0
9770
Calls
9772
Calls Per Second
9774
Calls Outstanding
9776
Calls Failed
9778
Call Failed Per Second
9780
Calls Faulted
9782
Calls Faulted Per Second
9784
Calls Duration
9786
Calls Duration Base
9788
Transactions Flowed
9790
Transactions Flowed Per Second
9792
Security Validation and Authentication Failures
9794
Security Validation and Authentication Failures Per Second
9796
Security Calls Not Authorized
9798
Security Calls Not Authorized Per Second
9800
Windows Workflow Foundation
9802
Workflows Created
9804
Workflows Created/sec
9806
Workflows Unloaded
9808
Workflows Unloaded/sec
9810
Workflows Loaded
9812
Workflows Loaded/sec
9814
Workflows Completed
9816
Workflows Completed/sec
9818
Workflows Suspended
9820
Workflows Suspended/sec
9822
Workflows Terminated
9824
Workflows Terminated/sec
9826
Workflows In Memory
9828
Workflows Aborted
9830
Workflows Aborted/sec
9832
Workflows Persisted
9834
Workflows Persisted/sec
9836
Workflows Executing
9838
Workflows Idle/sec
9840
Workflows Runnable
9842
Workflows Pending
9844
MSDTC Bridge 3.0.0.0
9846
Message send failures/sec
9848
Prepare retry count/sec
9850
Commit retry count/sec
9852
Prepared retry count/sec
9854
Replay retry count/sec
9856
Faults received count/sec
9858
Faults sent count/sec
9860
Average participant prepare response time
9862
Average participant prepare response time Base
9864
Average participant commit response time
9866
Average participant commit response time Base
9868
ServiceModelService 3.0.0.0
9870
Calls
9872
Calls Per Second
9874
Calls Outstanding
9876
Calls Failed
9878
Calls Failed Per Second
9880
Calls Faulted
9882
Calls Faulted Per Second
9884
Calls Duration
9886
Calls Duration Base
9888
Transactions Flowed
9890
Transactions Flowed Per Second
9892
Transacted Operations Committed
9894
Transacted Operations Committed Per Second
9896
Transacted Operations Aborted
9898
Transacted Operations Aborted Per Second
9900
Transacted Operations In Doubt
9902
Transacted Operations In Doubt Per Second
9904
Security Validation and Authentication Failures
9906
Security Validation and Authentication Failures Per Second
9908
Security Calls Not Authorized
9910
Security Calls Not Authorized Per Second
9912
Instances
9914
Instances Created Per Second
9916
Reliable Messaging Sessions Faulted
9918
Reliable Messaging Sessions Faulted Per Second
9920
Reliable Messaging Messages Dropped
9922
Reliable Messaging Messages Dropped Per Second
9924
Queued Poison Messages
9926
Queued Poison Messages Per Second
9928
Queued Messages Rejected
9930
Queued Messages Rejected Per Second
9932
Queued Messages Dropped
9934
Queued Messages Dropped Per Second
10588
WMI-Objekte
10590
HiPerf-Klassen
10592
HiPerf-Gültigkeit
10594
Battery Status
10596
Charge Rate
10598
Discharge Rate
10600
Remaining Capacity
10602
Tag
10604
Voltage
10606
EsifDeviceInformation
10608
_AC0
10610
_AC1
10612
_AC2
10614
_AC3
10616
_AC4
10618
_AC5
10620
_AC6
10622
_AC7
10624
_AC8
10626
_AC9
10628
AUX0
10630
AUX1
10632
_CRT
10634
_HOT
10636
RAPL Power
10638
_PSV
10640
Temperature
10642
iSCSI-Verbindungen
10644
Empfangene Bytes
10646
Gesendete Bytes
10648
Gesendete PDUs
10650
Empfangene PDUs
10652
iSCSI-Initiatorinstanz
10654
Sitzungstimeoutfehler
10656
Sitzungsdigestfehler
10658
Fehlgeschlagene Sitzungen
10660
Sitzungsformatfehler
10662
iSCSI-Initiatoranmeldungsstatistik
10664
Antworten mit akzeptierter Anmeldung
10666
Fehlgeschlagene Anmeldungen
10668
Antworten mit Anmeldungsauthentifizierungsfehlern
10670
Fehlgeschlagene Anmeldungen
10672
Fehlgeschlagene Anmeldungsaushandlungen
10674
Antworten mit anderen Anmeldefehlern
10676
Antworten mit Anmeldeumleitung
10678
Normale Abmeldung
10680
Andere Abmeldecodes
10682
IPSEC-Statistik für den iSCSI-HBA-Hauptmodus
10684
AcquireFailures
10686
AcquireHeapSize
10688
ActiveAcquire
10690
ActiveReceive
10692
AuthenticationFailures
10694
ConnectionListSize
10696
GetSPIFailures
10698
InvalidCookiesReceived
10700
InvalidPackets
10702
KeyAdditionFailures
10704
KeyAdditions
10706
KeyUpdateFailures
10708
KeyUpdates
10710
NegotiationFailures
10712
OakleyMainMode
10714
OakleyQuickMode
10716
ReceiveFailures
10718
ReceiveHeapSize
10720
SendFailures
10722
SoftAssociations
10724
TotalGetSPI
10726
MSiSCSI_NICPerformance
10728
BytesReceived
10730
BytesTransmitted
10732
PDUReceived
10734
PDUTransmitted
10736
IPSEC-Statistik für den iSCSI-HBA-Schnellmodus
10738
ActiveSA
10740
ActiveTunnels
10742
AuthenticatedBytesReceived
10744
AuthenticatedBytesSent
10746
BadSPIPackets
10748
ConfidentialBytesReceived
10750
ConfidentialBytesSent
10752
KeyAdditions
10754
KeyDeletions
10756
PacketsNotAuthenticated
10758
PacketsNotDecrypted
10760
PacketsWithReplayDetection
10762
PendingKeyOperations
10764
ReKeys
10766
TransportBytesReceived
10768
TransportBytesSent
10770
TunnelBytesReceived
10772
TunnelBytesSent
10774
iSCSI-Anforderungsverarbeitungszeit
10776
Durchschnittliche Anforderungsverarbeitungszeit
10778
Max. Anforderungsverarbeitungszeit
10780
iSCSI-Sitzungen
10782
Empfangene Bytes
10784
Gesendete Bytes
10786
Verbindungstimeoutfehler
10788
Digestfehler
10790
Formatfehler
10792
Gesendete PDUs
10794
Empfangene PDUs
10796
Processor Performance
10798
Processor Frequency
10800
% of Maximum Frequency
10802
Processor State Flags
6242
WorkflowServiceHost 4.0.0.0
6244
Erstellte Workflows
6246
Erstellte Workflows pro Sekunde
6248
Aktuell ausgeführte Workflows
6250
Abgeschlossene Workflows
6252
Abgeschlossene Workflows pro Sekunde
6254
Abgebrochene Workflows
6256
Abgebrochene Workflows pro Sekunde
6258
Workflows im Arbeitsspeicher
6260
Persistente Workflows
6262
Persistente Workflows pro Sekunde
6264
Beendete Workflows
6266
Beendete Workflows pro Sekunde
6268
Geladene Workflows
6270
Geladene Workflows pro Sekunde
6272
Entladene Workflows
6274
Entladene Workflows pro Sekunde
6276
Angehaltene Workflows
6278
Angehaltene Workflows pro Sekunde
6280
Workflows im Leerlauf pro Sekunde
6282
Durchschnittliche Workflowladezeit
6284
Durchschnittliche Workflow-Ladezeitbasis
6286
Durchschnittliche Workflowpersistenzzeit
6288
Durchschnittliche Workflow-Persistenzzeitbasis
6324
Terminaldienste
6326
Aktive Sitzungen
6328
Inaktive Sitzungen
6330
Sitzungen insgesamt
4806
Hyper-V-Hypervisor – logischer Prozessor
4808
Globale Zeit
4810
Gesamtausführungszeit
4812
Hypervisorausführungszeit
4814
Hardwareinterrupts/s
4816
Kontextwechsel/s
4818
Prozessorübergreifende Interrupts/s
4820
Planerinterrupts/s
4822
Zeitgeberinterrupts/s
4824
Gesendete prozessorübergreifende Interrupts/s
4826
Prozessorstopps/s
4828
Überwachung der Übergangskosten
4830
Kontextwechselzeit
4832
C1-Übergänge/s
4834
% C1-Zeit
4836
C2-Übergänge/s
4838
% C2-Zeit
4840
C3-Übergänge/s
4842
% C3-Zeit
4844
Frequenz
4846
% der maximalen Frequenz
4848
Parkstatus
4850
Prozessorstatusflags
4852
VP-Stammindex
4854
Sequenznummer im Leerlauf
4856
Globale TSC-Zahl
4858
Aktive TSC-Zahl
4860
Leerlaufakkumulation
4862
Referenzzykluszahl 0
4864
Tatsächliche Zykluszahl 0
4866
Referenzzykluszahl 1
4868
Tatsächliche Zykluszahl 1
4870
Umgebungsdomänen-ID
4872
Gesendete Interruptbenachrichtigungen/s
4874
Hypervisorbranch-Vorhersagedienstleerungen/s
4876
Hypervisor L1-Datencache: Leerungen/s
4878
Sofortige Hypervisor L1-Datencache-Leerungen/s
4880
Hypervisor: Mikroarchitektonische Pufferübertragungen pro Sek.
4882
Sequenznummer für Zähleraktualisierung
4884
Referenzzeit für Zähleraktualisierung
4886
Momentaufnahme für Leerlaufakkumulation
4888
Momentaufnahme der aktiven TSC-Anzahl
4890
HWP Request MSR: Kontextwechsel/s
4892
Gastausführungszeit
4894
Leerlaufzeit
4896
% Gesamtausführungszeit
4898
% Hypervisorausführungszeit
4900
% Gastausführungszeit
4902
% Leerlaufzeit
4904
Interrupts gesamt/s
4788
Hyper-V-Hypervisor
4790
Logische Prozessoren
4792
Partitionen
4794
Gesamtanzahl von Seiten
4796
Virtuelle Prozessoren
4798
Überwachte Benachrichtigungen
4800
Moderne Standbyeinträge
4802
Leerlaufübergänge der Plattform
4804
HypervisorStartupCost
4906
Hyper-V-Hypervisorstammpartition
4908
Virtuelle Prozessoren
4910
Virtuelle TLB-Seiten
4912
Adressräume
4914
Abgelegte Seiten
4916
GPA-Seiten
4918
GPA-Raum: Änderungen/s
4920
Leerungen des gesamten TLB/s
4922
Empfohlene Größe des virtuellen TLB
4924
GPA-Seiten (4K)
4926
GPA-Seiten (2M)
4928
GPA-Seiten (1G)
4930
GPA-Seiten (512G)
4932
Geräteseiten (4K)
4934
Geräteseiten (2M)
4936
Geräteseiten (1G)
4938
Geräteseiten (512G)
4940
Angeschlossene Geräte
4942
Interruptzuordnungen (Gerät)
4944
E/A-TLB-Leerungen/s
4946
E/A-TLB-Leerung: Kosten
4948
Interruptfehler (Gerät)
4950
DMA-Fehler (Gerät)
4952
Interrupt-Drosselungsereignisse (Gerät)
4954
Übersprungene Zeitgebereinheiten
4956
Partitions-ID
4958
Geschachtelter TLB: Größe
4960
Geschachtelter TLB: Empfohlene Größe
4962
Geschachtelter TLB: Größe der Liste freier Seiten
4964
Geschachtelter TLB: Gekürzte Seiten/s
4966
Zersplitterte Seiten/Sek.
4968
Neu zusammengesetzte Seiten/Sek.
4970
E/A-TLB-Leerungen: Basis
4972
Hyper-V-Hypervisor – Stamm des virtuellen Prozessors
4974
Gesamtausführungszeit
4976
Hypervisorausführungszeit
4978
Laufzeit des Remoteknotens
4980
Normalisierte Laufzeit
4982
Ideale Cpu
4984
Hypercalls/s
4986
Hypercalls: Kosten
4988
Seiteninvalidierungen/s
4990
Seiteninvalidierungen: Kosten
4992
Steuerregisterzugriffe/s
4994
Steuerregisterzugriffe: Kosten
4996
E/A-Anweisungen/s
4998
E/A-Anweisungen: Kosten
5000
HLT-Anweisungen/s
5002
HLT-Anweisungen: Kosten
5004
MWAIT-Anweisungen/s
5006
MWAIT-Anweisungen: Kosten
5008
CPUID-Anweisungen/s
5010
CPUID-Anweisungen: Kosten
5012
MSR-Zugriffe/s
5014
MSR-Zugriffe: Kosten
5016
Andere Abfangvorgänge/s
5018
Andere Abfangvorgänge: Kosten
5020
Externe Interrupts/s
5022
Externe Interrupts: Kosten
5024
Ausstehende Interrupts/s
5026
Ausstehende Interrupts: Kosten
5028
Emulierte Anweisungen/s
5030
Emulierte Anweisungen: Kosten
5032
Debugregisterzugriffe/s
5034
Debugregisterzugriffe: Kosten
5036
Abgefangene Seitenfehler/s
5038
Abgefangene Seitenfehler: Kosten
5040
NMI Interrupts/s
5042
NMI Interrupts: Kosten
5044
Gastseite: Tabellenzuordnungen/s
5046
Umfangreiche Seite: TLB-Auffüllungen/s
5048
Kleine Seite: TLB-Auffüllungen/s
5050
Reflektierte Gastseitenfehler/s
5052
APIC-MMIO-Zugriffe/s
5054
Abgefangene E/A-Nachrichten/s
5056
Speicher: abgefangene Nachrichten/s
5058
APIC-EOI-Zugriffe/s
5060
Andere Nachrichten/s
5062
Seitentabelle: Zuweisungen/s
5064
Logischer Prozessor: Migrationen/s
5066
Adressraum: Entfernungen/s
5068
Adressraum: Wechsel/s
5070
Adressendomäne: Leerungen/s
5072
Adressraum: Leerungen/s
5074
Globaler GVA-Bereich: Leerungen/s
5076
Lokale geleerte GVA-Bereiche/s
5078
Seitentabelle: Entfernungen/s
5080
Seitentabelle: Wiederbelegungen/s
5082
Seitentabelle: Zurücksetzungen/s
5084
Seitentabelle: Überprüfungen/s
5086
APIC-TPR-Zugriffe/s
5088
Seitentabelle: Abgefangene Schreibvorgänge/s
5090
Synthetische Interrupts/s
5092
Virtuelle Interrupts/s
5094
Gesendete APIC-IPIs/s
5096
APIC: Selbstgesendete IPIs/s
5098
GPA-Raum: Hypercalls/s
5100
Logischer Prozessor: Hypercalls/s
5102
Long-Spin-Wait-Hypercalls/s
5104
Andere Hypercalls/s
5106
Synthetische Interrupthypercalls/s
5108
Virtuelle Interrupthypercalls/s
5110
Virtuelle MMU-Hypercalls/s
5112
Virtueller Prozessor: Hypercalls/s
5114
Hardwareinterrupts/s
5116
Abgefangene Fehler geschachtelter Seiten/s
5118
Abgefangene Fehler geschachtelter Seiten: Kosten
5120
Seitenscans/Sek.
5122
Logischer Prozessor: Verteilungen/s
5124
CPU-Wartezeit pro Verteilung
5126
Erweiterte Hypercalls/s
5128
Meldungen zu Abfangvorgängen für erweiterte Hypercalls/s
5130
MBEC-Tabellenswitches geschachtelter Seiten/s
5132
Andere reflektierte Gastausnahmen/s
5134
Globale E/A-TLB-Leerungen/s
5136
Globale E/A-TLB-Leerungen: Kosten
5138
Lokale E/A-TLB-Leerungen/s
5140
Lokale E/A-TLB-Leerung: Kosten
5142
Weitergeleitete Hypercalls/s
5144
Hypercalls: Weiterleitungskosten
5146
Weitergeleitete Seiteninvalidierungen/s
5148
Seiteninvalidierungen: Weiterleitungskosten
5150
Weitergeleitete Steuerregisterzugriffe/s
5152
Steuerregisterzugriffe: Weiterleitungskosten
5154
Weitergeleitete E/A-Anweisungen/s
5156
E/A-Anweisungen: Weiterleitungskosten
5158
Weitergeleitete HLT-Anweisungen/s
5160
HLT-Anweisungen: Weiterleitungskosten
5162
Weitergeleitete MWAIT-Anweisungen/s
5164
MWAIT-Anweisungen: Weiterleitungskosten
5166
Weitergeleitete CPUID-Anweisungen/s
5168
CPUID-Anweisungen: Weiterleitungskosten
5170
Weitergeleitete MSR-Zugriffe/s
5172
MSR-Zugriffe: Weiterleitungskosten
5174
Andere weitergeleitete Abfangvorgänge/s
5176
Andere Abfangvorgänge: Weiterleitungskosten
5178
Weitergeleitete externe Interrupts/s
5180
Externe Interrupts: Weiterleitungskosten
5182
Weitergeleitete ausstehende Interrupts/s
5184
Ausstehende Interrupts: Weiterleitungskosten
5186
Weitergeleitete emulierte Anweisungen/s
5188
Emulierte Anweisungen: Weiterleitungskosten
5190
Weitergeleitete Debugregisterzugriffe/s
5192
Debugregisterzugriffe: Weiterleitungskosten
5194
Weitergeleitete abgefangene Seitenfehler/s
5196
Abgefangene Seitenfehler: Weiterleitungskosten
5198
VMCLEAR-Emulationsabfangvorgänge/s
5200
VMCLEAR-Anweisung: Emulationskosten
5202
VMPTRLD-Emulationsabfangvorgänge/s
5204
VMPTRLD-Anweisung: Emulationskosten
5206
VMPTRST-Emulationsabfangvorgänge/s
5208
VMPTRST-Anweisung: Emulationskosten
5210
VMREAD-Emulationsabfangvorgänge/s
5212
VMREAD-Anweisung: Emulationskosten
5214
VMWRITE-Emulationsabfangvorgänge/s
5216
VMWRITE-Anweisung: Emulationskosten
5218
VMXOFF-Emulationsabfangvorgänge/s
5220
VMXOFF-Anweisung: Emulationskosten
5222
VMXON-Emulationsabfangvorgänge/s
5224
VMXON-Anweisung: Emulationskosten
5226
Geschachtelte VM-Einträge/s
5228
Geschachtelte VM-Einträge: Kosten
5230
Geschachtelte behebbare SLAT-Seitenfehler/s
5232
Geschachtelte behebbare SLAT-Seitenfehler: Kosten
5234
Harte Fehler geschachtelter SLAT-Seiten/s
5236
Harte Fehler geschachtelte SLAT-Seiten: Kosten
5238
InvEpt All Context-Emulationsabfangvorgänge/s
5240
InvEpt All Context-Anweisung: Emulationskosten
5242
InvEpt Single Context-Emulationsabfangvorgänge/s
5244
InvEpt Single Context-Anweisung: Emulationskosten
5246
InvVpid All Context-Emulationsabfangvorgänge/s
5248
InvVpid All Context-Anweisung: Emulationskosten
5250
InvVpid Single Context-Emulationsabfangvorgänge/s
5252
InvVpid Single Context-Anweisung: Emulationskosten
5254
InvVpid Single Address-Emulationsabfangvorgänge/s
5256
InvVpid Single Address-Anweisung: Emulationskosten
5258
Geschachtelter TLB: Seitentabellenwiederbelegungen/s
5260
Geschachtelter TLB: Seitentabellenentfernungen/s
5262
Flush Physical Address Space-Hypercalls/s
5264
Flush Physical Address List-Hypercalls/s
5266
Gesendete Interruptbenachrichtigungen/s
5268
Gesendete Interruptüberprüfungen/s
5270
Gesamtausführungszeit des Kerns
5272
Leerlaufzeit bei Gast
5274
Gastausführungszeit
5276
% Gesamtausführungszeit
5278
% Hypervisorausführungszeit
5280
% Gastausführungszeit
5282
% Leerlaufzeit bei Gast
5284
% Gesamtausführungszeit des Kerns
5286
Nachrichten insgesamt/s
5288
Abfangvorgänge insgesamt: Basis
5290
Abfangvorgänge insgesamt/s
5292
Abfangvorgänge insgesamt: Kosten
5294
% Remoteausführungszeit
5296
Emulierte Virtualisierungsanweisungen insgesamt: Basis
5298
Emulierte Virtualisierungsanweisungen insgesamt/s
5300
Virtualisierungsanweisungen insgesamt: Emulationskosten
5302
Globale Referenzzeit
5304
Hypercalls: Basis
5306
Seiteninvalidierungen: Basis
5308
Steuerregisterzugriffe: Basis
5310
E/A-Anweisungen: Basis
5312
HLT-Anweisungen: Basis
5314
MWAIT-Anweisungen: Basis
5316
CPUID-Anweisungen: Basis
5318
MSR-Zugriffe: Basis
5320
Andere Abfangvorgänge: Basis
5322
Externe Interrupts: Basis
5324
Ausstehende Interrupts: Basis
5326
Emulierte Anweisungen: Basis
5328
Debugregisterzugriffe: Basis
5330
Abgefangene Seitenfehler: Basis
5332
NMI Interrupts: Basis
5334
Abgefangene Fehler geschachtelter Seiten: Basis
5336
Logischer Prozessor: Verteilungen insgesamt
5338
Globale E/A-TLB-Leerungen: Basis
5340
Lokale E/A-TLB-Leerungen: Basis
5342
Weitergeleitete Hypercalls: Basis
5344
Weitergeleitete Seiteninvalidierungen: Basis
5346
Weitergeleitete Steuerregisterzugriffe: Basis
5348
Weitergeleitete E/A-Anweisungen: Basis
5350
Weitergeleitete HLT-Anweisungen: Basis
5352
Weitergeleitete MWAIT-Anweisungen: Basis
5354
Weitergeleitete CPUID-Anweisungen: Basis
5356
Weitergeleitete MSR-Zugriffe: Basis
5358
Andere weitergeleitete Abfangvorgänge: Basis
5360
Weitergeleitete externe Interrupts: Basis
5362
Weitergeleitete ausstehende Interrupts: Basis
5364
Weitergeleitete emulierte Anweisungen: Basis
5366
Weitergeleitete Debugregisterzugriffe: Basis
5368
Weitergeleitete abgefangene Seitenfehler: Basis
5370
VMCLEAR-Emulationsabfangvorgänge: Basis
5372
VMPTRLD-Emulationsabfangvorgänge: Basis
5374
VMPTRST-Emulationsabfangvorgänge: Basis
5376
VMREAD-Emulationsabfangvorgänge: Basis
5378
VMWRITE-Emulationsabfangvorgänge: Basis
5380
VMXOFF-Emulationsabfangvorgänge: Basis
5382
VMXON-Emulationsabfangvorgänge: Basis
5384
Geschachtelte VM-Einträge: Basis
5386
Geschachtelte behebbare SLAT-Seitenfehler: Basis
5388
Harte Fehler geschachtelter SLAT-Seiten: Basis
5390
InvEpt All Context-Emulationsabfangvorgänge: Basis
5392
InvEpt Single Context-Emulationsabfangvorgänge: Basis
5394
InvVpid All Context-Emulationsabfangvorgänge: Basis
5396
InvVpid Single Context-Emulationsabfangvorgänge: Basis
5398
InvVpid Single Address-Emulationsabfangvorgänge: Basis
6390
Pacer-Datenstrom
6392
Ausgelassene Pakete
6394
Geplante Pakete
6396
Übertragene Pakete
6398
Geplante Bytes
6400
Bytes gesendet
6402
Übertragene Bytes/s
6404
Geplante Bytes/s
6406
Übertragene Pakete/s
6408
Geplante Pakete/s
6410
Verworfene Pakete/s
6412
Ungültige geplante Pakete
6414
Ungültige geplante Pakete/Sekunde
6416
Durchschnittliche Pakete im Shaper
6418
Max. Pakete im Shaper
6420
Durchschnittliche Pakete im Sequenzer
6422
Max. Pakete im Sequenzer
6424
Max. Pakete auf der Netzwerkkarte
6426
Durchschnittliche Pakete auf der Netzwerkkarte
6428
Ungültige übertragene Pakete
6430
Ungültige übertragene Pakete/Sekunde
6432
Pacer-Pipe
6434
Keine Pakete
6436
Geöffnete Datenströme
6438
Geschlossene Datenströme
6440
Zurückgewiesene Datenströme
6442
Geänderte Datenströme
6444
Zurückgewiesene Datenstromänderungen
6446
Max. gleichzeitige Datenströme
6448
Ungültige geplante Pakete
6450
Ungültige geplante Pakete/Sekunde
6452
Durchschnittliche Pakete im Shaper
6454
Max. Pakete im Shaper
6456
Durchschnittliche Pakete im Sequenzer
6458
Max. Pakete im Sequenzer
6460
Max. Pakete auf der Netzwerkkarte
6462
Durchschnittliche Pakete auf der Netzwerkkarte
6464
Ungültige übertragene Pakete
6466
Ungültige übertragene Pakete/Sekunde
4394
IKEv1, AuthIP und IKEv2 allgemein
4396
IKEv1-Hauptmodus-Aushandlungszeit
4398
AuthIP-Hauptmodus-Aushandlungszeit
4400
IKEv1-Schnellmodus-Aushandlungszeit
4402
AuthIP-Schnellmodus-Aushandlungszeit
4404
Erweiterungsmodus-Aushandlungszeit
4406
Empfangene Pakete/Sek.
4408
Ungültige empfangene Pakete/Sek.
4410
Erfolgreiche Aushandlungen
4412
Erfolgreiche Aushandlungen/Sek.
4414
Fehlerhafte Aushandlungen
4416
Fehlerhafte Aushandlungen/Sek.
4418
IKEv2-Hauptmodus-Aushandlungszeit
4420
IKEv2-Schnellmodus-Aushandlungszeit
4422
IPsec IKEv2 IPv4
4424
Aktive Hauptmodus-Sicherheitszuordnungen
4426
Ausstehende Hauptmodusaushandlungen
4428
Hauptmodusaushandlungen
4430
Hauptmodusaushandlungen/Sek.
4432
Erfolgreiche Hauptmodusaushandlungen
4434
Erfolgreiche Hauptmodusaushandlungen/Sek.
4436
Hauptmodusaushandlungs-Fehler
4438
Hauptmodusaushandlungs-Fehler/Sek.
4440
Empfangene Hauptmodusaushandlungs-Anforderungen
4442
Empfangene Hauptmodusaushandlungs-Anforderungen/Sek.
4444
Aktive Schnellmodus-Sicherheitszuordnungen
4446
Ausstehende Schnellmodusaushandlungen
4448
Schnellmodusaushandlungen
4450
Schnellmodusaushandlungen/Sek.
4452
Erfolgreiche Schnellmodusaushandlungen
4454
Erfolgreiche Schnellmodusaushandlungen/Sek.
4456
Schnellmodusaushandlungs-Fehler
4458
Schnellmodusaushandlungs-Fehler/Sek.
4274
IPsec AuthIP IPv4
4276
Aktive Hauptmodus-Sicherheitszuordnungen
4278
Ausstehende Hauptmodusaushandlungen
4280
Hauptmodusaushandlungen
4282
Hauptmodusaushandlungen/Sek.
4284
Erfolgreiche Hauptmodusaushandlungen
4286
Erfolgreiche Hauptmodusaushandlungen/Sek.
4288
Hauptmodusaushandlungs-Fehler
4290
Hauptmodusaushandlungs-Fehler/Sek.
4292
Empfangene Hauptmodusaushandlungs-Anforderungen
4294
Empfangene Hauptmodusaushandlungs-Anforderungen/Sek.
4296
Hauptmodus-Sicherheitszuordnungen mit Identitätswechsel
4298
Hauptmodus-Sicherheitszuordnungen mit Identitätswechsel/Sek.
4300
Aktive Schnellmodus-Sicherheitszuordnungen
4302
Ausstehende Schnellmodusaushandlungen
4304
Schnellmodusaushandlungen
4306
Schnellmodusaushandlungen/Sek.
4308
Erfolgreiche Schnellmodusaushandlungen
4310
Erfolgreiche Schnellmodusaushandlungen/Sek.
4312
Schnellmodusaushandlungs-Fehler
4314
Schnellmodusaushandlungs-Fehler/Sek.
4316
Aktive Erweiterungsmodus-Sicherheitszuordnungen
4318
Ausstehende Erweiterungsmodusaushandlungen
4320
Erweiterungsmodusaushandlungen
4322
Erweiterungsmodusaushandlungen/Sek.
4324
Erfolgreiche Erweiterungsmodusaushandlungen
4326
Erfolgreiche Erweiterungsmodusaushandlungen/Sek.
4328
Erweiterungsmodusaushandlungs-Fehler
4330
Erweiterungsmodusaushandlungs-Fehler/Sek.
4332
Erweiterungsmodus-Sicherheitszuordnungen mit Identitätswechsel
4498
IPsec-Verbindungen
4500
Gesamtanzahl aktueller Verbindungen
4502
Gesamtanzahl kumulierter Verbindungen seit Start
4504
Maximale Anzahl von Verbindungen seit Start
4506
Eingehende Bytes (gesamt) seit Start
4508
Ausgehende Bytes (gesamt) seit Start
4510
Anzahl fehlerhafter Authentifizierungen
4334
IPsec AuthIP IPv6
4336
Aktive Hauptmodus-Sicherheitszuordnungen
4338
Ausstehende Hauptmodusaushandlungen
4340
Hauptmodusaushandlungen
4342
Hauptmodusaushandlungen/Sek.
4344
Erfolgreiche Hauptmodusaushandlungen
4346
Erfolgreiche Hauptmodusaushandlungen/Sek.
4348
Hauptmodusaushandlungs-Fehler
4350
Hauptmodusaushandlungs-Fehler/Sek.
4352
Empfangene Hauptmodusaushandlungs-Anforderungen
4354
Empfangene Hauptmodusaushandlungs-Anforderungen/Sek.
4356
Hauptmodus-Sicherheitszuordnungen mit Identitätswechsel
4358
Hauptmodus-Sicherheitszuordnungen mit Identitätswechsel/Sek.
4360
Aktive Schnellmodus-Sicherheitszuordnungen
4362
Ausstehende Schnellmodusaushandlungen
4364
Schnellmodusaushandlungen
4366
Schnellmodusaushandlungen/Sek.
4368
Erfolgreiche Schnellmodusaushandlungen
4370
Erfolgreiche Schnellmodusaushandlungen/Sek.
4372
Schnellmodusaushandlungs-Fehler
4374
Schnellmodusaushandlungs-Fehler/Sek.
4376
Aktive Erweiterungsmodus-Sicherheitszuordnungen
4378
Ausstehende Erweiterungsmodusaushandlungen
4380
Erweiterungsmodusaushandlungen
4382
Erweiterungsmodusaushandlungen/Sek.
4384
Erfolgreiche Erweiterungsmodusaushandlungen
4386
Erfolgreiche Erweiterungsmodusaushandlungen/Sek.
4388
Erweiterungsmodusaushandlungs-Fehler
4390
Erweiterungsmodusaushandlungs-Fehler/Sek.
4392
Erweiterungsmodus-Sicherheitszuordnungen mit Identitätswechsel
4460
IPsec IKEv2 IPv6
4462
Aktive Hauptmodus-Sicherheitszuordnungen
4464
Ausstehende Hauptmodusaushandlungen
4466
Hauptmodusaushandlungen
4468
Hauptmodusaushandlungen/Sek.
4470
Erfolgreiche Hauptmodusaushandlungen
4472
Erfolgreiche Hauptmodusaushandlungen/Sek.
4474
Hauptmodusaushandlungs-Fehler
4476
Hauptmodusaushandlungs-Fehler/Sek.
4478
Empfangene Hauptmodusaushandlungs-Anforderungen
4480
Empfangene Hauptmodusaushandlungs-Anforderungen/Sek.
4482
Aktive Schnellmodus-Sicherheitszuordnungen
4484
Ausstehende Schnellmodusaushandlungen
4486
Schnellmodusaushandlungen
4488
Schnellmodusaushandlungen/Sek.
4490
Erfolgreiche Schnellmodusaushandlungen
4492
Erfolgreiche Schnellmodusaushandlungen/Sek.
4494
Schnellmodusaushandlungs-Fehler
4496
Schnellmodusaushandlungs-Fehler/Sek.
4074
WFPv4
4076
Eingehende Pakete verworfen/Sek.
4078
Ausgehende Pakete verworfen/Sek.
4080
Pakete verworfen/Sek.
4082
Blockierte Bindungen
4084
Eingehende Verbindungen blockiert/Sek.
4086
Ausgehende Verbindungen blockiert/Sek.
4088
Eingehende Verbindungen zugelassen/Sek.
4090
Ausgehende Verbindungen zugelassen/Sek.
4092
Eingehende Verbindungen
4094
Ausgehende Verbindungen
4096
Aktive eingehende Verbindungen
4098
Aktive ausgehende Verbindungen
4100
Klassifiziert als zugelassen/Sek.
4198
IPsec IKEv1 IPv4
4200
Aktive Hauptmodus-Sicherheitszuordnungen
4202
Ausstehende Hauptmodusaushandlungen
4204
Hauptmodusaushandlungen
4206
Hauptmodusaushandlungen/Sek.
4208
Erfolgreiche Hauptmodusaushandlungen
4210
Erfolgreiche Hauptmodusaushandlungen/Sek.
4212
Hauptmodusaushandlungs-Fehler
4214
Hauptmodusaushandlungs-Fehler/Sek.
4216
Empfangene Hauptmodusaushandlungs-Anforderungen
4218
Empfangene Hauptmodusaushandlungs-Anforderungen/Sek.
4220
Aktive Schnellmodus-Sicherheitszuordnungen
4222
Ausstehende Schnellmodusaushandlungen
4224
Schnellmodusaushandlungen
4226
Schnellmodusaushandlungen/Sek.
4228
Erfolgreiche Schnellmodusaushandlungen
4230
Erfolgreiche Schnellmodusaushandlungen/Sek.
4232
Schnellmodusaushandlungs-Fehler
4234
Schnellmodusaushandlungs-Fehler/Sek.
4236
IPsec IKEv1 IPv6
4238
Aktive Hauptmodus-Sicherheitszuordnungen
4240
Ausstehende Hauptmodusaushandlungen
4242
Hauptmodusaushandlungen
4244
Hauptmodusaushandlungen/Sek.
4246
Erfolgreiche Hauptmodusaushandlungen
4248
Erfolgreiche Hauptmodusaushandlungen/Sek.
4250
Hauptmodusaushandlungs-Fehler
4252
Hauptmodusaushandlungs-Fehler/Sek.
4254
Empfangene Hauptmodusaushandlungs-Anforderungen
4256
Empfangene Hauptmodusaushandlungs-Anforderungen/Sek.
4258
Aktive Schnellmodus-Sicherheitszuordnungen
4260
Ausstehende Schnellmodusaushandlungen
4262
Schnellmodusaushandlungen
4264
Schnellmodusaushandlungen/Sek.
4266
Erfolgreiche Schnellmodusaushandlungen
4268
Erfolgreiche Schnellmodusaushandlungen/Sek.
4270
Schnellmodusaushandlungs-Fehler
4272
Schnellmodusaushandlungs-Fehler/Sek.
4512
WFP-Klassifizierung
4514
Gesamt
4516
FWPM_LAYER_INBOUND_IPPACKET_V4
4518
FWPM_LAYER_INBOUND_IPPACKET_V4_DISCARD
4520
FWPM_LAYER_INBOUND_IPPACKET_V6
4522
FWPM_LAYER_INBOUND_IPPACKET_V6_DISCARD
4524
FWPM_LAYER_OUTBOUND_IPPACKET_V4
4526
FWPM_LAYER_OUTBOUND_IPPACKET_V4_DISCARD
4528
FWPM_LAYER_OUTBOUND_IPPACKET_V6
4530
FWPM_LAYER_OUTBOUND_IPPACKET_V6_DISCARD
4532
FWPM_LAYER_IPFORWARD_V4
4534
FWPM_LAYER_IPFORWARD_V4_DISCARD
4536
FWPM_LAYER_IPFORWARD_V6
4538
FWPM_LAYER_IPFORWARD_V6_DISCARD
4540
FWPM_LAYER_INBOUND_TRANSPORT_V4
4542
FWPM_LAYER_INBOUND_TRANSPORT_V4_DISCARD
4544
FWPM_LAYER_INBOUND_TRANSPORT_V6
4546
FWPM_LAYER_INBOUND_TRANSPORT_V6_DISCARD
4548
FWPM_LAYER_OUTBOUND_TRANSPORT_V4
4550
FWPM_LAYER_OUTBOUND_TRANSPORT_V4_DISCARD
4552
FWPM_LAYER_OUTBOUND_TRANSPORT_V6
4554
FWPM_LAYER_OUTBOUND_TRANSPORT_V6_DISCARD
4556
FWPM_LAYER_STREAM_V4
4558
FWPM_LAYER_STREAM_V4_DISCARD
4560
FWPM_LAYER_STREAM_V6
4562
FWPM_LAYER_STREAM_V6_DISCARD
4564
FWPM_LAYER_DATAGRAM_DATA_V4
4566
FWPM_LAYER_DATAGRAM_DATA_V4_DISCARD
4568
FWPM_LAYER_DATAGRAM_DATA_V6
4570
FWPM_LAYER_DATAGRAM_DATA_V6_DISCARD
4572
FWPM_LAYER_INBOUND_ICMP_ERROR_V4
4574
FWPM_LAYER_INBOUND_ICMP_ERROR_V4_DISCARD
4576
FWPM_LAYER_INBOUND_ICMP_ERROR_V6
4578
FWPM_LAYER_INBOUND_ICMP_ERROR_V6_DISCARD
4580
FWPM_LAYER_OUTBOUND_ICMP_ERROR_V4
4582
FWPM_LAYER_OUTBOUND_ICMP_ERROR_V4_DISCARD
4584
FWPM_LAYER_OUTBOUND_ICMP_ERROR_V6
4586
FWPM_LAYER_OUTBOUND_ICMP_ERROR_V6_DISCARD
4588
FWPM_LAYER_ALE_RESOURCE_ASSIGNMENT_V4
4590
FWPM_LAYER_ALE_RESOURCE_ASSIGNMENT_V4_DISCARD
4592
FWPM_LAYER_ALE_RESOURCE_ASSIGNMENT_V6
4594
FWPM_LAYER_ALE_RESOURCE_ASSIGNMENT_V6_DISCARD
4596
FWPM_LAYER_ALE_AUTH_LISTEN_V4
4598
FWPM_LAYER_ALE_AUTH_LISTEN_V4_DISCARD
4600
FWPM_LAYER_ALE_AUTH_LISTEN_V6
4602
FWPM_LAYER_ALE_AUTH_LISTEN_V6_DISCARD
4604
FWPM_LAYER_ALE_AUTH_RECV_ACCEPT_V4
4606
FWPM_LAYER_ALE_AUTH_RECV_ACCEPT_V4_DISCARD
4608
FWPM_LAYER_ALE_AUTH_RECV_ACCEPT_V6
4610
FWPM_LAYER_ALE_AUTH_RECV_ACCEPT_V6_DISCARD
4612
FWPM_LAYER_ALE_AUTH_CONNECT_V4
4614
FWPM_LAYER_ALE_AUTH_CONNECT_V4_DISCARD
4616
FWPM_LAYER_ALE_AUTH_CONNECT_V6
4618
FWPM_LAYER_ALE_AUTH_CONNECT_V6_DISCARD
4620
FWPM_LAYER_ALE_FLOW_ESTABLISHED_V4
4622
FWPM_LAYER_ALE_FLOW_ESTABLISHED_V4_DISCARD
4624
FWPM_LAYER_ALE_FLOW_ESTABLISHED_V6
4626
FWPM_LAYER_ALE_FLOW_ESTABLISHED_V6_DISCARD
4628
FWPM_LAYER_INBOUND_MAC_FRAME_ETHERNET
4630
FWPM_LAYER_OUTBOUND_MAC_FRAME_ETHERNET
4632
FWPM_LAYER_INBOUND_MAC_FRAME_NATIVE
4634
FWPM_LAYER_OUTBOUND_MAC_FRAME_NATIVE
4636
FWPM_LAYER_NAME_RESOLUTION_CACHE_V4
4638
FWPM_LAYER_NAME_RESOLUTION_CACHE_V6
4640
FWPM_LAYER_ALE_RESOURCE_RELEASE_V4
4642
FWPM_LAYER_ALE_RESOURCE_RELEASE_V6
4644
FWPM_LAYER_ALE_ENDPOINT_CLOSURE_V4
4646
FWPM_LAYER_ALE_ENDPOINT_CLOSURE_V6
4648
FWPM_LAYER_ALE_CONNECT_REDIRECT_V4
4650
FWPM_LAYER_ALE_CONNECT_REDIRECT_V6
4652
FWPM_LAYER_ALE_BIND_REDIRECT_V4
4654
FWPM_LAYER_ALE_BIND_REDIRECT_V6
4656
FWPM_LAYER_STREAM_PACKET_V4
4658
FWPM_LAYER_STREAM_PACKET_V6
4660
FWPM_LAYER_INGRESS_VSWITCH_ETHERNET
4662
FWPM_LAYER_EGRESS_VSWITCH_ETHERNET
4664
FWPM_LAYER_INGRESS_VSWITCH_TRANSPORT_V4
4666
FWPM_LAYER_INGRESS_VSWITCH_TRANSPORT_V6
4668
FWPM_LAYER_EGRESS_VSWITCH_TRANSPORT_V4
4670
FWPM_LAYER_EGRESS_VSWITCH_TRANSPORT_V6
4672
FWPM_LAYER_INBOUND_TRANSPORT_FAST
4674
FWPM_LAYER_OUTBOUND_TRANSPORT_FAST
4676
FWPM_LAYER_INBOUND_MAC_FRAME_NATIVE_FAST
4678
FWPM_LAYER_OUTBOUND_MAC_FRAME_NATIVE_FAST
4680
FWPM_LAYER_ALE_PRECLASSIFY_IP_LOCAL_ADDRESS_V4
4682
FWPM_LAYER_ALE_PRECLASSIFY_IP_REMOTE_ADDRESS_V4
4684
FWPM_LAYER_ALE_PRECLASSIFY_IP_LOCAL_PORT_V4
4686
FWPM_LAYER_ALE_PRECLASSIFY_IP_REMOTE_PORT_V4
4688
FWPM_LAYER_ALE_PRECLASSIFY_IP_LOCAL_ADDRESS_V6
4690
FWPM_LAYER_ALE_PRECLASSIFY_IP_REMOTE_ADDRESS_V6
4692
FWPM_LAYER_ALE_PRECLASSIFY_IP_LOCAL_PORT_V6
4694
FWPM_LAYER_ALE_PRECLASSIFY_IP_REMOTE_PORT_V6
4696
FWPM_LAYER_INBOUND_SSL_THROTTLING
4698
FWPM_LAYER_IPSEC_KM_DEMUX_V4
4700
FWPM_LAYER_IPSEC_KM_DEMUX_V6
4702
FWPM_LAYER_IPSEC_V4
4704
FWPM_LAYER_IPSEC_V6
4706
FWPM_LAYER_IKEEXT_V4
4708
FWPM_LAYER_IKEEXT_V6
4710
FWPM_LAYER_RPC_UM
4712
FWPM_LAYER_RPC_EPMAP
4714
FWPM_LAYER_RPC_EP_ADD
4716
FWPM_LAYER_RPC_PROXY_CONN
4718
FWPM_LAYER_RPC_PROXY_IF
4720
FWPM_LAYER_KM_AUTHORIZATION
4134
IPsec-Treiber
4136
Aktive Sicherheitszuordnungen
4138
Ausstehende Sicherheitszuordnungen
4140
Falsche SPI-Pakete
4142
Falsche SPI-Pakete/Sek.
4144
Bytes empfangen im Tunnelmodus/Sek.
4146
Bytes gesendet im Tunnelmodus/Sek.
4148
Bytes empfangen im Transportmodus/Sek.
4150
Bytes gesendet im Transportmodus/Sek.
4152
Abgeladene Sicherheitszuordnungen
4154
Abgeladene Bytes empfangen/Sek.
4156
Abgeladene Bytes gesendet/Sek.
4158
Pakete mit Rahmenerkennungsfehler
4160
Pakete mit Rahmenerkennungsfehler/Sek.
4162
Nicht authentifizierte Pakete
4164
Nicht authentifizierte Pakete/Sek.
4166
Nicht entschlüsselte Pakete
4168
Nicht entschlüsselte Pakete/Sek.
4170
Erneute Schlüssel der Sicherheitszuordnung
4172
Hinzugefügte Sicherheitszuordnungen
4174
Pakete mit ESP-Überprüfungsfehler
4176
Pakete mit ESP-Überprüfungsfehler/Sek.
4178
Pakete mit UDP-ESP-Überprüfungsfehler
4180
Pakete mit UDP-ESP-Überprüfungsfehler/Sek.
4182
Über falsche Sicherheitszuordnung empfangene Pakete
4184
Über falsche Sicherheitszuordnung empfangene Pakete/Sek.
4186
Empfangene Nur-Text-Pakete
4188
Empfangene Nur-Text-Pakete/Sek.
4190
Empfangene eingehende Pakete (gesamt)
4192
Empfangene eingehende Pakete/Sek.
4194
Verworfene eingehende Pakete (gesamt)
4196
Verworfene eingehende Pakete/Sek.
4130
WFP
4132
Anbieteranzahl
4722
Erneute WFP-Autorisierung
4724
Eingehend
4726
Ausgehend
4728
Familie: V4
4730
Familie: V6
4732
Protokoll: Andere
4734
Protokoll: IPv4
4736
Protokoll: IPv6
4738
Protokoll: ICMP
4740
Protokoll: ICMP6
4742
Protokoll: UDP
4744
Protokoll: TCP
4746
Grund: PolicyChange
4748
Grund: NewArrivalInterface
4750
Grund: NewNextHopInterface
4752
Grund: ProfileCrossing
4754
Grund: ClassifyCompletion
4756
Grund: IPSecPropertiesChanged
4758
Grund: MidStreamInspection
4760
Grund: SocketPropertyChanged
4762
Grund: NewInboundMCastBCastPacket
4764
Grund: EDPPolicyChanged
4766
Grund: PreclassifyLocalAddressDimensionPolicyChanged
4768
Grund: PreclassifyRemoteAddressDimensionPolicyChanged
4770
Grund: PreclassifyLocalPortDimensionPolicyChanged
4772
Grund: PreclassifyRemotePortDimensionPolicyChanged
4774
Grund: ProxyHandleChanged
4102
WFPv6
4104
Inbound Packets Discarded/sec
4106
Ausgehende Pakete verworfen/Sek.
4108
Pakete verworfen/Sek.
4110
Blockierte Bindungen
4112
Eingehende Verbindungen blockiert/Sek.
4114
Ausgehende Verbindungen blockiert/Sek.
4116
Eingehende Verbindungen zugelassen/Sek.
4118
Ausgehende Verbindungen zugelassen/Sek.
4120
Eingehende Verbindungen
4122
Ausgehende Verbindungen
4124
Aktive eingehende Verbindungen
4126
Aktive ausgehende Verbindungen
4128
Klassifiziert als zugelassen/Sek.
6188
Peer Name Resolution-Protokoll
6190
Registrierung
6192
Auflösen
6194
Cacheeintrag
6196
Durchschnittlich gesendete Bytes
6198
Durchschnittlich empfangene Bytes
6200
Geschätzte Wolkengröße
6202
Veralteter Cacheinhalt
6204
Sendefehler
6206
Empfangsfehler
6208
Gesendete Störungen pro Sekunde
6210
Empfangene Störungen pro Sekunde
6212
Gesendete Ankündigungen pro Sekunde
6214
Gesendete Ankündigungen pro Sekunde
6216
Gesendete Anforderungen pro Sekunde
6218
Empfangene Anforderungen pro Sekunde
6220
Gesendete Flutungen pro Sekunde
6222
Empfangene Flutungen pro Sekunde
6224
Gesendete Abfragen pro Sekunde
6226
Empfangene Abfragen pro Sekunde
6228
Gesendete Stellen pro Sekunde
6230
Empfangene Stellen pro Sekunde
6232
Gesendete Bestätigungen pro Sekunde
6234
Empfangene Bestätigungen pro Sekunde
6236
Gesendete Suchen pro Sekunde
6238
Empfangene Suchen pro Sekunde
6240
Nachricht unbekannten Typs empfangen
3426
Autorisierungs-Manager-Anwendungen
3428
Gesamtanzahl von Bereichen
3430
Anzahl der in den Speicher geladenen Bereiche
9440
Faxdienst
9442
Gesamtanzahl der Minuten, an denen gesendet oder empfangen wurde
9444
Gesamtanzahl der Seiten
9446
Gesendete und empfangene Faxe insgesamt
9448
Gesamtanzahl der Bytes.
9450
Fehlgeschlagene Faxübertragungen
9452
Fehlgeschlagene ausgehende Verbindungen
9454
Sendeminuten
9456
Gesendete Seiten
9458
Gesendete Faxe
9460
Gesendete Bytes
9462
Fehler bei Empfängen
9464
Empfangsminuten
9466
Empfangene Seiten
9468
Empfangene Faxe
9470
Empfangene Bytes
3804
Microsoft Winsock BSP
3806
Verworfene Datagramme/s
3808
Verworfene Datagramme
3810
Abgelehnte Verbindungen/s
3812
Abgelehnte Verbindungen
9550
BitLocker
9552
Min. Teilungsgröße Lesepuffer
9554
Max. Teilungsgröße Lesepuffer
9556
Min. Teilungsgröße Schreibpuffer
9558
Max. Teilungsgröße Schreibpuffer
9560
Leseanforderungen/Sek.
9562
Leseunteranforderungen/Sek.
9564
Schreibanforderungen/Sek.
9566
Schreibunteranforderungen/Sek.
5936
Virtueller Datenträger für Speicherplätze
5938
Virtueller Datenträger – aktiv
5940
Virtueller Datenträger – aktive Bytes
5942
Virtueller Datenträger – fehlt
5944
Virtueller Datenträger – fehlende Bytes
5946
Virtueller Datenträger – veraltet
5948
Virtueller Datenträger – veraltete Bytes
5950
Virtueller Datenträger – Neuerstellung erforderlich
5952
Virtueller Datenträger – neu anzuordnende Bytes
5954
Virtueller Datenträger – Neuerstellung erforderlich
5956
Virtueller Datenträger – neu zu erstellende Bytes
5958
Virtueller Datenträger – Neuerstellung
5960
Virtueller Datenträger – neu erstellte Bytes
5962
Virtueller Datenträger – ausstehende Löschung
5964
Virtueller Datenträger – zur Löschung ausstehende Bytes
5966
Virtueller Datenträger – gesamt
5968
Virtueller Datenträger – Gesamtanzahl von Bytes
5970
Virtueller Datenträger, Ursache: Fehlt
5972
Virtueller Datenträger, Ursache: Fehlende Bytes
5974
Virtueller Datenträger, Ursache: Fehler
5976
Virtueller Datenträger, Ursache: Fehlerhafte Bytes
5978
Virtueller Datenträger, Ursache: IoError
5980
Virtueller Datenträger, Ursache: IoError-Bytes
5982
Virtueller Datenträger, Ursache: HardwareError
5984
Virtueller Datenträger, Ursache: HardwareError-Bytes
5986
Virtueller Datenträger, Ursache: RegenWriteError
5988
Virtueller Datenträger, Ursache: RegenWriteError-Bytes
5990
Virtueller Datenträger, Ursache: Außer Kraft gesetzt
5992
Virtueller Datenträger, Ursache: Außer Kraft gesetzte Bytes
5994
Virtueller Datenträger, Ursache: Neu
5996
Virtueller Datenträger, Ursache: Neue Bytes
5998
Virtueller Datenträger, Ursache: RegenReadError
6000
Virtueller Datenträger, Ursache: RegenReadError-Bytes
6002
Virtueller Datenträger, Reparatur: Ersatzanzahl
6004
Virtueller Datenträger, Reparatur: Ersatzbytes
6006
Virtueller Datenträger, Ausgleich: Ersatzanzahl
6008
Virtueller Datenträger, Ausgleich: Ersatzbytes
6010
Virtueller Datenträger, Fehler: Ersatzanzahl
6012
Virtueller Datenträger, Fehler: Ersatzbytes
6014
Virtueller Datenträger, Bereich: Neuerstellungsanzahl
6016
Virtueller Datenträger, Bereich: Neuerstellungsbytes
6018
Virtueller Datenträger, Reparatur: Erforderliche Anzahl Phase 2
6020
Virtueller Datenträger, Reparatur: Erforderliche Anzahl Phase 6
6022
Virtueller Datenträger, Reparatur: Anzahl Phase 1
6024
Virtueller Datenträger, Reparatur: Status Phase 1
6026
Virtueller Datenträger, Reparatur: Anzahl Phase 2
6028
Virtueller Datenträger, Reparatur: Status Phase 2
6030
Virtueller Datenträger, Reparatur: Anzahl Phase 3
6032
Virtueller Datenträger, Reparatur: Status Phase 3
6034
Virtueller Datenträger, Reparatur: Anzahl Phase 4
6036
Virtueller Datenträger, Reparatur: Status Phase 4
6038
Virtueller Datenträger, Reparatur: Anzahl Phase 5
6040
Virtueller Datenträger, Reparatur: Status Phase 5
6042
Virtueller Datenträger, Reparatur: Anzahl Phase 6
6044
Virtueller Datenträger, Reparatur: Status Phase 6
6046
Virtueller Datenträger, Neuerstellung: Verarbeitete Bytes
6048
Virtueller Datenträger, Neuerstellung: Ausstehende Bytes
6050
Virtueller Datenträger, Neuerstellung: Übersprungene Bytes
6052
Virtueller Datenträger, Neuerstellung: Gesamtanzahl von Bytes
6094
Speicherplatz-Schreibcache
6096
Cache-Prüfpunkte
6098
Cache-Auslesevorgänge (aktuell)
6100
Cache-Erweiterungen
6102
Cache (Daten) in Bytes
6104
Cache (Daten) in Prozent
6106
Cache (frei beanspruchbar) in Bytes
6108
Cache (frei beanspruchbar) in Prozent
6110
Cache (verwendet) in Bytes
6112
Cache (verwendet) in Prozent
6114
Cachegröße
6116
Cache-Entfernungen in Bytes/Sek.
6118
Cache-Entfernungen (ausgelesen) in Bytes/Sek.
6120
Cache-Entfernungen (ausgelesen) in Prozent
6122
Cache-Entfernungen (überschrieben) in Bytes/Sek.
6124
Cache-Entfernungen (überschrieben) in Prozent
6126
Umgehungen gelesen in Bytes/Sek.
6128
Umgehungen gelesen in Prozent
6130
Cache gelesen in Bytes/Sek.
6132
Cache gelesen in Prozent
6134
Umgehungen geschrieben in Bytes/Sek.
6136
Umgehungen geschrieben in Prozent
6138
Cache geschrieben in Bytes/Sek.
6140
Cache geschrieben in Prozent
6142
Cache geschrieben (nicht verbunden) in Bytes/Sek.
6144
Cache geschrieben (nicht verbunden) in Prozent
6146
Cache geschrieben (nicht beschnitten) in Bytes/Sek.
6148
Cache geschrieben (nicht beschnitten) in Prozent
6150
Cache geschrieben (überlappend) in Bytes/Sek.
6152
Cache geschrieben (überlappend) in Prozent
6054
Speicherplatzebene
6056
Ebenen-Lesevorgänge/Sek.
6058
Ebenen-Lesevorgänge (Latenz)
6060
Ebenen-Lesevorgänge (Durchschnitt)
6062
Ebenen-Lesevorgang in Bytes/Sek.
6064
Ebenen-Lesevorgang in Bytes (Durchschnitt)
6066
Ebenen-Schreibvorgänge/Sek.
6068
Ebenen-Schreibvorgänge (Latenz)
6070
Ebenen-Schreibvorgänge (Durchschnitt)
6072
Ebenen-Schreibvorgang in Bytes/Sek.
6074
Ebenen-Schreibvorgang in Bytes (Durchschnitt)
6076
Ebenen-Übertragungen (aktuell)
6078
Ebenen-Übertragungen/Sek.
6080
Ebenen-Übertragungen (Latenz)
6082
Ebenen-Übertragungen (Durchschnitt)
6084
Ebenen-Übertragung in Bytes/Sek.
6086
Ebenen-Übertragung in Bytes (Durchschnitt)
6088
Ebenen-Lesevorgänge
6090
Ebenen-Schreibvorgänge
6092
Ebenen-Übertragungen
6164
Storage Spaces Drt
6166
Bereinigte Anzahl
6168
Bereinigte Bytes
6170
Unbereinigte Anzahl
6172
Unbereinigte Bytes
6174
Leerungsanzahl
6176
Bytes werden geleert
6178
Anzahl Leerungsvorgänge
6180
Geleert Bytes
6182
Anzahl wird synchronisiert
6184
Bytes werden synchronisiert
6186
Grenzwert
3104
ReFS
3106
Gesamtzuordnung von Clustern/Sek.
3108
Data-In-Place-Schreibcluster/Sek.
3110
Zuordnung von Metadatenclustern auf schneller Ebene/Sek.
3112
Zuordnung von Metadatenclustern auf langsamer Ebene/Sek.
3114
Zuordnung von Datenclustern auf schneller Ebene/Sek.
3116
Zuordnung von Datenclustern auf langsamer Ebene/Sek.
3118
Containerauslesungen von langsamer Ebene/Sek.
3120
Containerauslesungen von schneller Ebene/Sek.
3122
Aktuelle prozentuale Datenfüllrate auf langsamer Ebene
3124
Aktuelle prozentuale Datenfüllrate auf schneller Ebene
3126
Leselatenz bei Auslesungen auf langsamer Ebene (100 ns)
3130
Schreiblatenz bei Auslesungen auf langsamer Ebene (100 ns)
3134
Leselatenz bei Auslesungen auf schneller Ebene (100 ns)
3138
Schreiblatenz bei Auslesungen auf schneller Ebene (100 ns)
3142
Füllverhältnis ausgelesener Container auf langsamer Ebene (%)
3146
Füllverhältnis ausgelesener Container auf schneller Ebene (%)
3150
Latenz bei der Strukturaktualisierung (100 ns)
3154
Prüfpunktlatenz (100 ns)
3158
Strukturaktualisierungen/Sek.
3160
Prüfpunkte/Sek.
3162
Protokollschreibzugriffe/Sek.
3164
Aktuelle prozentuale Metadatenfüllrate auf langsamer Ebene
3166
Aktuelle prozentuale Metadatenfüllrate auf schneller Ebene
3168
Protokollauffüllung in Prozent
3170
Kürzungslatenz (100 ns)
3174
Datenkomprimierungen/Sek.
3176
Komprimierungsleselatenz (100 ns)
3180
Komprimierungsschreiblatenz (100 ns)
3184
Füllverhältnis für komprimierte Container (%)
3188
Aufgrund nicht qualifizierter Container fehlgeschlagene Komprimierungen
3190
Aufgrund einer maximalen Fragmentierung fehlgeschlagene Komprimierungen
3192
Zahl der Wiederholungsversuche für Containerverschiebungen
3194
Aufgrund eines nicht qualifizierten Containers fehlgeschlagene Containerverschiebungen
3196
Zahl der Komprimierungsfehler
3198
Zahl der fehlgeschlagenen Containerverschiebungen
3200
Seiten mit schmutzigen Metadaten
3202
Schmutzige Tabellenlisteneinträge
3204
Warteschlangeneinträge löschen
10568
Storage Management WSP Spaces Runtime
10570
Runtime Count 4ms
10572
Runtime Count 16ms
10574
Runtime Count 64ms
10576
Runtime Count 256ms
10578
Runtime Count 1s
10580
Runtime Count 4s
10582
Runtime Count 16s
10584
Runtime Count 1min
10586
Runtime Count Infinite
9616
SMB Direct-Verbindung
9618
Verzögerungen (Sendekredit)/s
9620
Verzögerungen (Sendewarteschlange)/s
9622
Verzögerungen (RDMA-Registrierungen)/s
9624
Sendevorgänge/s
9626
Remote-Invalidierungen/s
9628
Speicherbereiche
9630
Empfangene Bytes/s
9632
Gesendete Bytes/s
9634
Gelesene RDMA-Bytes/s
9636
Geschriebene RDMA-Bytes/s
9638
Verzögerungen (RDMA-Lesevorgänge)/s
9640
Empfangsvorgänge/s
9642
RDMA-Registrierungen/s
9644
SCQ-Benachrichtigungsereignisse/s
9646
RCQ-Benachrichtigungsereignisse/s
9648
Falsche RCQ-Benachrichtigungsereignisse
9650
Falsche SCQ-Benachrichtigungsereignisse
9508
Offlinedateien
9510
Empfangene Bytes
9512
Übertragene Bytes
9514
Übertragene Bytes/s
9518
Empfangene Bytes/s
9522
Clientseitige Zwischenspeicherung
9524
Angeforderte Bytes für SMB-BranchCache
9526
Empfangene Bytes für SMB-BranchCache
9528
Veröffentlichte Bytes für SMB-BranchCache
9530
Vom Server angeforderte Bytes für SMB-BranchCache
9532
Angeforderte Hashes für SMB-BranchCache
9534
Empfangene Hashes für SMB-BranchCache
9536
Empfangene Hashbytes für SMB-BranchCache
9538
Vorabrufvorgänge in Warteschlange
9540
Aus dem Cache gelesene Vorabrufbytes
9542
Vom Server gelesene Vorabrufbytes
9544
Aus dem Cache gelesene Anwendungsbytes
9546
Vom Server gelesene Anwendungsbytes
9548
Vom Server gelesene Anwendungsbytes (nicht zwischengespeichert)
3260
Teredorelay
3262
Eingehend - Gesamtanzahl der Teredorelaypakete: Erfolg + Fehler
3264
Eingehend - Erfolgreiche Teredorelaypakete: Gesamt
3266
Eingehend - Erfolgreiche Teredorelaypakete: Bubbles
3268
Eingehend - Erfolgreiche Teredorelaypakete: Datenpakete
3270
Eingehend - Fehlerhafte Teredorelaypakete: Gesamt
3272
Eingehend - Fehlerhafte Teredorelaypakete: Headerfehler
3274
Eingehend - Fehlerhafte Teredorelaypakete: Quellfehler
3276
Eingehend - Fehlerhafte Teredorelaypakete: Zielfehler
3278
Ausgehend - Gesamtanzahl der Teredorelaypakete: Erfolg + Fehler
3280
Ausgehend - Erfolgreiche Teredorelaypakete
3282
Ausgehend - Erfolgreiche Teredorelaypakete: Bubbles
3284
Ausgehend - Erfolgreiche Teredorelaypakete: Datenpakete
3286
Ausgehend - Fehlerhafte Teredorelaypakete
3288
Ausgehend - Fehlerhafte Teredorelaypakete: Headerfehler
3290
Ausgehend - Fehlerhafte Teredorelaypakete: Quellfehler
3292
Ausgehend - Fehlerhafte Teredorelaypakete: Zielfehler
3294
Eingehend - Gesamtanzahl der Teredorelaypakete: Erfolg + Fehler/Sekunde
3296
Ausgehend - Gesamtanzahl der Teredorelaypakete: Erfolg + Fehler/Sekunde
3298
Eingehend - Erfolgreiche Teredo-Relaypakete: Benutzermodus für Datenpakete
3300
Eingehend - Erfolgreiche Teredo-Relaypakete: Kernelmodus für Datenpakete
3302
Ausgehend - Erfolgreiche Teredo-Relaypakete: Benutzermodus für Datenpakete
3304
Ausgehend - Erfolgreiche Teredo-Relaypakete: Kernelmodus für Datenpakete
3306
IP-HTTPS-Sitzung
3308
In der Sitzung empfangene Pakete
3310
In der Sitzung gesendete Pakete
3312
In der Sitzung empfangene Bytes
3314
In der Sitzung gesendete Bytes
3316
Fehler - Übertragungsfehler in der Sitzung
3318
Fehler - Empfangsfehler in der Sitzung
3320
Dauer - Dauer der Sitzung (Sekunden)
3344
DNS64 Global
3346
AAAA-Abfragen - erfolgreich
3348
AAAA-Abfragen - Fehler
3350
IP6.ARPA-Abfragen - Übereinstimmung
3352
Andere Abfragen - erfolgreich
3354
Andere Abfragen - Fehler
3356
AAAA - neu bestimmte Datensätze
3322
IP-HTTPS-Global
3324
Eingehend - Insgesamt empfangene Bytes
3326
Ausgehend - Insgesamt gesendete Bytes
3328
Verworfen - Zeitüberschreitungen bei Nachbarauflösungen
3330
Fehler - Authentifizierungsfehler
3332
Ausgehend - Weitergeleitete Bytes gesamt
3334
Fehler - Übertragungsfehler auf dem Server
3336
Fehler - Empfangsfehler auf dem Server
3338
Eingehend - Insgesamt empfangene Pakete
3340
Ausgehend - Insgesamt gesendete Pakete
3342
Sitzungen - Sitzungen gesamt
3230
Teredo-Server
3232
Eingehend - Gesamtanzahl der Teredo-Serverpakete: Erfolg + Fehler
3234
Eingehend - Erfolgreiche Teredo-Serverpakete: Gesamt
3236
Eingehend - Erfolgreiche Teredo-Serverpakete: Bubbles
3238
Eingehend - Erfolgreiche Teredo-Serverpakete: Echo
3240
Eingehend - Erfolgreiche Teredo-Serverpakete: Routeranfragen primär
3242
Eingehend - Erfolgreiche Teredo-Serverpakete: Routeranfragen sekundär
3244
Eingehend - Fehlerhafte Teredo-Serverpakete: Gesamt
3246
Eingehend - Fehlerhafte Teredo-Serverpakete: Headerfehler
3248
Eingehend - Fehlerhafte Teredo-Serverpakete: Quellfehler
3250
Eingehend - Fehlerhafte Teredo-Serverpakete: Zielfehler
3252
Eingehend - Fehlerhafte Teredo-Serverpakete: Authentifizierungsfehler
3254
Ausgehend - Teredo-Server: Routerankündigung primär
3256
Ausgehend - Teredo-Server: Routerankündigung sekundär 
3258
Eingehend - Gesamtanzahl der Teredo-Serverpakete: Erfolg + Fehler/Sekunde
3206
Teredo-Client
3208
Eingehend - Teredo-Routerankündigung
3210
Eingehend - Teredo-Bubble
3212
Eingehend - Teredo-Daten
3214
Eingehend - Teredo ungültig
3216
Ausgehend - Teredo-Routeranfrage
3218
Ausgehend - Teredo-Bubble
3220
Ausgehend - Teredo-Daten
3222
Eingehend - Benutzermodus für Teredo-Daten
3224
Eingehend - Kernelmodus für Teredo-Daten
3226
Ausgehend - Benutzermodus für Teredo-Daten
3228
Ausgehend - Kernelmodus für Teredo-Daten
6468
Hyper-V-Dienst für die Integration des dynamischen Arbeitsspeichers
6470
Maximaler Arbeitsspeicher, MB
1848
Bluetooth-Gerät
1850
Klassisches ACL - Bytes/s geschrieben
1852
LE ACL - Bytes/s geschrieben
1854
SCO - Bytes/s geschrieben
1856
Klassisches ACL - Bytes/s gelesen
1858
LE ACL - Bytes/s gelesen
1860
SCO - Bytes/s gelesen
1862
Klassische ACL-Verbindungen
1864
LE-ACL-Verbindungen
1866
SCO - Verbindungen
1868
Seitenband SCO - Verbindungen
1870
ACL-Leerung - Ereignisse/s
1872
LE ACL-Schreibnachweise
1874
Klassische ACL-Schreibnachweise
1876
LE-Scanarbeitszyklus (%) – 1M Phy nicht codiert
1878
LE-Scanfenster – 1M PHY nicht codiert
1880
LE-Scanintervall – 1M PHY nicht codiert
1882
Seitenscanarbeitszyklus (%)
1884
Seitenscanfenster
1886
Seitenscanintervall
1888
Gescannte Abfragen – Arbeitszyklus (%)
1890
Abfragenscanfenster
1892
Abfragenscanintervall
1894
LE-Scanarbeitszyklus (%) – Phy codiert
1896
LE-Scanfenster – PHY codiert
1898
LE-Scanintervall – PHY codiert
1900
Bluetooth-Gerät
1902
Klassische ACL - Bytes/s geschrieben
1904
LE ACL - Bytes/s geschrieben
1906
SCO - Bytes/s geschrieben
1908
Klassisches ACL - Bytes/s gelesen
1910
LE ACL - Bytes/s gelesen
1912
SCO - Bytes/s gelesen
3814
ServiceModelService 4.0.0.0
3816
Aufrufe
3818
Aufrufe pro Sekunde
3820
Ausstehende Aufrufe
3822
Fehlgeschlagene Aufrufe
3824
Fehlgeschlagene Aufrufe pro Sekunde
3826
Fehlerhafte Aufrufe
3828
Fehlerhafte Aufrufe pro Sekunde
3830
Aufrufdauer
3832
Fehler bei Sicherheitsvalidierung und Authentifizierung
3834
Fehler bei Sicherheitsvalidierung und Authentifizierung pro Sekunde
3836
Nicht autorisierte Sicherheitsaufrufe
3838
Nicht autorisierte Sicherheitsaufrufe pro Sekunde
3840
Instanzen
3842
Erstellte Instanzen pro Sekunde
3844
Fehlerhafte zuverlässige Messagingsitzungen
3846
Fehlerhafte zuverlässige Messagingsitzungen pro Sekunde
3848
Verworfene zuverlässige Messagingnachrichten
3850
Verworfene zuverlässige Messagingnachrichten pro Sekunde
3852
Übertragene Transaktionen
3854
Übertragene Transaktionen pro Sekunde
3856
Transaktive Vorgänge mit ausgeführtem Commit
3858
Transaktive Vorgänge mit ausgeführtem Commit pro Sekunde
3860
Abgebrochene transaktive Vorgänge
3862
Abgebrochene transaktive Vorgänge pro Sekunde
3864
Zweifelhafte transaktive Vorgänge
3866
Zweifelhafte transaktive Vorgänge pro Sekunde
3868
Nicht verarbeitbare Nachrichten in der Warteschlange
3870
Nicht verarbeitbare Nachrichten in der Warteschlange pro Sekunde
3872
Von der Warteschlange zurückgewiesene Nachrichten
3874
Von der Warteschlange zurückgewiesene Nachrichten pro Sekunde
3876
Aus der Warteschlange verworfene Nachrichten
3878
Aus der Warteschlange verworfene Nachrichten pro Sekunde
3880
Prozentsatz der Höchstanzahl gleichzeitiger Aufrufe
3882
Prozentsatz der Höchstanzahl gleichzeitiger Instanzen
3884
Prozentsatz der Höchstanzahl gleichzeitiger Sitzungen
3886
CallDurationBase
3888
CallsPercentMaxConcurrentCallsBase
3890
InstancesPercentMaxConcurrentInstancesBase
3892
SessionsPercentMaxConcurrentSessionsBase
3934
ServiceModelOperation 4.0.0.0
3936
Aufrufe
3938
Aufrufe pro Sekunde
3940
Ausstehende Aufrufe
3942
Fehlgeschlagene Aufrufe
3944
Fehlgeschlagene Aufrufe pro Sekunde
3946
Fehlerhafte Aufrufe
3948
Fehlerhafte Aufrufe pro Sekunde
3950
Aufrufdauer
3952
Fehler bei Sicherheitsvalidierung und Authentifizierung
3954
Fehler bei Sicherheitsvalidierung und Authentifizierung pro Sekunde
3956
Nicht autorisierte Sicherheitsaufrufe
3958
Nicht autorisierte Sicherheitsaufrufe pro Sekunde
3960
Übertragene Transaktionen
3962
Übertragene Transaktionen pro Sekunde
3964
CallsDurationBase
3894
ServiceModelEndpoint 4.0.0.0
3896
Aufrufe
3898
Aufrufe pro Sekunde
3900
Ausstehende Aufrufe
3902
Fehlgeschlagene Aufrufe
3904
Fehlgeschlagene Aufrufe pro Sekunde
3906
Fehlerhafte Aufrufe
3908
Fehlerhafte Aufrufe pro Sekunde
3910
Aufrufdauer
3912
Fehler bei Sicherheitsvalidierung und Authentifizierung
3914
Fehler bei Sicherheitsvalidierung und Authentifizierung pro Sekunde
3916
Nicht autorisierte Sicherheitsaufrufe
3918
Nicht autorisierte Sicherheitsaufrufe pro Sekunde
3920
Fehlerhafte zuverlässige Messagingsitzungen
3922
Fehlerhafte zuverlässige Messagingsitzungen pro Sekunde
3924
Verworfene zuverlässige Messagingnachrichten
3926
Verworfene zuverlässige Messagingnachrichten pro Sekunde
3928
Übertragene Transaktionen
3930
Übertragene Transaktionen pro Sekunde
3932
CallDurationBase
6472
Energieanzeige
6474
Stromverbrauch
6476
Energiebudget
6478
Energiemessung
6480
Zeit
6482
Energie
6484
Leistung
5652
TCP/IP-Leistungsdiagnose (pro CPU)
5654
Aktuelle TCP-Verbindungen
5580
TCP/IP-Leistungsdiagnose
5582
IPv4-NBLs mit Kennzeichen für geringe Ressourcen
5584
IPv4-NBLs/s mit Kennzeichen für geringe Ressourcen
5586
IPv6-NBLs mit Kennzeichen für geringe Ressourcen
5588
IPv6-NBLs/s mit Kennzeichen für geringe Ressourcen
5590
IPv4-NBLs ohne Vorabüberprüfung
5592
IPv4-NBLs/s ohne Vorabüberprüfung
5594
IPv6-NBLs ohne Vorabüberprüfung
5596
IPv6-NBLs/s ohne Vorabüberprüfung
5598
Als ohne Vorabüberprüfung behandelte IPv4-NBLs
5600
Als ohne Vorabüberprüfung behandelte IPv4-NBLs/s
5602
Als ohne Vorabüberprüfung behandelte IPv6-NBLs
5604
Als ohne Vorabüberprüfung behandelte IPv6-NBLs/s
5606
Ausgehende IPv4-NBLs ohne Verarbeitung über den schnellen Pfad
5608
Ausgehende IPv4-NBLs/s ohne Verarbeitung über den schnellen Pfad
5610
Ausgehende IPv6-NBLs ohne Verarbeitung über den schnellen Pfad
5612
Ausgehende IPv6-NBLs/s ohne Verarbeitung über den schnellen Pfad
5614
Eingehende TCP-Segmente ohne Verarbeitung über den schnellen Pfad
5616
Eingehende TCP-Segmente/s ohne Verarbeitung über den schnellen Pfad
5618
Vom schnellen Loopback-Pfad verdrängte TCP-Verbindungsanforderungen
5620
Vom schnellen Loopback-Pfad verdrängte TCP-Verbindungsanforderungen/s
5622
Abgelehnte Anforderungen zum Verbinden oder Senden im Energiesparmodus
5624
TCP-Prüfsummenfehler
5626
TCP-Zeitüberschreitungen
5628
RSC-Segmente über LSO weitergeleitet
5630
RSC-Segmente über Softwaresegmentierung weitergeleitet
5632
RSC-Segmente über Softwaresegmentierung und Prüfsumme weitergeleitet
5634
RSC-Segment-Weiterleitungsfehler während der Softwaresegmentierung
5636
Durch Softwaresegmentierung erstellte UDP-Datagramme
5638
UDP URO-Ereignisse
5640
Über UDP URO empfangene Bytes
5642
TCP-RSC-Ereignisse
5644
Über TCP RSC empfangene Bytes:
5646
URO-Segmente über Softwaresegmentierung weitergeleitet
5648
URO-Segmente über Softwaresegmentierung und Prüfsumme weitergeleitet
5650
URO-Segment-Weiterleitungsfehler während der Softwaresegmentierung
5512
WinNAT - UDP
5514
NumberOfSessions
5516
NumberOfBindings
5518
NumIntToExtTranslations
5520
NumExtToIntTranslations
5522
NumPacketsDropped
5524
NumSessionsTimedOut
5570
WinNAT-Instanz
5572
Verwendete TCP-Ports
5574
Verfügbare TCP-Ports
5576
Verwendete UDP-Ports
5578
Verfügbare UDP-Ports
5498
WinNAT - TCP
5500
NumberOfSessions
5502
NumberOfBindings
5504
NumIntToExtTranslations
5506
NumExtToIntTranslations
5508
NumPacketsDropped
5510
NumSessionsTimedOut
5540
WinNAT
5542
Sitzungen/s
5544
Aktuelle Sitzungsanzahl
5546
Pakete/s (intern nach extern)
5548
Pakete (intern nach extern)
5550
Pakete/s (extern nach intern)
5552
Pakete (extern nach intern)
5554
Verworfene Pakete/s
5556
Verworfene Pakete
5558
Verworfene Pakete mit ICMP-Fehler/s
5560
Verworfene Pakete mit ICMP-Fehler
5562
Inter-Routingdomänenpakete im Hairpin-Modus/s
5564
Inter-Routingdomänenpakete im Hairpin-Modus
5566
Intra-Routingdomänenpakete im Hairpin-Modus/s
5568
Intra-Routingdomänenpakete im Hairpin-Modus
5526
WinNAT - ICMP
5528
NumberOfSessions
5530
NumberOfBindings
5532
NumIntToExtTranslations
5534
NumExtToIntTranslations
5536
NumPacketsDropped
5538
NumSessionsTimedOut
5912
Anforderungswarteschlangen für HTTP-Dienst
5914
Aktuelle Warteschlangengröße
5916
Maximales Alter von Warteschlangenelementen
5918
Eingangsrate
5920
Ablehnungsrate
5922
Abgelehnte Anforderungen
5924
Cachetrefferrate
5892
URL-Gruppen für HTTP-Dienst
5894
Rate gesendeter Bytes
5896
Rate empfangener Bytes
5898
Rate übertragener Bytes
5900
Aktuelle Verbindungen
5902
Maximale Anzahl an Verbindungen
5904
Verbindungsversuche
5906
GET-Anforderungen
5908
HEAD-Anforderungen
5910
Alle Anforderungen
5878
HTTP-Dienst
5880
Aktuelle URIs im Cache
5882
URIs im Cache insgesamt
5884
URI-Cachetreffer
5886
URI-Cachefehler
5888
URI-Cacheleerungen
5890
Geleerte URIs insgesamt
3358
PowerShell-Workflow
3360
Anzahl von fehlerhaften Workflowaufträgen
3362
Anzahl von fehlerhaften Workflowaufträgen/s
3364
Anzahl von fortgesetzten Workflowaufträgen
3366
Anzahl von fortgesetzten Workflowaufträgen/s
3368
Anzahl von ausgeführten Workflowaufträgen
3370
Anzahl von ausgeführten Workflowaufträgen/s
3372
Anzahl von beendeten Workflowaufträgen
3374
Anzahl von beendeten Workflowaufträgen/s
3376
Anzahl von erfolgreichen Workflowaufträgen
3378
Anzahl von erfolgreichen Workflowaufträgen/s
3380
Anzahl von angehaltenen Workflowaufträgen
3382
Anzahl von angehaltenen Workflowaufträgen
3384
Anzahl von beendeten Workflowaufträgen
3386
Anzahl von beendeten Workflowaufträge/s
3388
Anzahl von wartenden Workflowaufträgen
3390
Aktivitätshost-Manager: Anzahl von belegten Hostprozessen
3392
Aktivitätshost-Manager: Anzahl von fehlerhaften Anforderungen/s
3394
Aktivitätshost-Manager: Anzahl von fehlerhaften Anforderungen in der Warteschlange
3396
Aktivitätshost-Manager: Anzahl von eingehenden Anforderungen/s
3398
Aktivitätshost-Manager: Anzahl von ausstehenden Anforderungen in der Warteschlange
3400
Aktivitätshost-Manager: Anzahl von erstellten Hostprozessen
3402
Aktivitätshost-Manager: Anzahl von verworfenen Hostprozessen
3404
Aktivitätshost-Manager: Größe des Hostprozesspools
3406
PowerShell-Remoting: Anzahl von ausstehenden Anforderungen in der Warteschlange
3408
PowerShell-Remoting: Anzahl von verarbeiteten Anforderungen
3410
PowerShell-Remoting: Anzahl von Anforderungen in der Warteschlange, die warten müssen
3412
PowerShell-Remoting: Anzahl von erstellten Verbindungen
3414
PowerShell-Remoting: Anzahl von verworfenen Verbindungen
3416
PowerShell-Remoting: Anzahl von geschlossenen und erneut geöffneten Verbindungen
3448
RemoteFX-Grafik
3450
Eingabeframes/Sekunde
3452
Grafikkomprimierungsverhältnis
3454
Ausgabeframes/Sekunde
3456
Übersprungene Frames/Sekunde - Unzureichende Clientressourcen
3458
Übersprungene Frames/Sekunde - Unzureichende Netzwerkressourcen
3460
Übersprungene Frames/Sekunde - Unzureichende Serverressourcen
3462
Framequalität
3464
Durchschnittliche Codierungszeit
3466
Quellframes/Sekunde
3468
RemoteFX-Netzwerk
3470
Grundlegende TCP-RTT
3472
Aktuelle TCP-RTT
3474
Aktuelle TCP-Bandbreite
3476
Empfangsrate insgesamt
3478
TCP-Empfangsrate
3480
UDP-Empfangsrate
3482
Empfangene UDP-Pakete/s
3484
Senderate insgesamt
3486
TCP-Senderate
3488
UDP-Senderate
3490
Gesendete UDP-Pakete/s
3492
Senderate P0
3494
Senderate P1
3496
Senderate P2
3498
Senderate P3
3500
Verlustrate
3502
Neuübertragungsrate
3504
FEC-Rate
3508
Grundlegende UDP-RTT
3510
Aktuelle UDP-RTT
3512
Aktuelle UDP-Bandbreite
3514
Gesamtanzahl gesendeter Bytes
3516
Gesamtanzahl empfangener Bytes
5656
SMB-Serverfreigaben
5658
Empfangene Bytes/s
5660
Anforderungen/Sek.
5662
Anzahl von Strukturverbindungen
5664
Anzahl derzeit geöffneter Dateien
5666
Gesendete Bytes/s
5668
Übertragene Bytes/s
5670
Derzeit ausstehende Anforderungen
5672
Sek./Anforderung (Durchschnitt)
5676
Schreibanforderungen/Sek.
5678
Sek./Schreibvorgang (Durchschnitt)
5682
Geschriebene Bytes/Sek.
5684
Leseanforderungen/Sek.
5686
Sek./Lesevorgang (Durchschnitt)
5690
Gelesene Bytes/s
5692
Gesamtanzahl geöffneter Dateien
5694
Geöffnete Dateien/s
5696
Aktuelle Anzahl der geöffneten permanenten Dateihandles
5698
Gesamtanzahl erneut geöffneter permanenter Handles
5700
Gesamtanzahl permanenter Handles mit Fehler beim erneuten Öffnen
5702
Stabile Handles in Prozent
5706
Gesamtanzahl erneut geöffneter stabiler Handles
5708
Gesamtanzahl stabiler Handles mit Fehler beim erneuten Öffnen
5710
Beständige Handles in Prozent
5714
Gesamtanzahl erneut geöffneter beständiger Handles
5716
Gesamtanzahl beständiger Handles mit Fehler beim erneuten Öffnen
5718
Metadatenanforderungen/Sek.
5720
Durchschn. Sek./Datenanforderung
5724
Durchschn. Datenbytes/Anforderung
5728
Durchschn. Bytes/Lesevorgang
5732
Durchschn. Bytes/Schreibvorgang
5736
Durchschn. Warteschlangenlänge für Lesevorgänge
5738
Durchschn. Warteschlangenlänge für Schreibvorgänge
5740
Durchschn. Länge der Datenwarteschlange
5742
Datenbytes/Sek.
5744
Datenanforderungen/Sek.
5746
Aktuelle Länge der Datenwarteschlange
5748
Über SMB Direct übertragene Schreibanforderungen/s
5750
Über SMB Direct übertragene geschriebene Bytes/s
5752
Über SMB Direct übertragene Leseanforderungen/s
5754
Über SMB Direct übertragene gelesene Bytes/s
5756
Aktuelle Anzahl der geöffneten Umgehungsdateihandles
5758
Über ByPassCSV übertragene Schreibanforderungen/s
5760
Über ByPassCSV übertragene Leseanforderungen/s
5762
Über ByPassCSV übertragene gelesene Bytes/s
5764
Über ByPassCSV übertragene geschriebene Bytes/s
5766
Komprimierte Bytes pro Sek.
5768
Komprimierte Antworten/s
5770
Komprimierte Anforderungen pro Sek.
5772
SMB-Serversitzungen
5774
Empfangene Bytes/s
5776
Anforderungen/Sek.
5778
Anzahl von Strukturverbindungen
5780
Anzahl derzeit geöffneter Dateien
5782
Gesendete Bytes/s
5784
Übertragene Bytes/s
5786
Derzeit ausstehende Anforderungen
5788
Sek./Anforderung (Durchschnitt)
5792
Schreibanforderungen/Sek.
5794
Sek./Schreibvorgang (Durchschnitt)
5798
Geschriebene Bytes/Sek.
5800
Leseanforderungen/Sek.
5802
Sek./Lesevorgang (Durchschnitt)
5806
Gelesene Bytes/s
5808
Gesamtanzahl geöffneter Dateien
5810
Geöffnete Dateien/Sek.
5812
Aktuelle Anzahl der geöffneten permanenten Dateihandles
5814
Gesamtanzahl erneut geöffneter permanenter Handles
5816
Gesamtanzahl permanenter Handles mit Fehler beim erneuten Öffnen
5818
Stabile Handles in Prozent
5822
Gesamtanzahl erneut geöffneter stabiler Handles
5824
Gesamtanzahl stabiler Handles mit Fehler beim erneuten Öffnen
5826
Beständige Handles in Prozent
5830
Gesamtanzahl erneut geöffneter beständiger Handles
5832
Gesamtanzahl beständiger Handles mit Fehler beim erneuten Öffnen
5834
Metadatenanforderungen/Sek.
5836
Durchschn. Sek./Datenanforderung
5840
Durchschn. Datenbytes/Anforderung
5844
Durchschn. Bytes/Lesevorgang
5848
Durchschn. Bytes/Schreibvorgang
5852
Durchschn. Warteschlangenlänge für Lesevorgänge
5854
Durchschn. Warteschlangenlänge für Schreibvorgänge
5856
Durchschn. Länge der Datenwarteschlange
5858
Datenbytes/Sek.
5860
Datenanforderungen/Sek.
5862
Aktuelle Länge der Datenwarteschlange
5864
SMB-Server
5866
Gelesene Bytes/Sek.
5868
Leseanforderungen/Sek.
5870
Geschriebene Bytes/Sek.
5872
Schreibanforderungen/Sek.
5874
Gesendete Byte/s
5876
Empfangene Bytes/s
6332
Anmeldedienst
6334
Auf Semaphore wartende
6336
Semaphorehalter
6338
Semaphoreübernahmen
6340
Semaphorezeitlimit
6342
Durchschnittliche Semaphorehaltezeit
6344
Basis der Semaphorehaltezeit
6346
Letzte Authentifizierungszeit
6348
Basiszeit der Authentifizierung
3966
XHCI Interrupter
3968
Interrupts/s
3970
DPCs/s
3972
Verarbeitete Ereignisse/DPC
3974
DPC-Anzahl
3976
EventRingFullCount
3978
DpcRequeueCount
3990
XHCI TransferRing
3992
Übertragungen/s
3994
Anzahl von Übertragungsfehlern
3996
Bytes/s
3998
Isoch-TDs/s
4000
Isoch-TD-Fehler/s
4002
Anzahl von Fehlern aufgrund eines fehlenden Diensts
4004
Unterlauf-/Überlaufanzahl
3980
XHCI CommonBuffer
3982
PagesTotal
3984
PagesInUse
3986
AllocationCount
3988
FreeCount
4020
Verteilte Routingtabelle
4022
Registrierungen
4024
Suchvorgänge
4026
Cacheeinträge
4028
Durchschnittliche Anzahl gesendeter Bytes/Sekunde
4030
Durchschnittliche Anzahl empfangener Bytes/Sekunde
4032
Geschätzte Wolkengröße
4034
Veraltete Cacheeinträge
4036
Sendefehler
4038
Empfangsfehler
4040
Gesendete Anfragemeldungen/Sekunde
4042
Solicit Messages Received/second
4044
Gesendete Ankündigungsmeldungen/Sekunde
4046
Empfangene Ankündigungsmeldungen/Sekunde
4048
Gesendete Anforderungsmeldungen/Sekunde
4050
Empfangene Anforderungsmeldungen/Sekunde
4052
Flood Messages Sent/second
4054
Flood Messages Received/second
4056
Gesendete Abfragemeldungen/Sekunde
4058
Empfangene Abfragemeldungen/Sekunde
4060
Authority Sent/second
4062
Authority Messages Received/second
4064
Gesendete Bestätigungsmeldungen/Sekunde
4066
Empfangene Bestätigungsmeldungen/Sekunde
4068
Gesendete Suchmeldungen/Sekunde
4070
Empfangene Suchmeldungen/Sekunde
4072
Empfangene unbekannte Nachrichten
3050
Filter für den PacketDirect-Empfang
3052
Übereinstimmende Pakete
3054
Übereinstimmende Pakete/s
3056
Übereinstimmende Bytes
3058
Übereinstimmende Bytes/s
3026
Leistungsindikatoren für die PacketDirect-Übertragung
3028
Übertragene Pakete
3030
Übertragene Pakete/s
3032
Übertragene Bytes
3034
Übertragene Bytes/s
3014
Aktivitäten der physischen Netzwerkschnittstellenkarte
3016
Energiezustand des Geräts
3018
Angehaltene Zeit in Prozent (unmittelbar)
3020
Angehaltene Zeit in Prozent (Lebensdauer)
3022
Übergänge zu geringem Energieverbrauch (Lebensdauer)
2912
Netzwerkschnittstellenkarten-Aktivität pro Prozessor
2914
DPCs in Warteschlange/s
2916
Interrupts/s
2918
Empfangsanzeigen/s
2920
Aufrufe zum Zurückgeben von Paketen/s
2922
Passive Aufrufe zum Zurückgeben von Paketen/s
2924
Empfangene Pakete/s
2926
Zurückgegebene Pakete/s
2928
Passiv zurückgegebene Pakete/s
2930
DPCs in Warteschlange für andere CPUs/s
2932
Anforderungsaufrufe pro Sekunde senden
2934
Passive Sendeanforderungsaufrufe/s
2936
Vollständige Aufrufe pro Sekunde senden
2938
Gesendete Pakete/s
2940
Passiv gesendete Pakete/s
2942
Gesendete abgeschlossene Pakete/s
2944
Erstellung von Scatter-Gather-Listenaufrufen/Sek.
2946
RSS-Indirektionstabellenänderungs-Aufrufe/s
2948
Empfangsanzeigen mit geringen Ressourcen/s
2950
Empfangene Pakete mit geringen Ressourcen/s
2952
TCP-Abladevorgang-Empfangsanzeigen/s
2954
TCP-Abladevorgang-Sendeanforderungsaufrufe/s
2956
Beim TCP-Abladevorgang empfangene Bytes/s
2958
Beim TCP-Abladevorgang gesendete Bytes/s
2960
Zurückgestellte DPCs/s
2962
Zusammengefügte Pakete/s
2964
Netzwerkaktivitätszyklen pro Prozessor
2966
Interrupt-DPC-Zyklen/s
2968
Interrupt-Zyklen/s
2970
NDIS-Empfangsanzeigezyklen/s
2972
Stapel-Empfangsanzeigezyklen/s
2974
NDIS-Rückgabepaketzyklen/s
2976
Miniport-Paketrückgabezyklen/s
2978
NDIS-Sendezyklen/s
2980
Miniport-Sendezyklen/s
2982
Abgeschlossene NDIS-Sendezyklen/s
2984
Erstellung von Scatter-Gather-Zyklen/s
2986
Miniport-RSS-Indirektionstabellenänderungs-Zyklen
2988
Abgeschlossene Stapelsendezyklen/s
2990
Interrupt-DPC-Latenzzyklen/s
3088
Tiefe der PacketDirect-Warteschlange
3090
Durchschnittliche Warteschlangentiefe
3092
Durchschnittliche Warteschlangennutzung %
3036
Leistungsindikatoren für den PacketDirect-Empfang
3038
Empfangene Pakete
3040
Empfangene Pakete/s
3042
Empfangene Bytes
3044
Empfangene Bytes/s
3046
Verworfene Pakete
3048
Verworfene Pakete/s
2992
RDMA-Aktivität
2994
RDMA - initiierte Verbindungen
2996
RDMA - akzeptierte Verbindungen
2998
RDMA - nicht erfolgreiche Verbindungsversuche
3000
RDMA - Verbindungsfehler
3002
RDMA - aktive Verbindungen
3004
RDMA - CQ-Fehler
3006
RDMA - eingehende Bytes/s
3008
RDMA - ausgehende Bytes/s
3010
RDMA - eingehende Frames/s
3012
RDMA - ausgehende Frames/s
3060
PacketDirect EC-Nutzung
3062
Prozessornummer
3064
Iterationen gesamt
3066
Iterationen/s
3068
Aktiv wartende Iterationen gesamt
3070
Aktiv wartende Iterationen/s
3074
% aktiv wartende Iterationen
3078
% Leerlaufzeit
3080
% aktive Wartezeit
3082
% Verarbeitungszeit
3084
Anzahl von TX-Warteschlangen
3086
Anzahl von RX-Warteschlangen
3788
Datenträgeraktivität des Dateisystems
3790
Vom Dateisystem gelesene Bytes
3792
Vom Dateisystem geschriebene Bytes
3690
Sitzung der Ereignisablaufverfolgung für Windows
3692
Pufferspeicherauslastung -- ausgelagerter Pool
3694
Pufferspeicherauslastung -- nicht ausgelagerter Pool
3696
Protokollierte Ereignisse pro Sekunde
3698
Verlorene Ereignisse
3700
Anzahl von Echtzeitconsumern
3518
Prozessorinformationen
3520
Prozessorzeit (%)
3522
Benutzerzeit (%)
3524
Privilegierte Zeit (%)
3526
Interrupts/s
3528
DPC-Zeit (%)
3530
Interruptzeit (%)
3532
DPCs in Warteschlange/s
3534
DPC-Rate
3536
Leerlaufzeit (%)
3538
% C1-Zeit
3540
% C2-Zeit
3542
% C3-Zeit
3544
C1-Übergänge/s
3546
C2-Übergänge/s
3548
C3-Übergänge/s
3550
% Prioritätszeit
3552
Parkstatus
3554
Prozessorfrequenz
3556
% der maximalen Frequenz
3558
Prozessorstatusflags
3560
Zeitinterrupts/s
3562
Durchschnittliche Leerlaufzeit
3566
Unterbrechungen des Leerlaufs/s
3568
% Prozessorleistung
3572
Prozessorauslastung
3576
Privilegierte Auslastung
3580
% Leistungslimit
3582
Kennzeichen für das Leistungslimit
3794
Thermozoneninformationen
3796
Temperatur
3798
% Passive Begrenzung
3800
Gründe für die Drosselung
3802
Hochpräzise Temperatur
3676
Ereignisablaufverfolgung für Windows
3678
Gesamtanzahl unterschiedlicher aktivierter Anbieter
3680
Gesamtanzahl unterschiedlicher, im Voraus aktivierter Anbieter
3682
Gesamtanzahl unterschiedlicher deaktivierter Anbieter
3684
Gesamtanzahl aktiver Sitzungen
3686
Gesamte Speicherauslastung --- ausgelagerter Pool
3688
Gesamte Speicherauslastung --- nicht ausgelagerter Pool
3590
Synchronisierung
3592
Übernommene Spinlocks/s
3594
Spinlockkonflikte/s
3596
Spinlockdrehungen/s
3598
Broadcastanforderungen für "IPI Send"
3600
Routinenanforderungen für "IPI Send"/s
3602
Softwareinterrupts für "IPI Send"/s
3604
Initialisierungen von Ausführungsressourcen gesamt/s
3606
Erneute Initialisierungen von Ausführungsressourcen gesamt/s
3608
Löschungen von Ausführungsressourcen gesamt/s
3610
Abrufe von Ausführungsressourcen gesamt/s
3612
Konflikte von Ausführungsressourcen gesamt/s
3614
Exklusive Freigaben von Ausführungsressourcen gesamt/s
3616
Öffentliche Freigaben von Ausführungsressourcen gesamt/s
3618
Konvertierung von exklusiv in öffentlich für Ausführungsressourcen gesamt/s
3620
Ausführungsressourcenversuche durch AcqExclLite/s
3622
Ausführungsressourcenabrufe durch AcqExclLite/s
3624
Rekursive exklusive Abrufe für Ausführungsressourcen durch AcqExclLite/s
3626
Ausführungsressourcenkonflikt durch AcqExclLite/s
3628
no-wait-Vorgänge für Ausführungsressourcen durch AcqExclLite/sec
3630
Ausführungsressourcenversuche durch AcqShrdLite/s
3632
Rekursive exklusive Abrufe für Ausführungsressourcen durch AcqShrdLite/s
3634
Ausführungsressourcenabfragen durch AcqShrdLite/s
3636
Rekursive freigegebene Abrufe für Ausführungsressourcen durch AcqShrdLite/s
3638
Ausführungsressourcenkonflikt durch AcqShrdLite/s
3640
no-wait-Vorgänge für Ausführungsressourcen durch AcqShrdLite/s
3642
Ausführungsressourcenversuche durch AcqShrdStarveExcl/s
3644
Rekursive exklusive Abfragen für Ausführungsressourcen durch AcqShrdStarveExcl/s
3646
Ausführungsressourcenabfragen durch AcqShrdStarveExcl/s
3648
Rekursive freigegebene Abfragen für Ausführungsressourcen durch AcqShrdStarveExcl/s
3650
Ausführungsressourcenkonflikt durch AcqShrdStarveExcl/s
3652
no-wait-Vorgänge für Ausführungsressourcen durch AcqShrdStarveExcl/s
3654
Ausführungsressourcenversuche durch AcqShrdWaitForExcl/s
3656
Rekursive exklusive Abfragen für Ausführungsressourcen durch AcqShrdWaitForExcl/s
3658
Ausführungsressourcenabfragen durch AcqShrdWaitForExcl/s
3660
Rekursive freigegebene Abrufe für Ausführungsressourcen durch AcqShrdWaitForExcl/s
3662
Ausführungsressourcenkonflikt durch AcqShrdWaitForExcl/s
3664
no-wait-Vorgänge für Ausführungsressourcen durch AcqShrdWaitForExcl/s
3666
Exklusive Festlegungen von Besitzerzeigern für Ausführungsressourcen/s
3668
Freigegebene Festlegungen von Besitzerzeigern für Ausführungsressourcen (Neuer Besitzer)/s
3670
Freigegebene Festlegungen von Besitzerzeigern für Ausführungsressourcen (Vorhandener Besitzer)/s
3672
Boost für Ausführungsressourcen für exklusive Besitzer/Sek.
3674
Boost für Ausführungsressourcen für freigegebene Besitzer/Sek.
3702
NUMA-Synchronisierung
3704
Abgerufene Spinlocks/s
3706
Spinlockkonflikte/s
3708
Spinlockdrehungen/s
3710
Broadcastanforderungen für "IPI Send"/s
3712
Routinenanforderungen für "IPI Send"/s
3714
Softwareinterrupts für "IPI Send"/s
3716
Initialisierungen von Ausführungsressourcen gesamt/s
3718
Erneute Initialisierungen von Ausführungsressourcen gesamt/s
3720
Löschungen von Ausführungsressourcen gesamt/s
3722
Abrufe von Ausführungsressourcen gesamt/s
3724
Konflikte von Ausführungsressourcen gesamt/s
3726
Exklusive Freigaben von Ausführungsressourcen gesamt/s
3728
Öffentliche Freigaben von Ausführungsressourcen gesamt/s
3730
Konvertierung von exklusiv in öffentlich für Ausführungsressourcen gesamt/s
3732
Ausführungsressourcenversuche durch AcqExclLite/s
3734
Ausführungsressourcenabrufe durch AcqExclLite/s
3736
Rekursive exklusive Abrufe für Ausführungsressourcen durch AcqExclLite/s
3738
Ausführungsressourcenkonflikte durch AcqExclLite/s
3740
no-wait-Vorgänge für Ausführungsressourcen durch AcqExclLite/s
3742
Ausführungsressourcenversuche durch AcqShrdLite/s
3744
Rekursive exklusive Abrufe für Ausführungsressourcen durch AcqShrdLite/s
3746
Ausführungsressourcenabfragen durch AcqShrdLite/s
3748
Rekursive freigegebene Abrufe für Ausführungsressourcen durch AcqShrdLite/s
3750
Ausführungsressourcenkonflikte durch AcqShrdLite/s
3752
no-wait-Vorgänge für Ausführungsressourcen durch AcqShrdLite/s
3754
Ausführungsressourcenversuche durch AcqShrdStarveExcl/s
3756
Rekursive exklusive Abfragen für Ausführungsressourcen durch AcqShrdStarveExcl/s
3758
Ausführungsressourcenabfragen durch AcqShrdStarveExcl/s
3760
Rekursive freigegebene Abfragen für Ausführungsressourcen durch AcqShrdStarveExcl/s
3762
Ausführungsressourcenkonflikte durch AcqShrdStarveExcl/s
3764
no-wait-Vorgänge für Ausführungsressourcen durch AcqShrdStarveExcl/s
3766
Ausführungsressourcenversuche durch AcqShrdWaitForExcl/s
3768
Rekursive exklusive Abfragen für Ausführungsressourcen durch AcqShrdWaitForExcl/s
3770
Ausführungsressourcenabfragen durch AcqShrdWaitForExcl/s
3772
Rekursive freigegebene Abrufe für Ausführungsressourcen durch AcqShrdWaitForExcl/s
3774
Ausführungsressourcenkonflikte durch AcqShrdWaitForExcl/s
3776
no-wait-Vorgänge für Ausführungsressourcen durch AcqShrdWaitForExcl/s
3778
Exklusive Festlegungen von Besitzerzeigern für Ausführungsressourcen/s
3780
Freigegebene Festlegungen von Besitzerzeigern für Ausführungsressourcen (Neuer Besitzer)/s
3782
Freigegebene Festlegungen von Besitzerzeigern für Ausführungsressourcen (Vorhandener Besitzer)/s
3784
Boost für Ausführungsressourcen für exklusive Besitzer/Sek.
3786
Boost für Ausführungsressourcen für freigegebene Besitzer/Sek.
5468
Windows-Zeitdienst
5470
Berechnete Zeitdifferenz
5472
Anpassung der Taktfrequenz
5474
Anpassung der Taktfrequenz (PPB)
5476
NTP-Roundtripverzögerung
5478
Anzahl von Zeitquellen des NTP-Clients
5480
Eingehende Anforderungen des NTP-Servers
5482
Ausgehende Antworten des NTP-Servers
5400
SMB-Clientfreigaben
5402
Gelesene Bytes/Sek.
5404
Geschriebene Bytes/Sek.
5406
Leseanforderungen/Sek.
5408
Schreibanforderungen/Sek.
5410
Durchschn. Bytes/Lesevorgang
5414
Durchschn. Bytes/Schreibvorgang
5418
Durchschn. Sek./Lesevorgang
5422
Durchschn. Sek./Schreibvorgang
5426
Datenbytes/Sek.
5428
Datenanforderungen/Sek.
5430
Durchschn. Datenbytes/Anforderung
5434
Durchschn. Sek./Datenanforderung
5438
Aktuelle Länge der Datenwarteschlange
5440
Durchschn. Warteschlangenlänge für Lesevorgänge
5442
Durchschn. Warteschlangenlänge für Schreibvorgänge
5444
Durchschn. Länge der Datenwarteschlange
5446
Metadatenanforderungen/Sek.
5448
Verzögerungen durch Anforderungslimit/Sek.
5450
Über SMB Direct übertragene gelesene Bytes/s
5452
Über SMB Direct übertragene geschriebene Bytes/s
5454
Über SMB Direct übertragene Leseanforderungen/s
5456
Über SMB Direct übertragene Schreibanforderungen/s
5458
Turbo-E/A – Lesevorgänge/s
5460
Turbo-E/A – Schreibvorgänge/s
5462
Komprimierte Anforderungen/Sek.
5464
Komprimierte Antworten/Sek.
5466
Gesendete komprimierte Bytes/s
5484
Netzwerk-QoS-Richtlinie
5486
Übertragene Pakete
5488
Übertragene Pakete/Sek.
5490
Übertragene Bytes
5492
Übertragene Bytes/Sek.
5494
Verworfene Pakete
5496
Verworfene Pakete/Sek.
4006
Ereignisprotokoll
4008
Aktivierte Kanäle
4010
WEVT-RPC-Aufrufe/Sek.
4012
Ereignisse/Sek.
4014
ELF-RPC-Aufrufe/Sek.
4016
Aktive Abonnements
4018
Ereignisfiltervorgänge/Sek.
9568
BranchCache
9570
Abruf: Bytes vom Server
9572
Abruf: Bytes vom Cache
9574
Abruf: Verarbeitete Bytes
9576
Ermittlung: Gewichtete durchschnittliche Ermittlungszeit
9578
SMB: Bytes vom Cache
9580
SMB: Bytes vom Server
9582
BITS: Bytes vom Cache
9584
BITS: Bytes vom Server
9586
WININET: Bytes vom Cache
9588
WININET: Bytes vom Server
9590
WINHTTP: Bytes vom Cache
9592
WINHTTP: Bytes vom Server
9594
ANDERE: Bytes vom Cache
9596
ANDERE: Bytes vom Server
9598
Ermittlung: Ermittlungsversuche
9600
Lokaler Cache: Abgeschlossene Cachedateisegmente
9602
Lokaler Cache: Unvollständige Cachedateisegmente
9604
Gehosteter Cache: Unterbreitete Angebote für Clientdateisegmente
9606
Abruf: Durchschnittliche Verzweigungsrate
9608
Ermittlung: Erfolgreiche Ermittlungen
9610
Gehosteter Cache: Warteschlangengröße für Segmentangebote
9612
Veröffentlichungscache: Veröffentlichte Inhalte
9614
Lokaler Cache: Durchschnittliche Zugriffsdauer
3432
WSMan-Kontingentstatistik
3434
Gesamte Anforderungen/Sekunde
3436
Verstöße gegen Benutzerkontingente/Sekunde
3438
Verstöße gegen Systemkontingente/Sekunde
3440
Aktive Shells
3442
Aktive Vorgänge
3444
Aktive Benutzer
3446
Prozess-ID
1914
Hyper-V VM-VID-Partition
1916
Zugeordnete physische Seiten
1918
Bevorzugter NUMA-Knotenindex
1920
Physische Remoteseiten
1922
ClientHandles
1924
CompressPackTimeInUs
1926
CompressUnpackTimeInUs
1928
CompressPackInputSizeInBytes
1930
CompressUnpackInputSizeInBytes
1932
CompressPackOutputSizeInBytes
1934
CompressUnpackOutputSizeInBytes
1936
CompressUnpackUncompressedInputSizeInBytes
1938
CompressPackDiscardedSizeInBytes
1940
CompressWorkspaceSizeInBytes
1942
CompressScratchPoolSizeInBytes
1944
CryptPackTimeInUs
1946
CryptUnpackTimeInUs
1948
CryptPackInputSizeInBytes
1950
CryptUnpackInputSizeInBytes
1952
CryptPackOutputSizeInBytes
1954
CryptUnpackOutputSizeInBytes
1956
CryptScratchPoolSizeInBytes
1958
HandlersRegistered
1960
HandlersIOPort
1962
HandlersException
1964
HandlersCPUID
1966
MemoryBlocks
1968
KmMemoryBlockPages
1970
KmifGpaLockAcquirePageCount
1972
KmifGpaLockAcquireRequestCount
1974
KmifGpaLockAcquireRequestCountDeferred
1976
KmifGpaLockAcquireRequestCountFailed
1978
KmifGpaLockAcquireRequestTime
1980
KmifGpaLockReleasePageCount
1982
KmifGpaLockReleaseRequestCount
1984
KmifGpaLockReleaseRequestTime
1986
KsrMbClaimCount
1988
KsrMbClaimRunCount
1990
KsrMbClaimTimeInUs
1992
KsrMbPersistCount
1994
KsrMbPersistRunCount
1996
KsrMbPersistTimeInUs
1998
MmAllocCacheRequestTimeInUs
2000
MmAllocCacheRequestCountTotal
2002
MmAllocCacheRequestPageYield
2004
MmAllocMdlPagesAllocated
2006
MmAllocRequestCountFailed
2008
MmAllocRequestCountPartial
2010
MmAllocRequestCountTotal
2012
MmAllocRequestTimeInUs
2014
MmAllocRequestTimeToSortInUs
2016
MbBackedGpaPageRanges
2018
MbBackedGpaPages
2020
MbBackedGpaRomPages
2022
MmioGpaPageRanges
2024
MmioGpaPages
2026
ParentPartitionMappings
2028
ParentPartitionMappingsDirect
2030
ClientNotifyMbps
2032
ReadMbpCount
2034
WriteMbpCount
2036
MbpReadNotifications
2038
MbpWriteNotifications
2040
VtlPageModifications
2042
VtlPageModificationFailed
2044
VtlProtectedPageCount
2046
OverheadBytes
2048
Preferred NUMA Node Mask
2050
PageQosHugeLocal
2052
PageQosHuge
2054
PageQosLargeLocal
2056
PageQosLarge
2058
PageQosLocal
2060
PageQosOther
2062
DmPagesBallooned
2064
DmPagesHotAdded
2066
DmPagesReserved
2068
DmOperationsBalloon
2070
DmOperationsHotAdd
2072
DmOperationsHotAddUndo
2074
DmOperationsUnballoon
2076
DmSlpMbpOpsDemandBack
2078
DmSlpMbpOpsPageIn
2080
DmSlpMbpOpsPageInSynced
2082
DmSlpMbpOpsPageOut
2084
DmSlpMbpOpsPageOutSyncedSkip
2086
DmSlpPagesSynced
2088
DmSlpPagesUnbacked
2090
DmSlpPagesUnbackedDeferred
2092
DmSlpPagesWorkingSet
2094
DmSlpPioReads
2096
DmSlpPioWrites
2098
DmSlpPioPagesRead
2100
DmSlpPioPagesWritten
2102
DmSlpFaultsForReads
2104
DmSlpFaultsForWrites
2106
GmatZeroedRangeCountFound
2108
GmatZeroedRangeCountSkipped
2110
GmatZeroedPageCountFound
2112
GmatZeroedPageCountSkipped
2114
GpaMappingWinHvCallCount
2116
GpaMappingWinHvCallTimeInUs
2118
GpaMappingPageCount
2120
MemXferOpsRecvMdlComplete
2122
MemXferOpsRecvMdlCompleteFailed
2124
MemXferOpsRecvMdlPrepare
2126
MemXferOpsRecvMdlPrepareFailed
2128
MemXferOpsRecvWrite
2130
MemXferOpsRecvWriteFailed
2132
MemXferOpsSend
2134
MemXferOpsSendCompleted
2136
MemXferOpsSendFailed
2138
MemXferPagesRecvMdlComplete
2140
MemXferPagesRecvMdlPrepare
2142
MemXferPagesRecvWrite
2144
MemXferPagesSend
2146
HashScanPageCount
2148
HashScanPageCountConstantFilled
2150
HashScanPageCountConstantFilledInChunks
2152
HashScanPageCountZeroFilled
2154
HashScanPageCountZeroFilledInChunks
2156
HashScanPageCountModified
2158
HashScanTimeInUs
2160
HvMemDepositCallbackCount
2162
HvMemDepositPageCount
2164
HvMemDepositRequestCount
2166
HvMemDepositRequestCountFailed
2168
HvMemDepositRequestTimeInUs
2170
VmAccessFaultCountForRead
2172
VmAccessFaultCountForWrite
2174
VmAccessFaultCountIntercepts
2176
VmAccessFaultCountInterceptsNotReschedulable
2178
VmAccessFaultCountInterceptsContextOverloads
2180
VmAccessFaultCountInterceptsReschedulable
2182
VmAccessFaultCountInterceptsReschedulableFastPath
2184
VmAccessFaultCountInterceptsReschedulableSlowPath
2186
VmAccessFaultCountTranslations
2188
VmAccessFaultTimeInUs
2190
VmHeatHintHotCount
2192
VmHeatHintHotTimeInUs
2194
VmHeatHintColdCount
2196
VmHeatHintColdTimeInUs
2198
VmSpeculativeFaultCount
2200
VmSpeculativeFaultTimeInUs
2202
VmPauseResumeNotifyCount
2204
VmPauseResumeNotifyTimeInUs
2206
InterceptsMSRRead
2208
InterceptsMSRWrite
2210
InterceptsIOPortRead
2212
InterceptsIOPortWrite
2214
InterceptProcessingDeferredCount
2216
InterceptProcessingDeferredTime
2218
InterceptApicEoiCountTotal
2220
InterceptApicEoiTimeTotal
2222
InterceptCpuidCountTotal
2224
InterceptCpuidTimeTotal
2226
InterceptExceptionCountTotal
2228
InterceptExceptionTimeTotal
2230
InterceptGpaCountTotal
2232
InterceptGpaTimeTotal
2234
InterceptInvalidVpRegisterValueCountTotal
2236
InterceptInvalidVpRegisterValueTimeTotal
2238
InterceptIoPortCountTotal
2240
InterceptIoPortTimeTotal
2242
InterceptMsrCountTotal
2244
InterceptMsrTimeTotal
2246
InterceptUnmappedGpaCountTotal
2248
InterceptUnmappedGpaTimeTotal
2250
InterceptUnrecoverableExceptionCountTotal
2252
InterceptUnrecoverableExceptionTimeTotal
2254
InterceptUnsupportedFeatureCountTotal
2256
InterceptUnsupportedFeatureTimeTotal
2258
InterceptTlbPageSizeMismatchCountTotal
2260
InterceptTlbPageSizeMismatchTimeTotal
2262
InterceptExtendedHypercallCountTotal
2264
InterceptExtendedHypercallTimeTotal
2266
InterceptMmioCountTotal
2268
InterceptMmioTimeTotal
2270
InterceptResetCountTotal
2272
InterceptResetTimeTotal
2274
InterceptRegisterCountTotal
2276
InterceptRegisterTimeTotal
2278
InterceptInterruptionDeliverableCountTotal
2280
InterceptInterruptionDeliverableTimeTotal
2282
InterceptHaltCountTotal
2284
InterceptHaltTimeTotal
2286
InterceptUnacceptedGpaCountTotal
2288
InterceptUnacceptedGpaTimeTotal
2290
InterceptGpaAttributeCountTotal
2292
InterceptGpaAttributeTimeTotal
2294
InterceptSynicEventCountTotal
2296
InterceptSynicEventTimeTotal
2298
InterceptEnablePartitionVtlCountTotal
2300
InterceptEnablePartitionVtlTimeTotal
2302
MsgMbpAccess
2304
MsgException
2306
MsgTripleFault
2308
MsgApicEoi
2310
MsgExecuteInstruction
2312
MsgMmio
2314
MsgRegister
2316
MsgHandlerUnregistered
2318
MsgStopRequestComplete
2320
MsgMmioRangeDestroyed
2322
MsgTerminateVm
2324
MsgGuestControlForPageCopy
2326
MsgCpuid
2328
MsgIoInstruction
2330
MsgMsr
2332
MsgReset
2334
MsgPassthroughIntercept
2336
MsgStopRequestCompleteDirect
2338
DaxAllocRequestMapTimeInUs
2340
DaxAllocRequestProbeAndLockTimeInUs
2342
DaxAllocRequestCountTotal
2344
DaxAllocRequestCountFailed
2346
PhysicalBufferAllocationPageCount
2348
PhysicalBufferAllocationTimeInUs
2350
CommitRamPageCount
2352
DecommitRamPageCount
2354
VaBackedPolicy
2356
IoctlGetPartitionPropertyCount
2358
IoctlGetPartitionPropertyTime
2360
IoctlRestorePartitionStateCount
2362
IoctlRestorePartitionStateTime
2364
IoctlAddVirtualProcessorCount
2366
IoctlAddVirtualProcessorTime
2368
IoctlAdjustNestedTlbSizeCount
2370
IoctlAdjustNestedTlbSizeTime
2372
IoctlAssertInterruptCount
2374
IoctlAssertInterruptTime
2376
IoctlChangeLifeStateCount
2378
IoctlChangeLifeStateTime
2380
IoctlCheckForIoInterceptCount
2382
IoctlCheckForIoInterceptTime
2384
IoctlClearInterruptCount
2386
IoctlClearInterruptTime
2388
IoctlCloneTemplateCreateCount
2390
IoctlCloneTemplateCreateTime
2392
IoctlCloneTemplateDestroyCount
2394
IoctlCloneTemplateDestroyTime
2396
IoctlCreateDaxFileMemoryBlockCount
2398
IoctlCreateDaxFileMemoryBlockTime
2400
IoctlCreateMemoryBlockCount
2402
IoctlCreateMemoryBlockTime
2404
IoctlCreateMemoryBlockGpaRangeCount
2406
IoctlCreateMemoryBlockGpaRangeTime
2408
IoctlCreateMmioGpaDoorbellCount
2410
IoctlCreateMmioGpaDoorbellTime
2412
IoctlCreateMmioGpaRangeCount
2414
IoctlCreateMmioGpaRangeTime
2416
IoctlCreateVaGpaRangeCount
2418
IoctlCreateVaGpaRangeTime
2420
IoctlCryptEncryptDecryptDataCount
2422
IoctlCryptEncryptDecryptDataTime
2424
IoctlCryptGetSessionCount
2426
IoctlCryptGetSessionTime
2428
IoctlCryptGetSecurityCookieCount
2430
IoctlCryptGetSecurityCookieTime
2432
IoctlCryptKeysInitializeCount
2434
IoctlCryptKeysInitializeTime
2436
IoctlCryptKeysReleaseCount
2438
IoctlCryptKeysReleaseTime
2440
IoctlDestroyGpaRangeCount
2442
IoctlDestroyGpaRangeTime
2444
IoctlDestroyMemoryBlockCount
2446
IoctlDestroyMemoryBlockTime
2448
IoctlDestroyMmioGpaDoorbellCount
2450
IoctlDestroyMmioGpaDoorbellTime
2452
IoctlDmBalloonCount
2454
IoctlDmBalloonTime
2456
IoctlDmConsolidationEnableCount
2458
IoctlDmConsolidationEnableTime
2460
IoctlDmConsolidationDisableCount
2462
IoctlDmConsolidationDisableTime
2464
IoctlDmHotAddCount
2466
IoctlDmHotAddTime
2468
IoctlDmHotAddUndoCount
2470
IoctlDmHotAddUndoTime
2472
IoctlDmQueryBackingStateCount
2474
IoctlDmQueryBackingStateTime
2476
IoctlDmSlpDisableCount
2478
IoctlDmSlpDisableTime
2480
IoctlDmSlpQueryCount
2482
IoctlDmSlpQueryTime
2484
IoctlDmSlpSetupCount
2486
IoctlDmSlpSetupTime
2488
IoctlDmSlpWaitForDisableCount
2490
IoctlDmSlpWaitForDisableTime
2492
IoctlDmUnballoonCount
2494
IoctlDmUnballoonTime
2496
IoctlDmWorkingSetModifyCount
2498
IoctlDmWorkingSetModifyTime
2500
IoctlEpfRestoreCount
2502
IoctlEpfRestoreTime
2504
IoctlEpfSaveCount
2506
IoctlEpfSaveTime
2508
IoctlEpfSuspendBeginCount
2510
IoctlEpfSuspendBeginTime
2512
IoctlEpfSuspendEndCount
2514
IoctlEpfSuspendEndTime
2516
IoctlFlushMemoryBlockPageRangeCount
2518
IoctlFlushMemoryBlockPageRangeTime
2520
IoctlFlushMemoryBlockMappingCount
2522
IoctlFlushMemoryBlockMappingTime
2524
IoctlGetHvMemoryBalanceCount
2526
IoctlGetHvMemoryBalanceTime
2528
IoctlGetHvPartitionIdCount
2530
IoctlGetHvPartitionIdTime
2532
IoctlGetIsolationLuidCount
2534
IoctlGetIsolationLuidTime
2536
IoctlGetVirtualProcessorStateCount
2538
IoctlGetVirtualProcessorStateTime
2540
IoctlGetVirtualProcessorStatusCount
2542
IoctlGetVirtualProcessorStatusTime
2544
IoctlGetVirtualProcessorXsaveStateCount
2546
IoctlGetVirtualProcessorXsaveStateTime
2548
IoctlGpaAccessTrackingDisableCount
2550
IoctlGpaAccessTrackingDisableTime
2552
IoctlGpaAccessTrackingEnableCount
2554
IoctlGpaAccessTrackingEnableTime
2556
IoctlHandleAndGetNextCount
2558
IoctlHandleAndGetNextTime
2560
IoctlInjectSyntheticMachineCheckEventCount
2562
IoctlInjectSyntheticMachineCheckEventTime
2564
IoctlMapHvStatsPageLocalCount
2566
IoctlMapHvStatsPageLocalTime
2568
IoctlMapHypercallDoorbellPageCount
2570
IoctlMapHypercallDoorbellPageTime
2572
IoctlMapMemoryBlockPageRangeCount
2574
IoctlMapMemoryBlockPageRangeTime
2576
IoctlMapVpStatePageCount
2578
IoctlMapVpStatePageTime
2580
IoctlMarkPagePoisonedCount
2582
IoctlMarkPagePoisonedTime
2584
IoctlMemoryBlockReadWriteAllocateBuffersCount
2586
IoctlMemoryBlockReadWriteAllocateBuffersTime
2588
IoctlMemoryBlockReadWriteDestroyBuffersCount
2590
IoctlMemoryBlockReadWriteDestroyBuffersTime
2592
IoctlMessageSlotHandleAndGetNextCount
2594
IoctlMessageSlotHandleAndGetNextTime
2596
IoctlMessageSlotMapCount
2598
IoctlMessageSlotMapTime
2600
IoctlPartitionFriendlyNameSetCount
2602
IoctlPartitionFriendlyNameSetTime
2604
IoctlPhuBeginCount
2606
IoctlPhuBeginTime
2608
IoctlPhuCommitCount
2610
IoctlPhuCommitTime
2612
IoctlPhuEndCount
2614
IoctlPhuEndTime
2616
IoctlPhuOpenMemoryBlockFileCount
2618
IoctlPhuOpenMemoryBlockFileTime
2620
IoctlPhuPersistGpaRangeCount
2622
IoctlPhuPersistGpaRangeTime
2624
IoctlPhuPersistMemoryBlockCount
2626
IoctlPhuPersistMemoryBlockTime
2628
IoctlPrefetchDirectMapRangesCount
2630
IoctlPrefetchDirectMapRangesTime
2632
IoctlQueryVaGpaRangeWorkingSetInfoCount
2634
IoctlQueryVaGpaRangeWorkingSetInfoTime
2636
IoctlReadMemoryBlockPageRangeCount
2638
IoctlReadMemoryBlockPageRangeTime
2640
IoctlRegisterApicEoiHandlerCount
2642
IoctlRegisterApicEoiHandlerTime
2644
IoctlRegisterCpuidHandlerCount
2646
IoctlRegisterCpuidHandlerTime
2648
IoctlRegisterExceptionHandlerCount
2650
IoctlRegisterExceptionHandlerTime
2652
IoctlRegisterIoPortHandlerCount
2654
IoctlRegisterIoPortHandlerTime
2656
IoctlRegisterMsrHandlerCount
2658
IoctlRegisterMsrHandlerTime
2660
IoctlRegisterTripleFaultHandlerCount
2662
IoctlRegisterTripleFaultHandlerTime
2664
IoctlRegisterCpuidResultCount
2666
IoctlRegisterCpuidResultTime
2668
IoctlReleaseCount
2670
IoctlReleaseTime
2672
IoctlRemoveVirtualProcessorCount
2674
IoctlRemoveVirtualProcessorTime
2676
IoctlReserveCount
2678
IoctlReserveTime
2680
IoctlResetCount
2682
IoctlResetTime
2684
IoctlResetPoisonedPageCount
2686
IoctlResetPoisonedPageTime
2688
IoctlSavePartitionStateCount
2690
IoctlSavePartitionStateTime
2692
IoctlSchedulerAssistRestoreCount
2694
IoctlSchedulerAssistRestoreTime
2696
IoctlSchedulerAssistSaveCount
2698
IoctlSchedulerAssistSaveTime
2700
IoctlSchedulerAssistSuspendCount
2702
IoctlSchedulerAssistSuspendTime
2704
IoctlSetMailboxKeyCount
2706
IoctlSetMailboxKeyTime
2708
IoctlSetMemoryBlockClientNotificationsCount
2710
IoctlSetMemoryBlockClientNotificationsTime
2712
IoctlSetMemoryBlockFlushAfterWriteCount
2714
IoctlSetMemoryBlockFlushAfterWriteTime
2716
IoctlSetMemoryBlockNotificationQueueCount
2718
IoctlSetMemoryBlockNotificationQueueTime
2720
IoctlSetPartitionPropertyCount
2722
IoctlSetPartitionPropertyTime
2724
IoctlSetupMessageQueueCount
2726
IoctlSetupMessageQueueTime
2728
IoctlSetupPartitionCount
2730
IoctlSetupPartitionTime
2732
IoctlSetVirtualProcessorStateCount
2734
IoctlSetVirtualProcessorStateTime
2736
IoctlSetVirtualProcessorXsaveStateCount
2738
IoctlSetVirtualProcessorXsaveStateTime
2740
IoctlSgxResetMemoryBlocksCount
2742
IoctlSgxResetMemoryBlocksTime
2744
IoctlStartVirtualProcessorCount
2746
IoctlStartVirtualProcessorTime
2748
IoctlStatisticsMapCount
2750
IoctlStatisticsMapTime
2752
IoctlStatisticsUnMapCount
2754
IoctlStatisticsUnMapTime
2756
IoctlStopVirtualProcessorCount
2758
IoctlStopVirtualProcessorTime
2760
IoctlSuspendApplyCount
2762
IoctlSuspendApplyTime
2764
IoctlSuspendClearCount
2766
IoctlSuspendClearTime
2768
IoctlTranslateGpaCount
2770
IoctlTranslateGpaTime
2772
IoctlTranslateGvaCount
2774
IoctlTranslateGvaTime
2776
IoctlTrimPartitionMemoryCount
2778
IoctlTrimPartitionMemoryTime
2780
IoctlUnmapHvStatsPageLocalCount
2782
IoctlUnmapHvStatsPageLocalTime
2784
IoctlUnmapMemoryBlockPageRangeCount
2786
IoctlUnmapMemoryBlockPageRangeTime
2788
IoctlUnregisterCpuidResultCount
2790
IoctlUnregisterCpuidResultTime
2792
IoctlUnregisterHandlerCount
2794
IoctlUnregisterHandlerTime
2796
IoctlWriteMemoryBlockPageRangeCount
2798
IoctlWriteMemoryBlockPageRangeTime
2800
IoctlMemoryXferConnectOpenCount
2802
IoctlMemoryXferConnectOpenTime
2804
IoctlMemoryXferConnectEnableCount
2806
IoctlMemoryXferConnectEnableTime
2808
IoctlMemoryXferSendCount
2810
IoctlMemoryXferSendTime
2812
IoctlMemoryXferConnectCloseCount
2814
IoctlMemoryXferConnectCloseTime
2816
IoctlMemoryXferConnectDisableCount
2818
IoctlMemoryXferConnectDisableTime
2820
IoctlVsmGetPartitionConfigCount
2822
IoctlVsmGetPartitionConfigTime
2824
IoctlVsmSetPartitionConfigCount
2826
IoctlVsmSetPartitionConfigTime
2828
IoctlVsmQueryMemoryBlockProtectionsCount
2830
IoctlVsmQueryMemoryBlockProtectionsTime
2832
IoctlVsmGetMemoryBlockProtectionsCount
2834
IoctlVsmGetMemoryBlockProtectionsTime
2836
IoctlVsmSetMemoryBlockProtectionsCount
2838
IoctlVsmSetMemoryBlockProtectionsTime
2840
IoctlVsmEnableVpVtlCount
2842
IoctlVsmEnableVpVtlTime
2844
IoctlVsmCheckGpaPageVtlAccessCount
2846
IoctlVsmCheckGpaPageVtlAccessTime
2848
IoctlVsmQueryProtectionsDirtyCount
2850
IoctlVsmQueryProtectionsDirtyTime
2852
IoctlVsmPrecommitMgmtVtlPageRangeCount
2854
IoctlVsmPrecommitMgmtVtlPageRangeTime
2856
IoctlSetPeerProcessCount
2858
IoctlSetPeerProcessTime
2860
IoctlReadWriteMappedMemoryBlockPageRangeCount
2862
IoctlReadWriteMappedMemoryBlockPageRangeTime
2864
IoctlControlGpaAccessTrackingCount
2866
IoctlControlGpaAccessTrackingTime
2868
IoctlDbgProtectMemoryBlockEnableCount
2870
IoctlDbgProtectMemoryBlockEnableTime
2872
IoctlDbgProtectMemoryBlockDisableCount
2874
IoctlDbgProtectMemoryBlockDisableTime
2876
IoctlDbgProtectMemoryBlockGetBitmapCount
2878
IoctlDbgProtectMemoryBlockGetBitmapTime
2880
IoctlCreateVaGpaRangeSpecifyUserVaCount
2882
IoctlCreateVaGpaRangeSpecifyUserVaTime
2884
IoctlExoMapGpaRangeCount
2886
IoctlExoMapGpaRangeTime
2888
IoctlExoUnmapGpaRangeCount
2890
IoctlExoUnmapGpaRangeTime
2892
IoctlExoControlGpaAccessTrackingCount
2894
IoctlExoControlGpaAccessTrackingTime
2896
IoctlInstallExoInterceptCount
2898
IoctlInstallExoInterceptTime
2900
IoctlExoGetLapicStateCount
2902
IoctlExoGetLapicStateTime
2904
IoctlExoSetLapicStateCount
2906
IoctlExoSetLapicStateTime
2908
IoctlExoAccessFaultCount
2910
IoctlExoAccessFaultTime
4776
RAS
4778
Clients gesamt
4780
Clients maximal
4782
Nicht erfolgreiche Authentifizierungen
4784
Von getrennten Clients empfangene Bytes
4786
Von getrennten Clients übertragene Bytes
#>
