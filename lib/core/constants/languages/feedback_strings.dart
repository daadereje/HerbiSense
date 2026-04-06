import 'strings.dart';
import 'am.dart';
import 'or.dart';

class FeedbackStrings {
  final String title;
  final String heading;
  final String subheading;
  final String name;
  final String email;
  final String message;
  final String nameHint;
  final String emailHint;
  final String messageHint;
  final String submit;
  final String thankYou;
  final String genericError;
  final String required;

  const FeedbackStrings({
    required this.title,
    required this.heading,
    required this.subheading,
    required this.name,
    required this.email,
    required this.message,
    required this.nameHint,
    required this.emailHint,
    required this.messageHint,
    required this.submit,
    required this.thankYou,
    required this.genericError,
    required this.required,
  });

  factory FeedbackStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static FeedbackStrings _fromEn() => FeedbackStrings(
        title: AppStrings.feedbackTitle,
        heading: AppStrings.feedbackHeading,
        subheading: AppStrings.feedbackSubheading,
        name: AppStrings.feedbackName,
        email: AppStrings.feedbackEmail,
        message: AppStrings.feedbackMessage,
        nameHint: AppStrings.feedbackNameHint,
        emailHint: AppStrings.feedbackEmailHint,
        messageHint: AppStrings.feedbackMessageHint,
        submit: AppStrings.feedbackSubmit,
        thankYou: AppStrings.feedbackThankYou,
        genericError: AppStrings.feedbackGenericError,
        required: AppStrings.feedbackRequired,
      );

  static FeedbackStrings _fromAm() => FeedbackStrings(
        title: AppStringsAm.feedbackTitle,
        heading: AppStringsAm.feedbackHeading,
        subheading: AppStringsAm.feedbackSubheading,
        name: AppStringsAm.feedbackName,
        email: AppStringsAm.feedbackEmail,
        message: AppStringsAm.feedbackMessage,
        nameHint: AppStringsAm.feedbackNameHint,
        emailHint: AppStringsAm.feedbackEmailHint,
        messageHint: AppStringsAm.feedbackMessageHint,
        submit: AppStringsAm.feedbackSubmit,
        thankYou: AppStringsAm.feedbackThankYou,
        genericError: AppStringsAm.feedbackGenericError,
        required: AppStringsAm.feedbackRequired,
      );

  static FeedbackStrings _fromOr() => FeedbackStrings(
        title: AppStringsOr.feedbackTitle,
        heading: AppStringsOr.feedbackHeading,
        subheading: AppStringsOr.feedbackSubheading,
        name: AppStringsOr.feedbackName,
        email: AppStringsOr.feedbackEmail,
        message: AppStringsOr.feedbackMessage,
        nameHint: AppStringsOr.feedbackNameHint,
        emailHint: AppStringsOr.feedbackEmailHint,
        messageHint: AppStringsOr.feedbackMessageHint,
        submit: AppStringsOr.feedbackSubmit,
        thankYou: AppStringsOr.feedbackThankYou,
        genericError: AppStringsOr.feedbackGenericError,
        required: AppStringsOr.feedbackRequired,
      );
}
