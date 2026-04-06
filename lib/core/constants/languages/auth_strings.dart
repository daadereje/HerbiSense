import 'strings.dart';
import 'am.dart';
import 'or.dart';

class AuthStrings {
  final String appName;
  final String appTagline;
  final String welcomeBack;
  final String signInToContinue;
  final String emailAddress;
  final String yourEmail;
  final String password;
  final String enterPassword;
  final String rememberMe;
  final String forgotPassword;
  final String signIn;
  final String noAccount;
  final String signUp;
  final String createAccount;
  final String signUpToExplore;
  final String fullName;
  final String enterFullName;
  final String enterEmail;
  final String createPassword;
  final String confirmPassword;
  final String confirmYourPassword;
  final String joinEnthusiasts;
  final String alreadyHaveAccount;
  final String accountCreated;
  final String iAgreeTo;
  final String termsOfService;
  final String privacyPolicy;

  const AuthStrings({
    required this.appName,
    required this.appTagline,
    required this.welcomeBack,
    required this.signInToContinue,
    required this.emailAddress,
    required this.yourEmail,
    required this.password,
    required this.enterPassword,
    required this.rememberMe,
    required this.forgotPassword,
    required this.signIn,
    required this.noAccount,
    required this.signUp,
    required this.createAccount,
    required this.signUpToExplore,
    required this.fullName,
    required this.enterFullName,
    required this.enterEmail,
    required this.createPassword,
    required this.confirmPassword,
    required this.confirmYourPassword,
    required this.joinEnthusiasts,
    required this.alreadyHaveAccount,
    required this.accountCreated,
    required this.iAgreeTo,
    required this.termsOfService,
    required this.privacyPolicy,
  });

  factory AuthStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static AuthStrings _fromEn() => AuthStrings(
        appName: AppStrings.appName,
        appTagline: AppStrings.appTagline,
        welcomeBack: AppStrings.welcomeBack,
        signInToContinue: AppStrings.signInToContinue,
        emailAddress: AppStrings.emailAddress,
        yourEmail: AppStrings.yourEmail,
        password: AppStrings.password,
        enterPassword: AppStrings.enterPassword,
        rememberMe: AppStrings.rememberMe,
        forgotPassword: AppStrings.forgotPassword,
        signIn: AppStrings.signIn,
        noAccount: AppStrings.noAccount,
        signUp: AppStrings.signUp,
        createAccount: AppStrings.createAccount,
        signUpToExplore: AppStrings.signUpToExplore,
        fullName: AppStrings.fullName,
        enterFullName: AppStrings.enterFullName,
        enterEmail: AppStrings.enterEmail,
        createPassword: AppStrings.createPassword,
        confirmPassword: AppStrings.confirmPassword,
        confirmYourPassword: AppStrings.confirmYourPassword,
        joinEnthusiasts: AppStrings.joinEnthusiasts,
        alreadyHaveAccount: AppStrings.alreadyHaveAccount,
        accountCreated: AppStrings.accountCreated,
        iAgreeTo: AppStrings.iAgreeTo,
        termsOfService: AppStrings.termsOfService,
        privacyPolicy: AppStrings.privacyPolicy,
      );

  static AuthStrings _fromAm() => AuthStrings(
        appName: AppStringsAm.appName,
        appTagline: AppStringsAm.appTagline,
        welcomeBack: AppStringsAm.welcomeBack,
        signInToContinue: AppStringsAm.signInToContinue,
        emailAddress: AppStringsAm.emailAddress,
        yourEmail: AppStringsAm.yourEmail,
        password: AppStringsAm.password,
        enterPassword: AppStringsAm.enterPassword,
        rememberMe: AppStringsAm.rememberMe,
        forgotPassword: AppStringsAm.forgotPassword,
        signIn: AppStringsAm.signIn,
        noAccount: AppStringsAm.noAccount,
        signUp: AppStringsAm.signUp,
        createAccount: AppStringsAm.createAccount,
        signUpToExplore: AppStringsAm.signUpToExplore,
        fullName: AppStringsAm.fullName,
        enterFullName: AppStringsAm.enterFullName,
        enterEmail: AppStringsAm.enterEmail,
        createPassword: AppStringsAm.createPassword,
        confirmPassword: AppStringsAm.confirmPassword,
        confirmYourPassword: AppStringsAm.confirmYourPassword,
        joinEnthusiasts: AppStringsAm.joinEnthusiasts,
        alreadyHaveAccount: AppStringsAm.alreadyHaveAccount,
        accountCreated: AppStringsAm.accountCreated,
        iAgreeTo: AppStringsAm.iAgreeTo,
        termsOfService: AppStringsAm.termsOfService,
        privacyPolicy: AppStringsAm.privacyPolicy,
      );

  static AuthStrings _fromOr() => AuthStrings(
        appName: AppStringsOr.appName,
        appTagline: AppStringsOr.appTagline,
        welcomeBack: AppStringsOr.welcomeBack,
        signInToContinue: AppStringsOr.signInToContinue,
        emailAddress: AppStringsOr.emailAddress,
        yourEmail: AppStringsOr.yourEmail,
        password: AppStringsOr.password,
        enterPassword: AppStringsOr.enterPassword,
        rememberMe: AppStringsOr.rememberMe,
        forgotPassword: AppStringsOr.forgotPassword,
        signIn: AppStringsOr.signIn,
        noAccount: AppStringsOr.noAccount,
        signUp: AppStringsOr.signUp,
        createAccount: AppStringsOr.createAccount,
        signUpToExplore: AppStringsOr.signUpToExplore,
        fullName: AppStringsOr.fullName,
        enterFullName: AppStringsOr.enterFullName,
        enterEmail: AppStringsOr.enterEmail,
        createPassword: AppStringsOr.createPassword,
        confirmPassword: AppStringsOr.confirmPassword,
        confirmYourPassword: AppStringsOr.confirmYourPassword,
        joinEnthusiasts: AppStringsOr.joinEnthusiasts,
        alreadyHaveAccount: AppStringsOr.alreadyHaveAccount,
        accountCreated: AppStringsOr.accountCreated,
        iAgreeTo: AppStringsOr.iAgreeTo,
        termsOfService: AppStringsOr.termsOfService,
        privacyPolicy: AppStringsOr.privacyPolicy,
      );
}
