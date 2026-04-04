import 'strings.dart';
import 'am.dart';
import 'or.dart';

class RecommendationsStrings {
  final String recommendationsTitle;
  final String recommendationsSubtitle;
  final String searchHerbs;
  final String whatAreYourConcerns;
  final String selectAllThatApply;
  final String selectYourConcerns;
  final String chooseConditions;
  final String tipsForBestResults;
  final String tip1;
  final String tip2;
  final String tip3;
  final String getSuggestions;
  final String selectAtLeastOne;
  final String footer;

  const RecommendationsStrings({
    required this.recommendationsTitle,
    required this.recommendationsSubtitle,
    required this.searchHerbs,
    required this.whatAreYourConcerns,
    required this.selectAllThatApply,
    required this.selectYourConcerns,
    required this.chooseConditions,
    required this.tipsForBestResults,
    required this.tip1,
    required this.tip2,
    required this.tip3,
    required this.getSuggestions,
    required this.selectAtLeastOne,
    required this.footer,
  });

  factory RecommendationsStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static RecommendationsStrings _fromEn() => RecommendationsStrings(
        recommendationsTitle: AppStrings.recommendationsTitle,
        recommendationsSubtitle: AppStrings.recommendationsSubtitle,
        searchHerbs: AppStrings.searchHerbs,
        whatAreYourConcerns: AppStrings.whatAreYourConcerns,
        selectAllThatApply: AppStrings.selectAllThatApply,
        selectYourConcerns: AppStrings.selectYourConcerns,
        chooseConditions: AppStrings.chooseConditions,
        tipsForBestResults: AppStrings.tipsForBestResults,
        tip1: AppStrings.tip1,
        tip2: AppStrings.tip2,
        tip3: AppStrings.tip3,
        getSuggestions: AppStrings.getSuggestions,
        selectAtLeastOne: AppStrings.selectAtLeastOne,
        footer: AppStrings.footer,
      );

  static RecommendationsStrings _fromAm() => RecommendationsStrings(
        recommendationsTitle: AppStringsAm.recommendationsTitle,
        recommendationsSubtitle: AppStringsAm.recommendationsSubtitle,
        searchHerbs: AppStringsAm.searchHerbs,
        whatAreYourConcerns: AppStringsAm.whatAreYourConcerns,
        selectAllThatApply: AppStringsAm.selectAllThatApply,
        selectYourConcerns: AppStringsAm.selectYourConcerns,
        chooseConditions: AppStringsAm.chooseConditions,
        tipsForBestResults: AppStringsAm.tipsForBestResults,
        tip1: AppStringsAm.tip1,
        tip2: AppStringsAm.tip2,
        tip3: AppStringsAm.tip3,
        getSuggestions: AppStringsAm.getSuggestions,
        selectAtLeastOne: AppStringsAm.selectAtLeastOne,
        footer: AppStringsAm.footer,
      );

  static RecommendationsStrings _fromOr() => RecommendationsStrings(
        recommendationsTitle: AppStringsOr.recommendationsTitle,
        recommendationsSubtitle: AppStringsOr.recommendationsSubtitle,
        searchHerbs: AppStringsOr.searchHerbs,
        whatAreYourConcerns: AppStringsOr.whatAreYourConcerns,
        selectAllThatApply: AppStringsOr.selectAllThatApply,
        selectYourConcerns: AppStringsOr.selectYourConcerns,
        chooseConditions: AppStringsOr.chooseConditions,
        tipsForBestResults: AppStringsOr.tipsForBestResults,
        tip1: AppStringsOr.tip1,
        tip2: AppStringsOr.tip2,
        tip3: AppStringsOr.tip3,
        getSuggestions: AppStringsOr.getSuggestions,
        selectAtLeastOne: AppStringsOr.selectAtLeastOne,
        footer: AppStringsOr.footer,
      );
}
