import 'strings.dart';
import 'am.dart';
import 'or.dart';

class FavoritesStrings {
  final String favoritesTitle;
  final String favoritesSubtitle;
  final String favoritesEmpty;
  final String favoritesCountLabel;
  final String favoritesLoadErrorTitle;
  final String favoritesLoadErrorBody;
  final String favoritesLinkedHerbError;
  final String favoritesHerbNotFound;
  final String favoritesOpenTooltip;
  final String favoritesRemoveTooltip;
  final String favoritesRemovedSnack;
  final String favoritesRemoveFailSnack;

  const FavoritesStrings({
    required this.favoritesTitle,
    required this.favoritesSubtitle,
    required this.favoritesEmpty,
    required this.favoritesCountLabel,
    required this.favoritesLoadErrorTitle,
    required this.favoritesLoadErrorBody,
    required this.favoritesLinkedHerbError,
    required this.favoritesHerbNotFound,
    required this.favoritesOpenTooltip,
    required this.favoritesRemoveTooltip,
    required this.favoritesRemovedSnack,
    required this.favoritesRemoveFailSnack,
  });

  factory FavoritesStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static FavoritesStrings _fromEn() => FavoritesStrings(
        favoritesTitle: AppStrings.favoritesTitle,
        favoritesSubtitle: AppStrings.favoritesSubtitle,
        favoritesEmpty: AppStrings.favoritesEmpty,
        favoritesCountLabel: AppStrings.favoritesCountLabel,
        favoritesLoadErrorTitle: AppStrings.favoritesLoadErrorTitle,
        favoritesLoadErrorBody: AppStrings.favoritesLoadErrorBody,
        favoritesLinkedHerbError: AppStrings.favoritesLinkedHerbError,
        favoritesHerbNotFound: AppStrings.favoritesHerbNotFound,
        favoritesOpenTooltip: AppStrings.favoritesOpenTooltip,
        favoritesRemoveTooltip: AppStrings.favoritesRemoveTooltip,
        favoritesRemovedSnack: AppStrings.favoritesRemovedSnack,
        favoritesRemoveFailSnack: AppStrings.favoritesRemoveFailSnack,
      );

  static FavoritesStrings _fromAm() => FavoritesStrings(
        favoritesTitle: AppStringsAm.favoritesTitle,
        favoritesSubtitle: AppStringsAm.favoritesSubtitle,
        favoritesEmpty: AppStringsAm.favoritesEmpty,
        favoritesCountLabel: AppStringsAm.favoritesCountLabel,
        favoritesLoadErrorTitle: AppStringsAm.favoritesLoadErrorTitle,
        favoritesLoadErrorBody: AppStringsAm.favoritesLoadErrorBody,
        favoritesLinkedHerbError: AppStringsAm.favoritesLinkedHerbError,
        favoritesHerbNotFound: AppStringsAm.favoritesHerbNotFound,
        favoritesOpenTooltip: AppStringsAm.favoritesOpenTooltip,
        favoritesRemoveTooltip: AppStringsAm.favoritesRemoveTooltip,
        favoritesRemovedSnack: AppStringsAm.favoritesRemovedSnack,
        favoritesRemoveFailSnack: AppStringsAm.favoritesRemoveFailSnack,
      );

  static FavoritesStrings _fromOr() => FavoritesStrings(
        favoritesTitle: AppStringsOr.favoritesTitle,
        favoritesSubtitle: AppStringsOr.favoritesSubtitle,
        favoritesEmpty: AppStringsOr.favoritesEmpty,
        favoritesCountLabel: AppStringsOr.favoritesCountLabel,
        favoritesLoadErrorTitle: AppStringsOr.favoritesLoadErrorTitle,
        favoritesLoadErrorBody: AppStringsOr.favoritesLoadErrorBody,
        favoritesLinkedHerbError: AppStringsOr.favoritesLinkedHerbError,
        favoritesHerbNotFound: AppStringsOr.favoritesHerbNotFound,
        favoritesOpenTooltip: AppStringsOr.favoritesOpenTooltip,
        favoritesRemoveTooltip: AppStringsOr.favoritesRemoveTooltip,
        favoritesRemovedSnack: AppStringsOr.favoritesRemovedSnack,
        favoritesRemoveFailSnack: AppStringsOr.favoritesRemoveFailSnack,
      );
}
