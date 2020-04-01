import 'package:scoped_model/scoped_model.dart';

import './user.dart';
import './services.dart';

class MainModel extends Model with UserModel, ConnectedServicesModel, ServicesModel,  UtilityModel {

}