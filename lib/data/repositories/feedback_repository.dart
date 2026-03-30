import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/network/api_client.dart';
import '../../common/network/api_endpoints.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return FeedbackRepository(apiClient);
});

class FeedbackRepository {
  FeedbackRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> submitFeedback({
    required String name,
    required String email,
    required String message,
  }) async {
    await _apiClient.post(
      ApiEndpoints.feedback,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'message': message.trim(),
      },
    );
  }
}
