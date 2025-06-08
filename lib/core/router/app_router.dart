import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/Features/navigation.dart';
import 'package:Tosell/Features/orders/models/Order.dart';
import 'package:Tosell/Features/splash/splash_screen.dart';
import 'package:Tosell/core/widgets/background_wrapper.dart';
import 'package:Tosell/Features/home/screens/home_screen.dart';
import 'package:Tosell/Features/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/profile/models/transaction.dart';
import 'package:Tosell/Features/order/screens/order_screen.dart';
import 'package:Tosell/Features/profile/screens/zones_screen.dart';
import 'package:Tosell/Features/orders/screens/orders_screen.dart';
import 'package:Tosell/Features/profile/screens/logout_Screen.dart';
import 'package:Tosell/Features/order/screens/order_completed.dart';
import 'package:Tosell/Features/order/screens/add_order_screen.dart';
import 'package:Tosell/Features/auth/login/screens/login_screen.dart';
import 'package:Tosell/Features/profile/screens/myProfile_Screen.dart';
import 'package:Tosell/Features/order/screens/order_details_screen.dart';
import 'package:Tosell/Features/profile/screens/editProfile_Screen.dart';
import 'package:Tosell/Features/profile/screens/transactions_screen.dart';
import 'package:Tosell/Features/profile/screens/locations_Screen_old.dart';
import 'package:Tosell/Features/statistics/screens/statistics_screen.dart';
import 'package:Tosell/Features/profile/screens/delete_account_Screen.dart';
import 'package:Tosell/Features/profile/screens/changePassword_Screen.dart';
import 'package:Tosell/Features/auth/register/screens/register_screen.dart';
import 'package:Tosell/Features/settings/widgets/support_record_screen.dart';
import 'package:Tosell/Features/changeState/screens/change_state_screen.dart';
import 'package:Tosell/Features/notification/screens/notification_screen.dart';
import 'package:Tosell/Features/profile/screens/transaction_details_screen.dart';
import 'package:Tosell/Features/auth/login/ForgotPassword/ForgotPasswordAuth.dart';
import 'package:Tosell/Features/auth/login/ForgotPassword/ForgotPasswordNumber.dart';
import 'package:Tosell/Features/auth/login/ForgotPassword/ForgotPasswordNumberNamePass.dart';

String initialLocation = AppRoutes.login;

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GlobalKey<NavigatorState> _storeShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'storeShell');

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const BackgroundWrapper(child: SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.changeState,
      builder: (context, state) => BackgroundWrapper(
        child: ChangeStateScreen(
          code: state.extra as String,
          // code: "111111111",
        ),
      ),
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const BackgroundWrapper(child: LoginPage()),
    ),
    GoRoute(
      path: AppRoutes.orderCompleted,
      builder: (context, state) => const BackgroundWrapper(child: OrderCompleted()),
    ),

    // GoRoute(
    //   path: AppRoutes.cart,
    //   builder: (context, state) => const CartPage(),
    // ),
    GoRoute(
      path: AppRoutes.order,
      builder: (context, state) => const BackgroundWrapper(child: OrderScreen()),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const BackgroundWrapper(child: NotificationPage()),
    ),
 GoRoute(
      path: AppRoutes.deleteAccount,
      builder: (context, state) => const BackgroundWrapper(child: DeleteAccountScreen()),
    ),
    
    GoRoute(
      path: AppRoutes.transactions,
      builder: (context, state) => const BackgroundWrapper(child: TransactionsScreen()),
    ),
    GoRoute(
      path: AppRoutes.TransactionDetails,
      builder: (context, state) => BackgroundWrapper(
        child: TransactionDetailsScreen(
          transaction: state.extra as Transaction,
        ),
      ),
    ),
    // TransactionDetaileScreen
    GoRoute(
      path: AppRoutes.orderDetails,
      builder: (context, state) => BackgroundWrapper(
        child: OrderDetailsScreen(
          code: state.extra as String,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.registerScreen,
      builder: (context, state) => const BackgroundWrapper(child: RegisterScreen()),
    ),
    GoRoute(
      path: AppRoutes.addOrder,
      builder: (context, state) => const BackgroundWrapper(child: AddOrderScreen()),
    ),
    GoRoute(
      path: AppRoutes.ForgotPassword,
      builder: (context, state) => const BackgroundWrapper(
        child: ForgotPasswordNum(
          PageTitle: 'ForgotPassword',
        ),
      ),
    ),
     GoRoute(
      path: AppRoutes.changePassword,
      builder: (context, state) => const BackgroundWrapper(
        child: ChangePasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.ForgotPasswordAuth,
      builder: (context, state) => const BackgroundWrapper(
        child: ForgotpasswordAuth(
          PageTitle: "ForgotPasswordAuth",
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.ForgotpasswordnumbernamePass,
      builder: (context, state) => const BackgroundWrapper(
        child: ForgotPasswordNumberNamePass(
          PageTitle: "ForgotpasswordnumbernamePass",
        ),
      ),
    ),

    GoRoute(
      path: AppRoutes.zones,
      builder: (context, state) => BackgroundWrapper(
        child: ZonesScreen(
          PageTitle: state.extra as String,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.logout,
      builder: (context, state) => LogoutScreen(),
    ),

    GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const BackgroundWrapper(child: EditProfileScreen()),
        ),
        GoRoute(
          path: AppRoutes.SupportRecord,
          builder: (context, state) => const SupportRecordScreen(),
        ),

    //! Shell Route for Bottom Navigation
    ShellRoute(
      builder: (context, state, child) => NavigationPage(child: child),
      
      routes: [
         GoRoute(
          path: AppRoutes.statistics,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BackgroundWrapper(child: StatisticsScreen()),
            transitionsBuilder: _slideFromLeftTransition,
          ),),
          GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BackgroundWrapper(child: HomeScreen()),
            transitionsBuilder: _slideFromLeftTransition,
          ),),
         GoRoute(
          path: AppRoutes.orders,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child:  BackgroundWrapper(child: OrdersScreen(
              filter: state.extra as OrderFilter?,
            )),
            transitionsBuilder: _slideFromLeftTransition,
          ),),
         GoRoute(
          path: AppRoutes.myProfile,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const BackgroundWrapper(child: MyProfileScreen()),
            transitionsBuilder: _slideFromLeftTransition,
          ),),
        
        
      ],
    ),
  ],
);


/// Fade Transition
Widget _fadeTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideFromLeftTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(-1.0, 0.0); // From left
  const end = Offset.zero;

  final tween = Tween(begin: begin, end: end)
      .chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}



class AppRoutes {
  static const String splash = '/';
  static const String orderCompleted = '/orderCompleted';
  static const String order = '/order';
  static const String notifications = '/notifications';
  static const String chats = '/chats';
  static const String chat = '/chat';
  static const String orderDetails = '/order-details';
  static const String home = '/home';
  static const String orders = '/orders';
  static const String statistics = '/statistics';
  static const String myProfile = '/my_profile';
  static const String editProfile = '/edit_profile';
  static const String selectLocation = '/select_location';
  static const String registerScreen = '/register_screen';
  static const String addOrder = '/add_order';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String zones = '/zones';
  static const String background = '/background';
  static const String changeState = '/changeState';
  static const String changePassword = '/changePassword';
  static const String deleteAccount = '/deleteAccount';

  static const String transactions = '/Transactions';
  static const String SupportRecord = '/SupportRecordScreen';

  static const String TransactionDetails = '/TransactionDetails';

  static const String ForgotPassword = '/ForgotPasswordNum';
  static const String ForgotPasswordAuth = '/ForgotpasswordAuth';
  static const String ForgotpasswordnumbernamePass =
      '/ForgotPasswordNumberNamePass';
}
