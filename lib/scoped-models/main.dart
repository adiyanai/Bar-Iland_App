import 'package:scoped_model/scoped_model.dart';
import './links.dart';
import './user.dart';
import './services.dart';
import './events.dart';

class MainModel extends Model with UserModel, ConnectedServicesModel, ServicesModel,  UtilityModel, EventsModel, Links{

}