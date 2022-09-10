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

import 'package:flutter/material.dart';
import 'package:kite_event_bus/kite_event_bus.dart';
import 'package:window_manager/window_manager.dart';

enum WindowEvent {
  onWindowResize,
}

class MyWindowListener extends WindowListener {
  final EventBus<WindowEvent> eventBus;

  MyWindowListener({required this.eventBus});

  @override
  void onWindowResize() async {
    final size = await windowManager.getSize();
    eventBus.emit<Size>(WindowEvent.onWindowResize, size);
  }
}

class DesktopInitializer {
  static late EventBus<WindowEvent> eventBus;
  static late WindowListener windowListener;

  static Future<void> init() async {
    DesktopInitializer.eventBus = EventBus<WindowEvent>();
    windowListener = MyWindowListener(eventBus: eventBus);
    windowManager.addListener(windowListener);
    // 必须加上这一行。
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      // Hide window title bar
      await windowManager.setSize(const Size(500, 800));
      await windowManager.show();
    });
  }
}
