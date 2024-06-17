import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app_binding.dart';
import 'app/routes/app_route.dart';
import 'app/routes/route_name.dart';
import 'src/constants/local_data_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('en_EN', null)
      .then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _checkInitialStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data ??
              {'isLoggedIn': false, 'hasSeenOnboarding': false};
          final initialRoute = data['isLoggedIn']!
              ? RouteName.dashboard
              : (data['hasSeenOnboarding']!
                  ? RouteName.login
                  : RouteName.onboarding);
          return GetMaterialApp(
            title: "VEC – Randi",
            initialRoute: initialRoute,
            getPages: AppRoute.pages,
            initialBinding: AppBinding(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Map<String, bool>> _checkInitialStatus() async {
    final storage = GetStorage();
    final isLoggedIn = storage.read<String>(LocalDataKey.token) != null;
    final hasSeenOnboarding = storage.read<bool>('hasSeenOnboarding') ?? false;
    return {'isLoggedIn': isLoggedIn, 'hasSeenOnboarding': hasSeenOnboarding};
  }
}
