import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mach_mit/constants.dart';

/// Dieser Screen enthält die echten Impressumsangaben gemäß § 5 DDG
/// (Digitale-Dienste-Gesetz, seit Mai 2024 Nachfolger des TMG) sowie
/// § 18 MStV. Bei Änderungen (z. B. Gewerbeanmeldung, USt-IdNr.,
/// Monetarisierung) muss dieser Screen entsprechend aktualisiert werden.
class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              color: text_color2,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(color: text_color1, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back),
                    color: text_color1,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Impressum',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: text_color1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _section(
                        'ANGABEN GEM\u00c4SS § 5 DDG',
                        'Faris Ahmad\n'
                            'Bockauer Weg 31\n'
                            '08340 Schwarzenberg/Erzgebirge\n'
                            'Deutschland',
                      ),
                      _section(
                        'KONTAKT',
                        'Telefon: +49 1556 7131537\n'
                            'E-Mail: farisahmad3x6@gmail.com',
                      ),
                      _section(
                        'VERANTWORTLICH F\u00dcR DEN INHALT (§ 18 MStV)',
                        'Faris Ahmad, Anschrift wie oben.',
                      ),
                      _section(
                        'STREITSCHLICHTUNG',
                        'Die Europ\u00e4ische Kommission stellt eine Plattform '
                            'zur Online-Streitbeilegung (OS) bereit: '
                            'https://ec.europa.eu/consumers/odr/. '
                            'Ich bin nicht verpflichtet und nicht bereit, an '
                            'Streitbeilegungsverfahren vor einer '
                            'Verbraucherschlichtungsstelle teilzunehmen.',
                      ),
                      _section(
                        'HAFTUNG F\u00dcR INHALTE',
                        'Als Diensteanbieter bin ich gem\u00e4\u00df den '
                            'allgemeinen Gesetzen f\u00fcr eigene Inhalte auf '
                            'dieser App verantwortlich. Ich bin jedoch '
                            'nicht verpflichtet, \u00fcbermittelte oder '
                            'gespeicherte fremde Informationen (etwa von '
                            'Nutzern eingestellte Inhalte) zu \u00fcberwachen '
                            'oder nach Umst\u00e4nden zu forschen, die auf '
                            'eine rechtswidrige T\u00e4tigkeit hinweisen. '
                            'Verpflichtungen zur Entfernung oder Sperrung '
                            'der Nutzung von Informationen nach den '
                            'allgemeinen Gesetzen bleiben hiervon '
                            'unber\u00fchrt. Eine diesbez\u00fcgliche Haftung '
                            'ist erst ab dem Zeitpunkt der Kenntnis einer '
                            'konkreten Rechtsverletzung m\u00f6glich. Bei '
                            'Bekanntwerden entsprechender '
                            'Rechtsverletzungen werde ich diese Inhalte '
                            'umgehend entfernen.',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
