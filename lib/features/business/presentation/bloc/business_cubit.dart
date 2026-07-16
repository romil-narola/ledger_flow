import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_flow/core/database/app_database.dart';
import '../../domain/repositories/business_repository.dart';
import '../../data/services/current_business_service.dart';
import 'business_state.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final BusinessRepository _repository;
  final CurrentBusinessService _currentBusinessService;
  StreamSubscription? _businessesSubscription;

  BusinessCubit({
    required BusinessRepository repository,
    required CurrentBusinessService currentBusinessService,
  })  : _repository = repository,
        _currentBusinessService = currentBusinessService,
        super(const BusinessState.initial()) {
    _loadBusinesses();
  }

  void _loadBusinesses() {
    emit(const BusinessState.loading());
    _businessesSubscription?.cancel();
    _businessesSubscription = _repository.watchAllBusinesses().listen(
      (businesses) {
        if (businesses.isEmpty) {
          emit(const BusinessState.error('No businesses found.'));
          return;
        }

        final currentId = _currentBusinessService.currentBusinessId;
        var current = businesses.cast().firstWhere(
              (b) => b.id == currentId,
              orElse: () => businesses.first,
            );

        // If the saved ID doesn't exist anymore, update the service with the first available
        if (current.id != currentId) {
          _currentBusinessService.setCurrentBusinessId(current.id);
        }

        emit(BusinessState.loaded(
          businesses: businesses,
          currentBusiness: current,
        ));
      },
      onError: (error) {
        emit(BusinessState.error(error.toString()));
      },
    );
  }

  Future<void> switchBusiness(int businessId) async {
    await _currentBusinessService.setCurrentBusinessId(businessId);
    state.maybeWhen(
      loaded: (businesses, currentBusiness) {
        final newCurrent = businesses.cast().firstWhere(
              (b) => b.id == businessId,
              orElse: () => businesses.first,
            );
        emit(BusinessState.loaded(
          businesses: businesses,
          currentBusiness: newCurrent,
        ));
      },
      orElse: () {
        _loadBusinesses(); // Fallback if state is not loaded
      },
    );
  }

  Future<void> createBusiness({
    required String name,
    String? description,
    String? currencyCode,
  }) async {
    await _repository.createBusiness(
      name: name,
      description: description,
      currencyCode: currencyCode,
    );
    // Stream will automatically emit the new list
  }

  Future<void> updateBusiness(Business business) async {
    await _repository.updateBusiness(business);
    // Stream will automatically emit the new list
  }

  Future<void> deleteBusiness(int businessId) async {
    state.maybeWhen(
      loaded: (businesses, currentBusiness) async {
        if (businesses.length <= 1) {
          emit(const BusinessState.error(
              'Cannot delete the last remaining business.'));
          return;
        }

        try {
          await _repository.deleteBusiness(businessId);
          // Stream will emit the new list, and _loadBusinesses listener handles switching
          // if the currently active business was deleted.
        } catch (e) {
          emit(BusinessState.error('Failed to delete business: $e'));
        }
      },
      orElse: () {},
    );
  }

  @override
  Future<void> close() {
    _businessesSubscription?.cancel();
    return super.close();
  }
}
