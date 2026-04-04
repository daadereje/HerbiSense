import 'strings.dart';
import 'am.dart';
import 'or.dart';

/// Minimal string bundle for the Home screen, selecting from
/// English (`strings.dart`), Amharic (`am.dart`), and Oromo (`or.dart`).
class HomeStrings {
  final String homeTitle;
  final String homeSubtitle;
  final String howToUse;
  final String howToUseSubtitle;
  final String step1Title;
  final String step1Desc;
  final String step2Title;
  final String step2Desc;
  final String step3Title;
  final String step3Desc;
  final String step4Title;
  final String step4Desc;
  final String whyChoose;
  final String herbsCount;
  final String whoVerified;
  final String runBasedSystem;
  final String comprehensiveDb;
  final String comprehensiveDbDesc;
  final String communityDriven;
  final String multilingualAccess;
  final String fastReliable;
  final String alignedStrategy;
  final String evidenceBased;
  final String evidenceBasedDesc;
  final String threeLanguages;
  final String instantResults;
  final String getStarted;
  final String personalized;
  final String traditionalWisdom;
  final String safeAndNatural;
  final String trustedTitle;
  final String trustedDesc;
  final String accuracy98;
  final String healersContribute;
  final String verifiedSite;

  const HomeStrings({
    required this.homeTitle,
    required this.homeSubtitle,
    required this.howToUse,
    required this.howToUseSubtitle,
    required this.step1Title,
    required this.step1Desc,
    required this.step2Title,
    required this.step2Desc,
    required this.step3Title,
    required this.step3Desc,
    required this.step4Title,
    required this.step4Desc,
    required this.whyChoose,
    required this.herbsCount,
    required this.whoVerified,
    required this.runBasedSystem,
    required this.comprehensiveDb,
    required this.comprehensiveDbDesc,
    required this.communityDriven,
    required this.multilingualAccess,
    required this.fastReliable,
    required this.alignedStrategy,
    required this.evidenceBased,
    required this.evidenceBasedDesc,
    required this.threeLanguages,
    required this.instantResults,
    required this.getStarted,
    required this.personalized,
    required this.traditionalWisdom,
    required this.safeAndNatural,
    required this.trustedTitle,
    required this.trustedDesc,
    required this.accuracy98,
    required this.healersContribute,
    required this.verifiedSite,
  });

  factory HomeStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static HomeStrings _fromEn() => HomeStrings(
        homeTitle: AppStrings.homeTitle,
        homeSubtitle: AppStrings.homeSubtitle,
        howToUse: AppStrings.howToUse,
        howToUseSubtitle: AppStrings.howToUseSubtitle,
        step1Title: AppStrings.step1Title,
        step1Desc: AppStrings.step1Desc,
        step2Title: AppStrings.step2Title,
        step2Desc: AppStrings.step2Desc,
        step3Title: AppStrings.step3Title,
        step3Desc: AppStrings.step3Desc,
        step4Title: AppStrings.step4Title,
        step4Desc: AppStrings.step4Desc,
        whyChoose: AppStrings.whyChoose,
        herbsCount: AppStrings.herbsCount,
        whoVerified: AppStrings.whoVerified,
        runBasedSystem: AppStrings.runBasedSystem,
        comprehensiveDb: AppStrings.comprehensiveDb,
        comprehensiveDbDesc: AppStrings.comprehensiveDbDesc,
        communityDriven: AppStrings.communityDriven,
        multilingualAccess: AppStrings.multilingualAccess,
        fastReliable: AppStrings.fastReliable,
        alignedStrategy: AppStrings.alignedStrategy,
        evidenceBased: AppStrings.evidenceBased,
        evidenceBasedDesc: AppStrings.evidenceBasedDesc,
        threeLanguages: AppStrings.threeLanguages,
        instantResults: AppStrings.instantResults,
        getStarted: AppStrings.getStarted,
        personalized: AppStrings.personalized,
        traditionalWisdom: AppStrings.traditionalWisdom,
        safeAndNatural: AppStrings.safeAndNatural,
        trustedTitle: AppStrings.trustedTitle,
        trustedDesc: AppStrings.trustedDesc,
        accuracy98: AppStrings.accuracy98,
        healersContribute: AppStrings.healersContribute,
        verifiedSite: AppStrings.verifiedSite,
      );

  static HomeStrings _fromAm() => HomeStrings(
        homeTitle: AppStringsAm.homeTitle,
        homeSubtitle: AppStringsAm.homeSubtitle,
        howToUse: AppStringsAm.howToUse,
        howToUseSubtitle: AppStringsAm.howToUseSubtitle,
        step1Title: AppStringsAm.step1Title,
        step1Desc: AppStringsAm.step1Desc,
        step2Title: AppStringsAm.step2Title,
        step2Desc: AppStringsAm.step2Desc,
        step3Title: AppStringsAm.step3Title,
        step3Desc: AppStringsAm.step3Desc,
        step4Title: AppStringsAm.step4Title,
        step4Desc: AppStringsAm.step4Desc,
        whyChoose: AppStringsAm.whyChoose,
        herbsCount: AppStringsAm.herbsCount,
        whoVerified: AppStringsAm.whoVerified,
        runBasedSystem: AppStringsAm.runBasedSystem,
        comprehensiveDb: AppStringsAm.comprehensiveDb,
        comprehensiveDbDesc: AppStringsAm.comprehensiveDbDesc,
        communityDriven: AppStringsAm.communityDriven,
        multilingualAccess: AppStringsAm.multilingualAccess,
        fastReliable: AppStringsAm.fastReliable,
        alignedStrategy: AppStringsAm.alignedStrategy,
        evidenceBased: AppStringsAm.evidenceBased,
        evidenceBasedDesc: AppStringsAm.evidenceBasedDesc,
        threeLanguages: AppStringsAm.threeLanguages,
        instantResults: AppStringsAm.instantResults,
        getStarted: AppStringsAm.getStarted,
        personalized: AppStringsAm.personalized,
        traditionalWisdom: AppStringsAm.traditionalWisdom,
        safeAndNatural: AppStringsAm.safeAndNatural,
        trustedTitle: AppStringsAm.trustedTitle,
        trustedDesc: AppStringsAm.trustedDesc,
        accuracy98: AppStringsAm.accuracy98,
        healersContribute: AppStringsAm.healersContribute,
        verifiedSite: AppStringsAm.verifiedSite,
      );

  static HomeStrings _fromOr() => HomeStrings(
        homeTitle: AppStringsOr.homeTitle,
        homeSubtitle: AppStringsOr.homeSubtitle,
        howToUse: AppStringsOr.howToUse,
        howToUseSubtitle: AppStringsOr.howToUseSubtitle,
        step1Title: AppStringsOr.step1Title,
        step1Desc: AppStringsOr.step1Desc,
        step2Title: AppStringsOr.step2Title,
        step2Desc: AppStringsOr.step2Desc,
        step3Title: AppStringsOr.step3Title,
        step3Desc: AppStringsOr.step3Desc,
        step4Title: AppStringsOr.step4Title,
        step4Desc: AppStringsOr.step4Desc,
        whyChoose: AppStringsOr.whyChoose,
        herbsCount: AppStringsOr.herbsCount,
        whoVerified: AppStringsOr.whoVerified,
        runBasedSystem: AppStringsOr.runBasedSystem,
        comprehensiveDb: AppStringsOr.comprehensiveDb,
        comprehensiveDbDesc: AppStringsOr.comprehensiveDbDesc,
        communityDriven: AppStringsOr.communityDriven,
        multilingualAccess: AppStringsOr.multilingualAccess,
        fastReliable: AppStringsOr.fastReliable,
        alignedStrategy: AppStringsOr.alignedStrategy,
        evidenceBased: AppStringsOr.evidenceBased,
        evidenceBasedDesc: AppStringsOr.evidenceBasedDesc,
        threeLanguages: AppStringsOr.threeLanguages,
        instantResults: AppStringsOr.instantResults,
        getStarted: AppStringsOr.getStarted,
        personalized: AppStringsOr.personalized,
        traditionalWisdom: AppStringsOr.traditionalWisdom,
        safeAndNatural: AppStringsOr.safeAndNatural,
        trustedTitle: AppStringsOr.trustedTitle,
        trustedDesc: AppStringsOr.trustedDesc,
        accuracy98: AppStringsOr.accuracy98,
        healersContribute: AppStringsOr.healersContribute,
        verifiedSite: AppStringsOr.verifiedSite,
      );
}
