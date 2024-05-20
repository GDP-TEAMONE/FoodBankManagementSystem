
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Model/User.dart';
import 'package:foodbankmanagementsystem/helper/auth_middleware.dart';
import 'package:get/get.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';

import 'package:foodbankmanagementsystem/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MockAuthService.dart';
import '../MockSharedPreferences.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthMiddleware authMiddleware;
  late MockAuthService mockAuthService;
  late MockSharedPreferences mockSharedPreferences;


  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
    Get.put(AuthService()); 
  });

  setUp(() {
    mockAuthService = MockAuthService();
    authMiddleware = AuthMiddleware();
  });

  test('Test redirection based on user type and requested route', () {
    
    mockAuthService.isAuthenticated.value = true;
    mockAuthService.type = 'Admin'; 

    
    String? route = 'some_requested_route'; 

    
    RouteSettings? redirect = authMiddleware.redirect(route);

    
    expect(redirect!.name, authenticationPageRoute); 

    
  });
}