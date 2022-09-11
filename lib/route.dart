/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/cupertino.dart';
import 'package:kite/feature/board/page/index.dart';
import 'package:kite/feature/freshman/page/login.dart';
import 'package:kite/feature/web_page/browser.dart';

import 'feature/freshman/page/analysis.dart';
import 'feature/freshman/page/friend/index.dart';
import 'feature/freshman/page/info.dart';
import 'feature/freshman/page/update.dart';
import 'feature/game/page/tetris/index.dart';
import 'feature/page_index.dart';
import 'setting/page/index.dart';

typedef NamedRouteBuilder = Widget Function(BuildContext context, Map<String, dynamic> args);

class RouteGeneratorImpl {
  static final Map<String, NamedRouteBuilder> routeTable = {
    RouteTable.home: (context, args) => const HomePage(),
    RouteTable.report: (context, args) => const DailyReportPage(),
    RouteTable.login: (context, args) => const LoginPage(),
    RouteTable.welcome: (context, args) => const WelcomePage(),
    RouteTable.about: (context, args) => const AboutPage(),
    RouteTable.expense: (context, args) => const ExpensePage(),
    RouteTable.connectivity: (context, args) => const ConnectivityPage(),
    RouteTable.campusCard: (context, args) => const CampusCardPage(),
    RouteTable.electricity: (context, args) => const ElectricityPage(),
    RouteTable.score: (context, args) => const ScorePage(),
    RouteTable.office: (context, args) => const OfficePage(),
    RouteTable.game: (context, args) => const GamePage(),
    RouteTable.game2048: (context, args) => Game2048Page(),
    RouteTable.gameWordle: (context, args) => const WordlePage(),
    RouteTable.gameComposeSit: (context, args) => const ComposeSitPage(),
    RouteTable.gameTetris: (context, args) => const TetrisPage(),
    RouteTable.wiki: (context, args) => WikiPage(),
    RouteTable.library: (context, args) => const LibraryPage(),
    RouteTable.libraryAppointment: (context, args) => const AppointmentPage(),
    RouteTable.market: (context, args) => const MarketPage(),
    RouteTable.timetable: (context, args) => const TimetablePage(),
    RouteTable.timetableImport: (context, args) => const TimetableImportPage(),
    RouteTable.setting: (context, args) => SettingPage(),
    RouteTable.feedback: (context, args) => const FeedbackPage(),
    RouteTable.notice: (context, args) => const NoticePage(),
    RouteTable.contact: (context, args) => const ContactPage(),
    RouteTable.bulletin: (context, args) => const BulletinPage(),
    RouteTable.mail: (context, args) => const MailPage(),
    RouteTable.night: (context, args) => const NightPage(),
    RouteTable.event: (context, args) => const EventPage(),
    RouteTable.lostFound: (context, args) => const LostFoundPage(),
    RouteTable.classroom: (context, args) => const ClassroomPage(),
    RouteTable.exam: (context, args) => const ExamPage(),
    RouteTable.egg: (context, args) => const EggPage(),
    RouteTable.bbs: (context, args) => const BbsPage(),
    RouteTable.scanner: (context, args) => const ScannerPage(),
    RouteTable.browser: (context, args) => BrowserPage(args['initialUrl']),
    RouteTable.freshman: (context, args) => FreshmanPage(),
    RouteTable.freshmanAnalysis: (context, args) => const FreshmanAnalysisPage(),
    RouteTable.freshmanLogin: (context, args) => const FreshmanLoginPage(),
    RouteTable.freshmanUpdate: (context, args) => const FreshmanUpdatePage(),
    RouteTable.freshmanFriend: (context, args) => const FreshmanFriendPage(),
    RouteTable.board: (context, args) => const BoardPage(),
  };

  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments) {
    return (context) {
      final builder = routeTable[routeName];
      if (builder == null) throw UnimplementedError("未注册的路由: $routeName");
      return builder(context, arguments);
    };
  }

  bool accept(String routeName) => routeTable.containsKey(routeName);
}
