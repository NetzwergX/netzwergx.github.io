---
title: "Neues Layout"
layout: post
categories: [de]
tags: [jekyll, liquid, twitter, bootstrap, html5shiv, responsive, css, blog]
lang: de
---
For etwa 4 1/2 Monaten habe ich gerade erst das [Layout geändert], und nun schon wieder eine Änderung?
Wie kommt es dazu?


Nun, da kommen mehrere Dinge zusammen. Zunächst einmal gibt es zwei neue Jekyll Versionen, inzwischen
sind wir da bei Version 1.2.x, und zum andere habe ich mich länger mit Twitter Bootstrap (TW BS) beschäftigt,
um JTT zu aktualisieren. Dabei sind mir einige erhebliche Mängel an TW BS aufgefallen. Außerdem habe ich
festgestellt, dass ich einige der Ziele, die ich mir mit dem neuen Layout gesetzt hatte, so nicht erreichen konnte.

Das neue Layout benutzt normalize.css um größtmögliche Browserkompatibilität herzustellen, sowie html5shiv.js um
Kompatibilität mit älteren IE Versionen herzustellen.

Gleichzeitig habe ich mich selber um die Implementierung von resposiveness sowie vernünftiger Drucker-Stile gekümmert.
Alles in allem ist die *umkomprimierte* CSS Datei mitsamt Kommentaren inzwischen nur noch unter 3kB groß! Dies zeigt
denke ich sehr gut, dass ich mein Ziel, ein sowohl optisch als auch technisch leichtgewichtiges (light-weight) Layout
zu schaffen durchaus erreicht habe.

Insgesamt verbraucht das CSS für meine Seite unter 15kB - 7.5kb für die unkomprimierte normalize.css Datei und nochmal 3.5kB
für die Anweisungen zum hervorheben von Quellcode kommen noch dazu. Dank GZIP-Komprimierung lässt sich das bereits auf 5.4 kB reduzieren.
Eine weitere Optionen wäre minifizierung der datein zum entfernen überflüssiger Leerezichen, Zeilenumbrüche und Kommentare, doch
angesichts der bereits so recht guten Ergebnisse habe ich darauf verzichtet. Allerdings sind doch ein erheblicher Anteil an 
Kommentaren vorhanden, zumindest in normalize.css, sodass eine minifizierung sicherlich nochmal Einsparpotential bietet.

Während die Größe der Seite ein Aspekt ist, so gab es jedoch nich weit wichtigere Aspekte, die dazu geführt haben,
dass ich Bootstrap nicht mehr nutze.

### Die Nachteile von Twitter Bootstrap
Bootstrap hat viele Vorteile, und ich kann mir durchaus vorstellen, TW BS für einige Seiten, die nur Dokumentation
von Softwareprojekten enthalten, zu benutzen.

Für einen persönlichen Blog bzw. meine eigene Seite hat Bootstrap aber zu viele Nachteile.

#### 1. Zu viele Voreinstellungen (defaults)
Bootstrap kommt mit einer ganzen Menge von vorgefertigten Typographie-Elementen daher. Dies ist gut zum schnellen Erstellen
eines Prototypen und für generische Seiten, bietet jedoch den nachteil, dass das anpassen an persönliche Vorlieben sehr, sehr
schwierig ist. Pure.css bietet hier eine gute Alternative, allerdings hat pure.css z.B. keine vernünftig funktionierenden
responsive Menüs.

#### 2. Zu umfangreiches Markup
Das Markup von Bootsrap ist extrem umfangreich, bereits für einfache Elemente. ich habe gerne übersichtlichen und leicht wartbaren
Quelltext, davon ist bei Bootsrap schon nach kurzer Zeit nicht mehr viel zu sehen. Außerdem werden CSS Klassen nicht semantisch 
verwendet, welches ein weiterer Malus für mich ist. Ich möchte mit CSS auszeichnen *was* ein Element darstellen soll, nicht *wie*.
Um ein Beispiel zu geben:

```html
	<h1 class="marginTop borderBottom">Überschrift</h1>
```	
vs.

```html
	<h1 class="mainHeading">Überschrift</h1>
```
	
Hier ist die zweite Variante Meiner meinung nach deutlich sinnvoller, da sie die Aufgabe des Elementes beschreibt. Erstere Variante
liefert meiner meiung nach kaum Vorteile gegenüber der Benutzung von inline-Styles.


Ein weiterer Kritikpunkt an Bootstrap ist, dass man oft redundante Klassennamen vergeben muss:

```html
	<div class="collapse navbar-collapse navbar-ex1-collapse"> ... </div>
```
Dies ist eindeutig nicht gerade eine "schlanke" Lösung.

#### 3. Nicht schlank genug
Bootstrap ist für meine Seite schlicht zu umfangreich. Mit viel weniger Aufwand, geringeren Markup und viel weniger Stress beim überschreiben
von Vorgabewerten habe ich eine sowohl optisch als auch technisch viel schlankere Seite zaubern können.

### Mehrpsrachigkeit
Ein weiterer Punkt war die Mehrpsrachigkeit. jekyll hat hier leider von haus aus wenig zu bieten, so dass einige Kniffe notwendig
werden. Ich musste also eh an alle Templates ran, und somit war jetzt eine Gelegenheit gekommen, die Seite noch einmal für mindestens
zwei Jahre auf einen neuen Stand zu bringen.

Darüber, wie ich die Mehrsprachigkeit hier konkret umgesetzt habe, werde ich an anderer Stelle noch einmal schreiben.

#### Im Vergleich
Beim optischen vergleich mit der alten version der webseite fällt sofort auf, um wie viel schlanker sie geworden ist.
es gbt keine erschlagenden, schwarzen Menües mehr, der Ton ist hell und das Gesamterscheinungsbild ist auf eines konzentriert.
Den Inhalt.

![Altes Layout](assets/images/Home _Page_1_Sebastian Teumert_BS.png "Altes Layout")
