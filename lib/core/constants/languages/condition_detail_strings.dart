import 'am.dart';
import 'or.dart';
import 'strings.dart';

class ConditionDetailStrings {
  final String conditionDetails;
  final String conditionName;
  final String conditionDescription;
  final String primaryHerb;
  final String recommendedHerbs;
  final String medicineDescription;
  final String medicinePreparation;
  final String safetyWarning;
  final String rateLabel;
  final String ratingSubmitted;
  final String ratingFailed;

  const ConditionDetailStrings({
    required this.conditionDetails,
    required this.conditionName,
    required this.conditionDescription,
    required this.primaryHerb,
    required this.recommendedHerbs,
    required this.medicineDescription,
    required this.medicinePreparation,
    required this.safetyWarning,
    required this.rateLabel,
    required this.ratingSubmitted,
    required this.ratingFailed,
  });

  factory ConditionDetailStrings.fromLanguage(String code) {
    final normalized = code.toLowerCase();
    switch (normalized) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static ConditionDetailStrings _fromEn() => ConditionDetailStrings(
        conditionDetails: AppStrings.conditionDetails,
        conditionName: AppStrings.conditionName,
        conditionDescription: AppStrings.conditionDescription,
        primaryHerb: AppStrings.primaryHerb,
        recommendedHerbs: AppStrings.recommendedHerbs,
        medicineDescription: AppStrings.medicineDescription,
        medicinePreparation: AppStrings.medicinePreparation,
        safetyWarning: AppStrings.safetyWarning,
        rateLabel: AppStrings.rateHerb,
        ratingSubmitted: AppStrings.ratingSubmitted,
        ratingFailed: AppStrings.ratingFailed,
      );

  static ConditionDetailStrings _fromAm() => ConditionDetailStrings(
        conditionDetails: AppStringsAm.conditionDetails,
        conditionName: AppStringsAm.conditionName,
        conditionDescription: AppStringsAm.conditionDescription,
        primaryHerb: AppStringsAm.primaryHerb,
        recommendedHerbs: AppStringsAm.recommendedHerbs,
        medicineDescription: AppStringsAm.medicineDescription,
        medicinePreparation: AppStringsAm.medicinePreparation,
        safetyWarning: AppStringsAm.safetyWarning,
        rateLabel: AppStringsAm.rateHerb,
        ratingSubmitted: AppStringsAm.ratingSubmitted,
        ratingFailed: AppStringsAm.ratingFailed,
      );

  static ConditionDetailStrings _fromOr() => ConditionDetailStrings(
        conditionDetails: AppStringsOr.conditionDetails,
        conditionName: AppStringsOr.conditionName,
        conditionDescription: AppStringsOr.conditionDescription,
        primaryHerb: AppStringsOr.primaryHerb,
        recommendedHerbs: AppStringsOr.recommendedHerbs,
        medicineDescription: AppStringsOr.medicineDescription,
        medicinePreparation: AppStringsOr.medicinePreparation,
        safetyWarning: AppStringsOr.safetyWarning,
        rateLabel: AppStringsOr.rateHerb,
        ratingSubmitted: AppStringsOr.ratingSubmitted,
        ratingFailed: AppStringsOr.ratingFailed,
      );
}
