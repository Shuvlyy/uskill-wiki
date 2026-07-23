import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'package:app/l10n/app_localizations.dart';

class Utils {

  static Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

}


extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String translateObjective(String objective) {
    switch (objective) {
      case 'La ponctuation': return l10n.objLaPonctuation;
      case 'Le nom': return l10n.objLeNom;
      case 'Le complément du nom': return l10n.objLeComplMentDuNom;
      case 'Le présent de l\'indicatif': return l10n.objLePrSentDeLIndicatif;
      case 'L\'impératif': return l10n.objLImpRatif;
      case 'Le passé': return l10n.objLePass;
      case 'Le futur': return l10n.objLeFutur;
      case 'Le conditionnel': return l10n.objLeConditionnel;
      case 'Le subjonctif': return l10n.objLeSubjonctif;
      case 'Le passif': return l10n.objLePassif;
      case 'Le discours rapporté': return l10n.objLeDiscoursRapport;
      case 'L\'hypothèse': return l10n.objLHypothSe;
      case 'La modalisation': return l10n.objLaModalisation;
      case 'La mise en relief': return l10n.objLaMiseEnRelief;
      case 'L\'énonciation': return l10n.objLNonciation;
      case 'Les pronoms': return l10n.objLesPronoms;
      case 'Les déterminants': return l10n.objLesDTerminants;
      case 'Le comparatif et le superlatif': return l10n.objLeComparatifEtLeSuperlatif;
      case 'L\'adjectif': return l10n.objLAdjectif;
      case 'L\'interrogation': return l10n.objLInterrogation;
      case 'La négation': return l10n.objLaNGation;
      case 'Les présentatifs': return l10n.objLesPrSentatifs;
      case 'La localisation spatiale': return l10n.objLaLocalisationSpatiale;
      case 'La localisation temporelle': return l10n.objLaLocalisationTemporelle;
      case 'Articulateurs chronologiques (du discours)': return l10n.objArticulateursChronologiquesDuDiscours;
      case 'Les articulateurs logiques': return l10n.objLesArticulateursLogiques;
      default: return objective;
    }
  }
}
