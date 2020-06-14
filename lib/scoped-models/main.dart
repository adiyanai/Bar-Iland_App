import 'package:bar_iland_app/scoped-models/lost_found.dart';
import 'package:scoped_model/scoped_model.dart';
import './links.dart';
import './user.dart';
import './services.dart';
import './events.dart';
import './buses.dart';
import './shuttles.dart';

class MainModel extends Model with UserModel, ConnectedServicesModel, ServicesModel,  UtilityModel, EventsModel, Links, LostFoundModel, BusesModel, ShuttlesModel {

}