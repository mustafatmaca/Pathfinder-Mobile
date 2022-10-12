import 'package:pathfinder/Entity/City.dart';
import 'package:pathfinder/Entity/Message.dart';
import 'package:pathfinder/Entity/User.dart';
import 'package:pathfinder/app/api/api.dart';

class RequestHelper {
  Api api = Api();

  Future<List<String>> getCityList(String dropDownVlue) {
    return api.fetchCityList(dropDownVlue);
  }

  Future<City> getCity(String city) {
    return api.fetchCity(city);
  }

  Future<User> getUser(String mail) {
    return api.getUser(mail);
  }

  Future<User> createUser(String? email, name, phone, password, City? city) {
    return api.createUser(email, name, phone, password, city);
  }

  Future<List<User>> getGuiders(String city) {
    return api.fetchGuiderByCity(city);
  }

  Future<List<Message>> getMessageByUser(String mail) {
    return api.fetchMessageByUser(mail);
  }

  Future<User> loginCheck(String mail, String password) {
    return api.checkLogin(mail, password);
  }
}
