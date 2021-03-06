import 'package:app_review/app_review.dart';
import 'package:injectable/injectable.dart';

abstract class IRatingService {
  Future<void> rateApp();
}

@lazySingleton
@RegisterAs(IRatingService)
class RatingService implements IRatingService {
  @override
  Future<void> rateApp() async {
    await AppReview.storeListing;
  }
}
