import '../../../features/business/data/services/current_business_service.dart';

mixin ScopedBusinessDao {
  late final CurrentBusinessService businessService;

  int get currentBusinessId => businessService.currentBusinessId;
}
