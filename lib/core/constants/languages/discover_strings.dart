class DiscoverStrings {
  final String title;
  final String subtitle;
  final String searchHint;
  final String emptyImages;
  final String loadErrorTitle;
  final String removedFavorite;
  final String removeFavoriteFail;
  final String savedAdded;
  final String savedRemoved;
  final String saveFail;
  final String savedTooltipOn;
  final String savedTooltipOff;
  final String favoriteTooltipOn;
  final String favoriteTooltipOff;
  final String authRequired;

  const DiscoverStrings({
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.emptyImages,
    required this.loadErrorTitle,
    required this.removedFavorite,
    required this.removeFavoriteFail,
    required this.savedAdded,
    required this.savedRemoved,
    required this.saveFail,
    required this.savedTooltipOn,
    required this.savedTooltipOff,
    required this.favoriteTooltipOn,
    required this.favoriteTooltipOff,
    required this.authRequired,
  });

  factory DiscoverStrings.fromLanguage(String code) {
    switch (code) {
      case 'amh':
        return _fromAm();
      case 'or':
        return _fromOr();
      default:
        return _fromEn();
    }
  }

  static DiscoverStrings _fromEn() => DiscoverStrings(
        title: 'Discover',
        subtitle: 'Browse herbs',
        searchHint: 'Search herbs...',
        emptyImages: 'No herb images available yet.',
        loadErrorTitle: 'Could not load herbs',
        removedFavorite: 'Removed from favorites',
        removeFavoriteFail: 'Failed to remove',
        savedAdded: 'Saved to list',
        savedRemoved: 'Removed from saved',
        saveFail: 'Action failed',
        savedTooltipOn: 'Saved',
        savedTooltipOff: 'Save herb',
        favoriteTooltipOn: 'Favorited',
        favoriteTooltipOff: 'Add to favorites',
        authRequired: 'You need to log in to perform this action.',
      );

  static DiscoverStrings _fromAm() => DiscoverStrings(
        title: 'ፈልግ',
        subtitle: 'ዕፅዋትን ይቃኝ',
        searchHint: 'ዕፅዋት ፈልግ...',
        emptyImages: 'የዕፅዋት ምስሎች ገና አልተጨመሩም።',
        loadErrorTitle: 'ዕፅዋት መጫን አልተቻለም',
        removedFavorite: 'ከተወዳጆች ተወግዷል',
        removeFavoriteFail: 'ማስወገድ አልተቻለም',
        savedAdded: 'በተቀመጡ ላይ ታክሏል',
        savedRemoved: 'ከተቀመጡ ተወግዷል',
        saveFail: 'እርምጃው አልተሳካም',
        savedTooltipOn: 'ተቀምጧል',
        savedTooltipOff: 'ዕፅዋት አስቀምጥ',
        favoriteTooltipOn: 'ተወዳጅ ሆኗል',
        favoriteTooltipOff: 'ወደ ተወዳጅ ጨምር',
        authRequired: 'ይህን እርምጃ ለመፈጸም መግባት ያስፈልግዎታል።',
      );

  static DiscoverStrings _fromOr() => DiscoverStrings(
        title: 'Muluu',
        subtitle: 'Biqiltoota ilaali',
        searchHint: 'Biqiltoota barbaadi...',
        emptyImages: 'Suuraan biqiltootaa amma hin jiru.',
        loadErrorTitle: 'Biqiltoota fe\'uu hin dandeenye',
        removedFavorite: 'Kan jaallataman keessaa haqe',
        removeFavoriteFail: 'Balleessuu hin dandeenye',
        savedAdded: 'Kuusaa keessatti ol kaa\'ame',
        savedRemoved: 'Kuusaa keessaa haqe',
        saveFail: 'Hojiin hin milkoofne',
        savedTooltipOn: 'Kuufame',
        savedTooltipOff: 'Biqiltoota kuusi',
        favoriteTooltipOn: 'Kan jaallataman',
        favoriteTooltipOff: 'Kan jaallatamanitti dabaluu',
        authRequired: 'Tajaajila kanaaf seenuu barbaachisa.',
      );
}
