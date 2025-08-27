import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化
  try {
    if (Firebase.apps.isEmpty && !(Platform.isIOS || Platform.isMacOS)) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  // Hive初期化
  await Hive.initFlutter();

  // 通知サービス初期化
  await NotificationService.initialize();

  // Firebase Messaging初期化
  try {
    await FirebaseService.initialize();
  } catch (e) {
    print('Firebase Service initialization failed: $e');
    // Firebase初期化に失敗してもアプリは動作を続ける
  }

  runApp(
    const ProviderScope(
      child: OshiZatsuApp(),
    ),
  );
}
