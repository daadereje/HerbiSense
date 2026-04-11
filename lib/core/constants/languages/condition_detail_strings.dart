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

  const ConditionDetailStrings({
    required this.conditionDetails,
    required this.conditionName,
    required this.conditionDescription,
    required this.primaryHerb,
    required this.recommendedHerbs,
    required this.medicineDescription,
    required this.medicinePreparation,
    required this.safetyWarning,
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
      );
}
