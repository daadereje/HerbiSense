import 'strings.dart';
import 'am.dart';
import 'or.dart';

class ProfileStrings {
  final String title;
  final String sectionAccount;
  final String sectionEngage;
  final String sectionLibrary;
  final String notLoggedIn;
  final String loadFailed;
  final String signIn;
  final String guest;
  final String unknownEmail;
  final String feedbackTitle;
  final String feedbackSubtitle;
  final String savedHerbsTitle;
  final String savedHerbsSubtitle;

  const ProfileStrings({
    required this.title,
    required this.sectionAccount,
    required this.sectionEngage,
    required this.sectionLibrary,
    required this.notLoggedIn,
    required this.loadFailed,
    required this.signIn,
    required this.guest,
    required this.unknownEmail,
    required this.feedbackTitle,
    required this.feedbackSubtitle,
    required this.savedHerbsTitle,
    required this.savedHerbsSubtitle,
  });

  factory ProfileStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static ProfileStrings _fromEn() => ProfileStrings(
        title: AppStrings.profileTitle,
        sectionAccount: AppStrings.profileSectionAccount,
        sectionEngage: AppStrings.profileSectionEngage,
        sectionLibrary: AppStrings.profileSectionLibrary,
        notLoggedIn: AppStrings.profileNotLoggedIn,
        loadFailed: AppStrings.profileLoadFailed,
        signIn: AppStrings.profileSignIn,
        guest: AppStrings.profileGuest,
        unknownEmail: AppStrings.profileUnknownEmail,
        feedbackTitle: AppStrings.profileFeedbackTitle,
        feedbackSubtitle: AppStrings.profileFeedbackSubtitle,
        savedHerbsTitle: AppStrings.profileSavedHerbsTitle,
        savedHerbsSubtitle: AppStrings.profileSavedHerbsSubtitle,
      );

  static ProfileStrings _fromAm() => ProfileStrings(
        title: AppStringsAm.profileTitle,
        sectionAccount: AppStringsAm.profileSectionAccount,
        sectionEngage: AppStringsAm.profileSectionEngage,
        sectionLibrary: AppStringsAm.profileSectionLibrary,
        notLoggedIn: AppStringsAm.profileNotLoggedIn,
        loadFailed: AppStringsAm.profileLoadFailed,
        signIn: AppStringsAm.profileSignIn,
        guest: AppStringsAm.profileGuest,
        unknownEmail: AppStringsAm.profileUnknownEmail,
        feedbackTitle: AppStringsAm.profileFeedbackTitle,
        feedbackSubtitle: AppStringsAm.profileFeedbackSubtitle,
        savedHerbsTitle: AppStringsAm.profileSavedHerbsTitle,
        savedHerbsSubtitle: AppStringsAm.profileSavedHerbsSubtitle,
      );

  static ProfileStrings _fromOr() => ProfileStrings(
        title: AppStringsOr.profileTitle,
        sectionAccount: AppStringsOr.profileSectionAccount,
        sectionEngage: AppStringsOr.profileSectionEngage,
        sectionLibrary: AppStringsOr.profileSectionLibrary,
        notLoggedIn: AppStringsOr.profileNotLoggedIn,
        loadFailed: AppStringsOr.profileLoadFailed,
        signIn: AppStringsOr.profileSignIn,
        guest: AppStringsOr.profileGuest,
        unknownEmail: AppStringsOr.profileUnknownEmail,
        feedbackTitle: AppStringsOr.profileFeedbackTitle,
        feedbackSubtitle: AppStringsOr.profileFeedbackSubtitle,
        savedHerbsTitle: AppStringsOr.profileSavedHerbsTitle,
        savedHerbsSubtitle: AppStringsOr.profileSavedHerbsSubtitle,
      );
}
