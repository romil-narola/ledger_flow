import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/database/app_database.dart';

part 'business_state.freezed.dart';

@freezed
class BusinessState with _$BusinessState {
  const factory BusinessState.initial() = _Initial;
  const factory BusinessState.loading() = _Loading;
  const factory BusinessState.loaded({
    required List<Business> businesses,
    required Business currentBusiness,
  }) = _Loaded;
  const factory BusinessState.error(String message) = _Error;
}
