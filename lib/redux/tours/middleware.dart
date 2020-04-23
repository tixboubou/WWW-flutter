import 'package:redux/redux.dart';
import 'package:what_when_where/db_chgk_info/loaders/tour_details_loader.dart';
import 'package:what_when_where/redux/app/state.dart';
import 'package:what_when_where/redux/tours/actions.dart';

class ToursMiddleware {
  final ITourDetailsLoader _loader;

  List<Middleware<AppState>> _middleware;
  Iterable<Middleware<AppState>> get middleware => _middleware;

  ToursMiddleware.ioc({
    ITourDetailsLoader loader,
  }) : _loader = loader {
    _middleware = _createMiddleware();
  }

  List<Middleware<AppState>> _createMiddleware() => [
        TypedMiddleware<AppState, SetTours>(_setTours),
        TypedMiddleware<AppState, LoadTour>(_loadTour),
      ];

  Future<void> _loadTour(
      Store<AppState> store, LoadTour action, NextDispatcher next) async {
    next(action);

    final tourId = action.tourId;

    final tourState = store.state.toursState.tours
        .firstWhere((state) => state.tour.id == tourId, orElse: () => null);

    if (tourState == null || tourState.isLoading) {
      return;
    }

    try {
      store.dispatch(TourIsLoading(tourId: tourId));

      final data = await _loader.get(tourState.tour.id);

      store.dispatch(TourLoaded(tour: data));
    } on Exception catch (e) {
      store.dispatch(TourFailedLoading(tourId: tourId, exception: e));
    }
  }

  void _setTours(Store<AppState> store, SetTours action, NextDispatcher next) {
    next(action);

    action.tours
        .map((e) => e.id)
        .forEach((id) => store.dispatch(LoadTour(tourId: id)));
  }
}
