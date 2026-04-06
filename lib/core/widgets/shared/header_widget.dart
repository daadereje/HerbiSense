import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final double height;
  final bool showBack;
  final bool solidColor;
  final TextStyle? titleStyle;
  final String? language;
  final List<String>? languageOptions;
  final ValueChanged<String>? onLanguageSelected;
  

  const HeaderWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.height = 180,
    this.showBack = false,
    this.solidColor = false,
    this.titleStyle,
    this.language,
    this.languageOptions,
    this.onLanguageSelected,
  });

  /// Compact variant with a shorter default height (overrideable).
  const HeaderWidget.compact({
    Key? key,
    required String title,
    String? subtitle,
    List<Widget>? actions,
    bool showBack = false,
    bool solidColor = false,
    TextStyle? titleStyle,
    double height = 100,
    String? language,
    List<String>? languageOptions,
    ValueChanged<String>? onLanguageSelected,
  }) : this(
          key: key,
          title: title,
          subtitle: subtitle,
          actions: actions,
          height: height,
          showBack: showBack,
          solidColor: solidColor,
          titleStyle: titleStyle,
          language: language,
          languageOptions: languageOptions,
          onLanguageSelected: onLanguageSelected,
        );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      // We render our own back icon; disable the default to avoid duplicates.
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.secondaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: solidColor
              ? const BoxDecoration(color: AppColors.secondaryGreen)
              : const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondaryGreen, AppColors.softGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showBack)
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back, color: AppColors.white),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      if (showBack) const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: titleStyle ??
                              TextStyle(
                                fontSize: showBack ? 22 : 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (language != null) ...[
                        const SizedBox(width: 8),
                        _LanguageChip(
                          language: language!,
                          options: languageOptions,
                          onSelected: onLanguageSelected,
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                  if (actions != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: actions!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String language;
  final List<String>? options;
  final ValueChanged<String>? onSelected;

  const _LanguageChip({
    required this.language,
    this.options,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final menuOptions = options ?? const ['eng', 'amh', 'or'];

    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        itemBuilder: (context) => menuOptions
            .map(
              (opt) => PopupMenuItem<String>(
                value: opt,
                child: Text(opt.toUpperCase()),
              ),
            )
            .toList(),
        offset: const Offset(0, 32),
        color: AppColors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language,
                color: AppColors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                language.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
