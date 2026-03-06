import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/about_stat_model.dart';

final aboutRepositoryProvider = Provider<AboutRepository>((ref) {
  return AboutRepository();
});

class AboutRepository {
  Future<List<AboutStatModel>> getAboutStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AboutStatModel.getMockStats();
  }

  Future<Map<String, dynamic>> getCompanyInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'mission': 'Empowering Health, Preserving Heritage',
      'vision': 'Connecting ancient wisdom with modern wellness',
    };
  }
}
