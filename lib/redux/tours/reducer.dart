import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:what_when_where/redux/tours/actions.dart';
import 'package:what_when_where/redux/tours/state.dart';
import 'package:what_when_where/utils/extensions.dart';

class ToursReducer {
  static final Reducer<ToursState> _reducer = combineReducers<ToursState>([
    TypedReducer<ToursState, SetTours>(_setTours),
    TypedReducer<ToursState, ClearTours>(_voidTours),
    TypedReducer<ToursState, TourIsLoading>(_updateTourIsLoading),
    TypedReducer<ToursState, TourLoaded>(_updateTourLoaded),
    TypedReducer<ToursState, TourFailedLoading>(_updateTourFailed),
  ]);

  static ToursState reduce(ToursState state, dynamic action) =>
      _reducer(state, action);

  static ToursState _setTours(ToursState state, SetTours action) =>
      ToursState.from(tours: action.tours);

  static ToursState _voidTours(ToursState state, ClearTours action) =>
      ToursState.initial();

  static ToursState _updateTourIsLoading(
          ToursState state, TourIsLoading action) =>
      _replaceTour(
          state,
          action.tourId,
          (tourState) => tourState.copyWith(
                isLoading: Optional.of(true),
                exception: const Optional.absent(),
              ));

  static ToursState _updateTourLoaded(ToursState state, TourLoaded action) =>
      _replaceTour(
          state,
          action.tour.id,
          (tourState) => tourState.copyWith(
                tour: Optional.of(action.tour),
                isLoading: Optional.of(false),
                exception: const Optional.absent(),
              ));

  static ToursState _updateTourFailed(
          ToursState state, TourFailedLoading action) =>
      _replaceTour(
          state,
          action.tourId,
          (tourState) => tourState.copyWith(
                isLoading: Optional.of(false),
                exception: Optional.of(action.exception),
              ));

  static ToursState _replaceTour(
      ToursState state, String tourId, TourState Function(TourState) function) {
    final tourIndex =
        state.tours.indexWhere((tourState) => tourState.tour.id == tourId);
    if (tourIndex == -1) {
      return state;
    }

    final newTourState = function(state.tours[tourIndex]);
    return state.copyWith(
      tours: Optional.of(
          IterableExtensions.replaceAt(state.tours, tourIndex, newTourState)),
    );
  }
}
