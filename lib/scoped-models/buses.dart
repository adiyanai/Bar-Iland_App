import 'package:scoped_model/scoped_model.dart';

class BusesModel extends Model {
  bool _isBusesLoading = false;

  bool get isBusesLoading {
    return _isBusesLoading;
  }
}