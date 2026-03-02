This file is a merged representation of a subset of the codebase, containing files not matching ignore patterns, combined into a single document by Repomix.
The content has been processed where empty lines have been removed, line numbers have been added.

# File Summary

## Purpose
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Files matching these patterns are excluded: android/**, ios/**, web/**, windows/**, build/**, .dart_tool/**, **/*.png, **/*.ico, **/*.xml, **/*.gradle*, .metadata, devtools_options.yaml, pubspec.lock, test/**
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Empty lines have been removed from all files
- Line numbers have been added to the beginning of each line
- Files are sorted by Git change count (files with more changes are at the bottom)

# Directory Structure
```
.gitignore
analysis_options.yaml
firebase.json
lib/firebase_options.dart
lib/main.dart
lib/screens/chat_screen.dart
lib/screens/friend_requests_screen.dart
lib/screens/friends_screen.dart
lib/screens/home_screen.dart
lib/screens/login_screen.dart
lib/screens/profile_screen.dart
lib/screens/register_screen.dart
lib/screens/search_screen.dart
lib/screens/user_profile_view.dart
lib/services/chat_service.dart
lib/services/friend_service.dart
lib/widgets/chat_home_header.dart
lib/widgets/chat_tile.dart
lib/widgets/empty_chat_state.dart
lib/widgets/friend_action_button.dart
lib/widgets/glass_bottom_nav.dart
lib/widgets/search_result_tile.dart
pubspec.yaml
README.md
repomix.config.json
```

# Files

## File: repomix.config.json
````json
 1: {
 2:   "output": {
 3:     "style": "markdown",
 4:     "filePath": "custom-output.md",
 5:     "removeComments": false,
 6:     "showLineNumbers": true,
 7:     "compress": false,
 8:     "includeFullDirectoryStructure": true,
 9:     "fileSummary": true,
10:     "removeEmptyLines": true,
11:     "topFilesLength": 10
12:   },
13:   "ignore": {
14:     "customPatterns": [
15:       "android/**",
16:       "ios/**",
17:       "web/**",
18:       "windows/**",
19:       "build/**",
20:       ".dart_tool/**",
21:       "**/*.png",
22:       "**/*.ico",
23:       "**/*.xml",
24:       "**/*.gradle*",
25:       ".metadata",
26:       "devtools_options.yaml",
27:       "pubspec.lock",
28:       "test/**"
29:     ],
30:     "useDefaultPatterns": true,
31:     "useGitignore": true
32:   }
33: }
````

## File: analysis_options.yaml
````yaml
 1: # This file configures the analyzer, which statically analyzes Dart code to
 2: # check for errors, warnings, and lints.
 3: #
 4: # The issues identified by the analyzer are surfaced in the UI of Dart-enabled
 5: # IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
 6: # invoked from the command line by running `flutter analyze`.
 7: # The following line activates a set of recommended lints for Flutter apps,
 8: # packages, and plugins designed to encourage good coding practices.
 9: include: package:flutter_lints/flutter.yaml
10: linter:
11:   # The lint rules applied to this project can be customized in the
12:   # section below to disable rules from the `package:flutter_lints/flutter.yaml`
13:   # included above or to enable additional rules. A list of all available lints
14:   # and their documentation is published at https://dart.dev/lints.
15:   #
16:   # Instead of disabling a lint rule for the entire project in the
17:   # section below, it can also be suppressed for a single line of code
18:   # or a specific dart file by using the `// ignore: name_of_lint` and
19:   # `// ignore_for_file: name_of_lint` syntax on the line or in the file
20:   # producing the lint.
21:   rules:
22:     # avoid_print: false  # Uncomment to disable the `avoid_print` rule
23:     # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule
24: # Additional information about this file can be found at
25: # https://dart.dev/guides/language/analysis-options
````

## File: firebase.json
````json
1: {"flutter":{"platforms":{"android":{"default":{"projectId":"flutter-chat-app-2c016","appId":"1:635137896413:android:d96ef27d98c7adbad69034","fileOutput":"android/app/google-services.json"}},"dart":{"lib/firebase_options.dart":{"projectId":"flutter-chat-app-2c016","configurations":{"android":"1:635137896413:android:d96ef27d98c7adbad69034","web":"1:635137896413:web:fa3cbdc61369adfad69034","windows":"1:635137896413:web:0f28b78425154d29d69034"}}}}}}
````

## File: lib/firebase_options.dart
````dart
 1: // File generated by FlutterFire CLI.
 2: // ignore_for_file: type=lint
 3: import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
 4: import 'package:flutter/foundation.dart'
 5:     show defaultTargetPlatform, kIsWeb, TargetPlatform;
 6: /// Default [FirebaseOptions] for use with your Firebase apps.
 7: ///
 8: /// Example:
 9: /// ```dart
10: /// import 'firebase_options.dart';
11: /// // ...
12: /// await Firebase.initializeApp(
13: ///   options: DefaultFirebaseOptions.currentPlatform,
14: /// );
15: /// ```
16: class DefaultFirebaseOptions {
17:   static FirebaseOptions get currentPlatform {
18:     if (kIsWeb) {
19:       return web;
20:     }
21:     switch (defaultTargetPlatform) {
22:       case TargetPlatform.android:
23:         return android;
24:       case TargetPlatform.iOS:
25:         throw UnsupportedError(
26:           'DefaultFirebaseOptions have not been configured for ios - '
27:           'you can reconfigure this by running the FlutterFire CLI again.',
28:         );
29:       case TargetPlatform.macOS:
30:         throw UnsupportedError(
31:           'DefaultFirebaseOptions have not been configured for macos - '
32:           'you can reconfigure this by running the FlutterFire CLI again.',
33:         );
34:       case TargetPlatform.windows:
35:         return windows;
36:       case TargetPlatform.linux:
37:         throw UnsupportedError(
38:           'DefaultFirebaseOptions have not been configured for linux - '
39:           'you can reconfigure this by running the FlutterFire CLI again.',
40:         );
41:       default:
42:         throw UnsupportedError(
43:           'DefaultFirebaseOptions are not supported for this platform.',
44:         );
45:     }
46:   }
47:   static const FirebaseOptions web = FirebaseOptions(
48:     apiKey: 'AIzaSyCemnKQAXPkuZo0HqJplUtLLRm7vObw9q4',
49:     appId: '1:635137896413:web:fa3cbdc61369adfad69034',
50:     messagingSenderId: '635137896413',
51:     projectId: 'flutter-chat-app-2c016',
52:     authDomain: 'flutter-chat-app-2c016.firebaseapp.com',
53:     storageBucket: 'flutter-chat-app-2c016.firebasestorage.app',
54:     measurementId: 'G-3QCZ7YK7EG',
55:   );
56:   static const FirebaseOptions android = FirebaseOptions(
57:     apiKey: 'AIzaSyBll9a1ZM4OKDMOMOVRtVN9lPEq9g4fKnE',
58:     appId: '1:635137896413:android:d96ef27d98c7adbad69034',
59:     messagingSenderId: '635137896413',
60:     projectId: 'flutter-chat-app-2c016',
61:     storageBucket: 'flutter-chat-app-2c016.firebasestorage.app',
62:   );
63:   static const FirebaseOptions windows = FirebaseOptions(
64:     apiKey: 'AIzaSyCemnKQAXPkuZo0HqJplUtLLRm7vObw9q4',
65:     appId: '1:635137896413:web:0f28b78425154d29d69034',
66:     messagingSenderId: '635137896413',
67:     projectId: 'flutter-chat-app-2c016',
68:     authDomain: 'flutter-chat-app-2c016.firebaseapp.com',
69:     storageBucket: 'flutter-chat-app-2c016.firebasestorage.app',
70:     measurementId: 'G-K9FFQWWNWW',
71:   );
72: }
````

## File: README.md
````markdown
 1: # chat_app
 2: 
 3: A Flutter Project for chatting
 4: 
 5: ## Getting Started
 6: 
 7: This project is a starting point for a Flutter application.
 8: 
 9: A few resources to get you started if this is your first Flutter project:
10: 
11: - [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
12: - [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
13: - [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
14: 
15: For help getting started with Flutter development, view the
16: [online documentation](https://docs.flutter.dev/), which offers tutorials,
17: samples, guidance on mobile development, and a full API reference.
````

## File: .gitignore
````
 1: # Miscellaneous
 2: *.class
 3: *.log
 4: *.pyc
 5: *.swp
 6: .DS_Store
 7: .atom/
 8: .build/
 9: .buildlog/
10: .history
11: .svn/
12: .swiftpm/
13: migrate_working_dir/
14: 
15: # IntelliJ related
16: *.iml
17: *.ipr
18: *.iws
19: .idea/
20: 
21: # The .vscode folder contains launch configuration and tasks you configure in
22: # VS Code which you may wish to be included in version control, so this line
23: # is commented out by default.
24: #.vscode/
25: 
26: # Flutter/Dart/Pub related
27: **/doc/api/
28: **/ios/Flutter/.last_build_id
29: .dart_tool/
30: .flutter-plugins-dependencies
31: .pub-cache/
32: .pub/
33: /build/
34: /coverage/
35: 
36: # Symbolication related
37: app.*.symbols
38: 
39: # Obfuscation related
40: app.*.map.json
41: 
42: # Android Studio will place build artifacts here
43: /android/app/debug
44: /android/app/profile
45: /android/app/release
46: 
47: # Android local config (VERY IMPORTANT)
48: android/local.properties
49: android/key.properties
50: 
51: # iOS Pods
52: ios/Pods/
53: ios/.symlinks/
54: ios/Flutter/Flutter.framework
55: 
56: # macOS
57: macos/Pods/
58: 
59: # Windows
60: windows/flutter/ephemeral/
61: 
62: # Environment files (if you ever use them)
63: .env
64: 
65: # Android and gradle cache
66: android/.gradle/
````

## File: lib/screens/friend_requests_screen.dart
````dart
  1: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2: // FILE: lib/screens/friend_requests_screen.dart
  3: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  4: import 'package:flutter/material.dart';
  5: import 'package:cloud_firestore/cloud_firestore.dart';
  6: import '../services/friend_service.dart';
  7: class FriendRequestsScreen extends StatefulWidget {
  8:   final String currentUserId;
  9:   const FriendRequestsScreen({super.key, required this.currentUserId});
 10:   @override
 11:   State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
 12: }
 13: class _FriendRequestsScreenState extends State<FriendRequestsScreen>
 14:     with SingleTickerProviderStateMixin {
 15:   late TabController _tabController;
 16:   final _friendService = FriendService();
 17:   @override
 18:   void initState() {
 19:     super.initState();
 20:     _tabController = TabController(length: 2, vsync: this);
 21:   }
 22:   @override
 23:   void dispose() {
 24:     _tabController.dispose();
 25:     super.dispose();
 26:   }
 27:   @override
 28:   Widget build(BuildContext context) {
 29:     final theme = Theme.of(context);
 30:     final colorScheme = theme.colorScheme;
 31:     return Scaffold(
 32:       backgroundColor: colorScheme.surface,
 33:       appBar: AppBar(
 34:         title: Text(
 35:           'Friend Requests',
 36:           style: theme.textTheme.titleLarge?.copyWith(
 37:             fontWeight: FontWeight.w700,
 38:           ),
 39:         ),
 40:         centerTitle: true,
 41:         bottom: TabBar(
 42:           controller: _tabController,
 43:           indicatorColor: colorScheme.primary,
 44:           labelColor: colorScheme.primary,
 45:           unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
 46:           labelStyle: const TextStyle(fontWeight: FontWeight.w600),
 47:           tabs: const [
 48:             Tab(text: 'Received'),
 49:             Tab(text: 'Sent'),
 50:           ],
 51:         ),
 52:       ),
 53:       body: TabBarView(
 54:         controller: _tabController,
 55:         children: [
 56:           _IncomingRequestsTab(
 57:             currentUserId: widget.currentUserId,
 58:             friendService: _friendService,
 59:           ),
 60:           _OutgoingRequestsTab(
 61:             currentUserId: widget.currentUserId,
 62:             friendService: _friendService,
 63:           ),
 64:         ],
 65:       ),
 66:     );
 67:   }
 68: }
 69: // ─── INCOMING REQUESTS TAB ──────────────────────────────────────────────────
 70: class _IncomingRequestsTab extends StatelessWidget {
 71:   final String currentUserId;
 72:   final FriendService friendService;
 73:   const _IncomingRequestsTab({
 74:     required this.currentUserId,
 75:     required this.friendService,
 76:   });
 77:   @override
 78:   Widget build(BuildContext context) {
 79:     final theme = Theme.of(context);
 80:     final colorScheme = theme.colorScheme;
 81:     return StreamBuilder<List<RelationshipInfo>>(
 82:       stream: friendService.incomingRequestsStream(currentUserId),
 83:       builder: (context, snapshot) {
 84:         if (snapshot.connectionState == ConnectionState.waiting) {
 85:           return const Center(child: CircularProgressIndicator());
 86:         }
 87:         final requests = snapshot.data ?? [];
 88:         if (requests.isEmpty) {
 89:           return _buildEmptyState(
 90:             context,
 91:             icon: Icons.inbox_rounded,
 92:             title: 'No Incoming Requests',
 93:             subtitle:
 94:                 'When someone sends you a friend request,\nit will appear here.',
 95:           );
 96:         }
 97:         return ListView.builder(
 98:           padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
 99:           physics: const BouncingScrollPhysics(),
100:           itemCount: requests.length,
101:           itemBuilder: (context, index) {
102:             final request = requests[index];
103:             return _RequestTile(
104:               otherUid: request.otherUid,
105:               currentUserId: currentUserId,
106:               friendService: friendService,
107:               isIncoming: true,
108:             );
109:           },
110:         );
111:       },
112:     );
113:   }
114: }
115: // ─── OUTGOING REQUESTS TAB ──────────────────────────────────────────────────
116: class _OutgoingRequestsTab extends StatelessWidget {
117:   final String currentUserId;
118:   final FriendService friendService;
119:   const _OutgoingRequestsTab({
120:     required this.currentUserId,
121:     required this.friendService,
122:   });
123:   @override
124:   Widget build(BuildContext context) {
125:     return StreamBuilder<List<RelationshipInfo>>(
126:       stream: friendService.outgoingRequestsStream(currentUserId),
127:       builder: (context, snapshot) {
128:         if (snapshot.connectionState == ConnectionState.waiting) {
129:           return const Center(child: CircularProgressIndicator());
130:         }
131:         final requests = snapshot.data ?? [];
132:         if (requests.isEmpty) {
133:           return _buildEmptyState(
134:             context,
135:             icon: Icons.outbox_rounded,
136:             title: 'No Sent Requests',
137:             subtitle:
138:                 'Requests you send will appear here\nuntil they are accepted or revoked.',
139:           );
140:         }
141:         return ListView.builder(
142:           padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
143:           physics: const BouncingScrollPhysics(),
144:           itemCount: requests.length,
145:           itemBuilder: (context, index) {
146:             final request = requests[index];
147:             return _RequestTile(
148:               otherUid: request.otherUid,
149:               currentUserId: currentUserId,
150:               friendService: friendService,
151:               isIncoming: false,
152:             );
153:           },
154:         );
155:       },
156:     );
157:   }
158: }
159: // ─── REQUEST TILE ───────────────────────────────────────────────────────────
160: class _RequestTile extends StatefulWidget {
161:   final String otherUid;
162:   final String currentUserId;
163:   final FriendService friendService;
164:   final bool isIncoming;
165:   const _RequestTile({
166:     required this.otherUid,
167:     required this.currentUserId,
168:     required this.friendService,
169:     required this.isIncoming,
170:   });
171:   @override
172:   State<_RequestTile> createState() => _RequestTileState();
173: }
174: class _RequestTileState extends State<_RequestTile> {
175:   Map<String, dynamic>? _userData;
176:   bool _isLoading = true;
177:   bool _actionInProgress = false;
178:   @override
179:   void initState() {
180:     super.initState();
181:     _loadUser();
182:   }
183:   Future<void> _loadUser() async {
184:     try {
185:       final doc = await FirebaseFirestore.instance
186:           .collection('users')
187:           .doc(widget.otherUid)
188:           .get();
189:       if (mounted) {
190:         if (doc.exists) {
191:           final data = doc.data() as Map<String, dynamic>;
192:           data['uid'] = doc.id;
193:           setState(() {
194:             _userData = data;
195:             _isLoading = false;
196:           });
197:         } else {
198:           setState(() => _isLoading = false);
199:         }
200:       }
201:     } catch (e) {
202:       if (mounted) setState(() => _isLoading = false);
203:     }
204:   }
205:   Future<void> _accept() async {
206:     if (_actionInProgress) return;
207:     setState(() => _actionInProgress = true);
208:     try {
209:       final result = await widget.friendService.acceptRequest(
210:         widget.currentUserId,
211:         widget.otherUid,
212:       );
213:       if (mounted && result == 'accepted') {
214:         ScaffoldMessenger.of(context).showSnackBar(
215:           SnackBar(
216:             content: Text(
217:               'Now friends with ${_userData?['username'] ?? 'user'}! 🎉',
218:             ),
219:             behavior: SnackBarBehavior.floating,
220:             shape: RoundedRectangleBorder(
221:               borderRadius: BorderRadius.circular(10),
222:             ),
223:           ),
224:         );
225:       }
226:     } catch (e) {
227:       if (mounted) {
228:         ScaffoldMessenger.of(context).showSnackBar(
229:           const SnackBar(content: Text('Failed to accept request.')),
230:         );
231:       }
232:     } finally {
233:       if (mounted) setState(() => _actionInProgress = false);
234:     }
235:   }
236:   Future<void> _decline() async {
237:     if (_actionInProgress) return;
238:     setState(() => _actionInProgress = true);
239:     try {
240:       await widget.friendService.declineRequest(
241:         widget.currentUserId,
242:         widget.otherUid,
243:       );
244:     } catch (e) {
245:       if (mounted) {
246:         ScaffoldMessenger.of(context).showSnackBar(
247:           const SnackBar(content: Text('Failed to decline request.')),
248:         );
249:       }
250:     } finally {
251:       if (mounted) setState(() => _actionInProgress = false);
252:     }
253:   }
254:   Future<void> _revoke() async {
255:     if (_actionInProgress) return;
256:     setState(() => _actionInProgress = true);
257:     try {
258:       await widget.friendService.revokeRequest(
259:         widget.currentUserId,
260:         widget.otherUid,
261:       );
262:     } catch (e) {
263:       if (mounted) {
264:         ScaffoldMessenger.of(context).showSnackBar(
265:           const SnackBar(content: Text('Failed to revoke request.')),
266:         );
267:       }
268:     } finally {
269:       if (mounted) setState(() => _actionInProgress = false);
270:     }
271:   }
272:   @override
273:   Widget build(BuildContext context) {
274:     final theme = Theme.of(context);
275:     final colorScheme = theme.colorScheme;
276:     if (_isLoading) {
277:       return Container(
278:         margin: const EdgeInsets.only(bottom: 10),
279:         padding: const EdgeInsets.all(14),
280:         decoration: BoxDecoration(
281:           color: colorScheme.onSurface.withValues(alpha: 0.03),
282:           borderRadius: BorderRadius.circular(18),
283:         ),
284:         child: Row(
285:           children: [
286:             Container(
287:               width: 50,
288:               height: 50,
289:               decoration: BoxDecoration(
290:                 shape: BoxShape.circle,
291:                 color: colorScheme.onSurface.withValues(alpha: 0.06),
292:               ),
293:             ),
294:             const SizedBox(width: 14),
295:             Expanded(
296:               child: Container(
297:                 height: 12,
298:                 decoration: BoxDecoration(
299:                   color: colorScheme.onSurface.withValues(alpha: 0.06),
300:                   borderRadius: BorderRadius.circular(6),
301:                 ),
302:               ),
303:             ),
304:           ],
305:         ),
306:       );
307:     }
308:     if (_userData == null) return const SizedBox.shrink();
309:     final username = _userData!['username'] ?? 'Unknown';
310:     return Container(
311:       margin: const EdgeInsets.only(bottom: 10),
312:       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
313:       decoration: BoxDecoration(
314:         color: colorScheme.onSurface.withValues(alpha: 0.04),
315:         borderRadius: BorderRadius.circular(18),
316:       ),
317:       child: Row(
318:         children: [
319:           CircleAvatar(
320:             radius: 25,
321:             backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
322:             child: Text(
323:               username.isNotEmpty ? username[0].toUpperCase() : '?',
324:               style: TextStyle(
325:                 fontSize: 20,
326:                 fontWeight: FontWeight.bold,
327:                 color: colorScheme.primary,
328:               ),
329:             ),
330:           ),
331:           const SizedBox(width: 14),
332:           Expanded(
333:             child: Column(
334:               crossAxisAlignment: CrossAxisAlignment.start,
335:               children: [
336:                 Text(
337:                   username,
338:                   style: theme.textTheme.bodyLarge?.copyWith(
339:                     fontWeight: FontWeight.w600,
340:                     color: colorScheme.onSurface,
341:                   ),
342:                   maxLines: 1,
343:                   overflow: TextOverflow.ellipsis,
344:                 ),
345:                 const SizedBox(height: 2),
346:                 Text(
347:                   '@$username',
348:                   style: theme.textTheme.bodySmall?.copyWith(
349:                     color: colorScheme.onSurface.withValues(alpha: 0.45),
350:                   ),
351:                   maxLines: 1,
352:                   overflow: TextOverflow.ellipsis,
353:                 ),
354:               ],
355:             ),
356:           ),
357:           const SizedBox(width: 8),
358:           if (widget.isIncoming)
359:             _buildIncomingActions(colorScheme)
360:           else
361:             _buildOutgoingAction(colorScheme),
362:         ],
363:       ),
364:     );
365:   }
366:   Widget _buildIncomingActions(ColorScheme colorScheme) {
367:     if (_actionInProgress) {
368:       return SizedBox(
369:         width: 24,
370:         height: 24,
371:         child: CircularProgressIndicator(
372:           strokeWidth: 2,
373:           color: colorScheme.primary,
374:         ),
375:       );
376:     }
377:     return Row(
378:       mainAxisSize: MainAxisSize.min,
379:       children: [
380:         // Decline
381:         GestureDetector(
382:           onTap: _decline,
383:           child: Container(
384:             padding: const EdgeInsets.all(8),
385:             decoration: BoxDecoration(
386:               color: colorScheme.error.withValues(alpha: 0.1),
387:               shape: BoxShape.circle,
388:             ),
389:             child: Icon(
390:               Icons.close_rounded,
391:               size: 20,
392:               color: colorScheme.error,
393:             ),
394:           ),
395:         ),
396:         const SizedBox(width: 8),
397:         // Accept
398:         GestureDetector(
399:           onTap: _accept,
400:           child: Container(
401:             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
402:             decoration: BoxDecoration(
403:               color: colorScheme.primary,
404:               borderRadius: BorderRadius.circular(12),
405:             ),
406:             child: Text(
407:               'Accept',
408:               style: TextStyle(
409:                 color: colorScheme.onPrimary,
410:                 fontWeight: FontWeight.w600,
411:                 fontSize: 13,
412:               ),
413:             ),
414:           ),
415:         ),
416:       ],
417:     );
418:   }
419:   Widget _buildOutgoingAction(ColorScheme colorScheme) {
420:     if (_actionInProgress) {
421:       return SizedBox(
422:         width: 24,
423:         height: 24,
424:         child: CircularProgressIndicator(
425:           strokeWidth: 2,
426:           color: colorScheme.error,
427:         ),
428:       );
429:     }
430:     return GestureDetector(
431:       onTap: _revoke,
432:       child: Container(
433:         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
434:         decoration: BoxDecoration(
435:           color: colorScheme.onSurface.withValues(alpha: 0.08),
436:           borderRadius: BorderRadius.circular(12),
437:         ),
438:         child: Text(
439:           'Revoke',
440:           style: TextStyle(
441:             color: colorScheme.onSurface.withValues(alpha: 0.6),
442:             fontWeight: FontWeight.w600,
443:             fontSize: 13,
444:           ),
445:         ),
446:       ),
447:     );
448:   }
449: }
450: // ─── SHARED EMPTY STATE ─────────────────────────────────────────────────────
451: Widget _buildEmptyState(
452:   BuildContext context, {
453:   required IconData icon,
454:   required String title,
455:   required String subtitle,
456: }) {
457:   final theme = Theme.of(context);
458:   final colorScheme = theme.colorScheme;
459:   return Center(
460:     child: Padding(
461:       padding: const EdgeInsets.symmetric(horizontal: 40),
462:       child: Column(
463:         mainAxisSize: MainAxisSize.min,
464:         children: [
465:           Icon(
466:             icon,
467:             size: 80,
468:             color: colorScheme.onSurface.withValues(alpha: 0.15),
469:           ),
470:           const SizedBox(height: 20),
471:           Text(
472:             title,
473:             style: theme.textTheme.titleLarge?.copyWith(
474:               fontWeight: FontWeight.w700,
475:               color: colorScheme.onSurface,
476:             ),
477:           ),
478:           const SizedBox(height: 10),
479:           Text(
480:             subtitle,
481:             textAlign: TextAlign.center,
482:             style: theme.textTheme.bodyMedium?.copyWith(
483:               color: colorScheme.onSurface.withValues(alpha: 0.5),
484:               height: 1.5,
485:             ),
486:           ),
487:         ],
488:       ),
489:     ),
490:   );
491: }
````

## File: lib/services/friend_service.dart
````dart
  1: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2: // FILE: lib/services/friend_service.dart
  3: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  4: import 'dart:async';
  5: import 'package:cloud_firestore/cloud_firestore.dart';
  6: /// Canonical relationship types stored in the global relationships collection
  7: enum RelationshipType { pending, friends }
  8: /// Per-user relationship perspective
  9: enum UserRelationshipType { pendingSent, pendingReceived, friends }
 10: /// UI-friendly status including "none" and "loading"
 11: enum FriendStatus { none, requestSent, requestReceived, friends, loading }
 12: /// Centralized service for all friend/relationship operations.
 13: /// All mutations use Firestore transactions to prevent race conditions.
 14: /// All reads can be real-time via streams.
 15: class FriendService {
 16:   static final FriendService _instance = FriendService._internal();
 17:   factory FriendService() => _instance;
 18:   FriendService._internal();
 19:   final FirebaseFirestore _db = FirebaseFirestore.instance;
 20:   // ─── CANONICAL ID ──────────────────────────────────────────────────────
 21:   /// Produces a deterministic, order-independent document ID for any user pair.
 22:   /// This is the single most important function in the entire system.
 23:   /// It guarantees that for users A and B, there is exactly ONE possible ID.
 24:   String canonicalId(String uid1, String uid2) {
 25:     final sorted = [uid1, uid2]..sort();
 26:     return '${sorted[0]}_${sorted[1]}';
 27:   }
 28:   // ─── REFERENCES ────────────────────────────────────────────────────────
 29:   DocumentReference _relationshipRef(String uid1, String uid2) {
 30:     return _db.collection('relationships').doc(canonicalId(uid1, uid2));
 31:   }
 32:   DocumentReference _userRelRef(String ownerUid, String otherUid) {
 33:     return _db
 34:         .collection('users')
 35:         .doc(ownerUid)
 36:         .collection('relationships')
 37:         .doc(otherUid);
 38:   }
 39:   // ─── GET STATUS (one-time) ────────────────────────────────────────────
 40:   Future<FriendStatus> getStatus(String currentUid, String targetUid) async {
 41:     if (currentUid == targetUid) return FriendStatus.none;
 42:     final doc = await _userRelRef(currentUid, targetUid).get();
 43:     if (!doc.exists) return FriendStatus.none;
 44:     final data = doc.data() as Map<String, dynamic>;
 45:     final type = data['type'] as String?;
 46:     switch (type) {
 47:       case 'friends':
 48:         return FriendStatus.friends;
 49:       case 'pending_sent':
 50:         return FriendStatus.requestSent;
 51:       case 'pending_received':
 52:         return FriendStatus.requestReceived;
 53:       default:
 54:         return FriendStatus.none;
 55:     }
 56:   }
 57:   // ─── STREAM STATUS (real-time) ─────────────────────────────────────────
 58:   /// Returns a real-time stream of the relationship status between two users.
 59:   /// The UI should listen to this instead of doing one-time reads.
 60:   Stream<FriendStatus> statusStream(String currentUid, String targetUid) {
 61:     if (currentUid == targetUid) {
 62:       return Stream.value(FriendStatus.none);
 63:     }
 64:     return _userRelRef(currentUid, targetUid).snapshots().map((snapshot) {
 65:       if (!snapshot.exists) return FriendStatus.none;
 66:       final data = snapshot.data() as Map<String, dynamic>;
 67:       final type = data['type'] as String?;
 68:       switch (type) {
 69:         case 'friends':
 70:           return FriendStatus.friends;
 71:         case 'pending_sent':
 72:           return FriendStatus.requestSent;
 73:         case 'pending_received':
 74:           return FriendStatus.requestReceived;
 75:         default:
 76:           return FriendStatus.none;
 77:       }
 78:     });
 79:   }
 80:   // ─── SEND FRIEND REQUEST ──────────────────────────────────────────────
 81:   /// Sends a friend request from [currentUid] to [targetUid].
 82:   ///
 83:   /// Uses a transaction to atomically check existing state:
 84:   /// - If already friends → no-op, returns 'already_friends'
 85:   /// - If current user already sent a request → no-op, returns 'already_sent'
 86:   /// - If target already sent a request to current user → AUTO-ACCEPT,
 87:   ///   returns 'auto_accepted'
 88:   /// - If no relationship exists → create pending request, returns 'request_sent'
 89:   Future<String> sendRequest(String currentUid, String targetUid) async {
 90:     if (currentUid == targetUid) return 'cannot_self_request';
 91:     final relRef = _relationshipRef(currentUid, targetUid);
 92:     return _db.runTransaction<String>((transaction) async {
 93:       final relSnap = await transaction.get(relRef);
 94:       if (relSnap.exists) {
 95:         final data = relSnap.data() as Map<String, dynamic>;
 96:         final type = data['type'] as String?;
 97:         final requestedBy = data['requestedBy'] as String?;
 98:         if (type == 'friends') {
 99:           return 'already_friends';
100:         }
101:         if (type == 'pending') {
102:           if (requestedBy == currentUid) {
103:             return 'already_sent';
104:           }
105:           // REVERSE REQUEST EXISTS → AUTO-ACCEPT
106:           // Target already sent us a request, so this is mutual — become friends
107:           final now = FieldValue.serverTimestamp();
108:           transaction.update(relRef, {
109:             'type': 'friends',
110:             'requestedBy': FieldValue.delete(),
111:             'updatedAt': now,
112:           });
113:           transaction.set(_userRelRef(currentUid, targetUid), {
114:             'type': 'friends',
115:             'updatedAt': now,
116:           });
117:           transaction.set(_userRelRef(targetUid, currentUid), {
118:             'type': 'friends',
119:             'updatedAt': now,
120:           });
121:           return 'auto_accepted';
122:         }
123:       }
124:       // No relationship exists → create pending request
125:       final now = FieldValue.serverTimestamp();
126:       transaction.set(relRef, {
127:         'users': [currentUid, targetUid],
128:         'type': 'pending',
129:         'requestedBy': currentUid,
130:         'createdAt': now,
131:         'updatedAt': now,
132:       });
133:       transaction.set(_userRelRef(currentUid, targetUid), {
134:         'type': 'pending_sent',
135:         'updatedAt': now,
136:       });
137:       transaction.set(_userRelRef(targetUid, currentUid), {
138:         'type': 'pending_received',
139:         'updatedAt': now,
140:       });
141:       return 'request_sent';
142:     });
143:   }
144:   // ─── ACCEPT FRIEND REQUEST ────────────────────────────────────────────
145:   /// Accepts a pending friend request from [requesterUid] to [currentUid].
146:   ///
147:   /// Uses a transaction to verify:
148:   /// - The relationship document exists
149:   /// - It is in 'pending' state
150:   /// - The request was sent BY the other user (not by current user)
151:   Future<String> acceptRequest(String currentUid, String requesterUid) async {
152:     final relRef = _relationshipRef(currentUid, requesterUid);
153:     return _db.runTransaction<String>((transaction) async {
154:       final relSnap = await transaction.get(relRef);
155:       if (!relSnap.exists) {
156:         return 'no_request_found';
157:       }
158:       final data = relSnap.data() as Map<String, dynamic>;
159:       final type = data['type'] as String?;
160:       final requestedBy = data['requestedBy'] as String?;
161:       if (type == 'friends') {
162:         return 'already_friends';
163:       }
164:       if (type != 'pending') {
165:         return 'invalid_state';
166:       }
167:       if (requestedBy == currentUid) {
168:         // Current user sent this request — they can't accept their own request
169:         return 'cannot_accept_own_request';
170:       }
171:       final now = FieldValue.serverTimestamp();
172:       transaction.update(relRef, {
173:         'type': 'friends',
174:         'requestedBy': FieldValue.delete(),
175:         'updatedAt': now,
176:       });
177:       transaction.set(_userRelRef(currentUid, requesterUid), {
178:         'type': 'friends',
179:         'updatedAt': now,
180:       });
181:       transaction.set(_userRelRef(requesterUid, currentUid), {
182:         'type': 'friends',
183:         'updatedAt': now,
184:       });
185:       return 'accepted';
186:     });
187:   }
188:   // ─── DECLINE FRIEND REQUEST ───────────────────────────────────────────
189:   /// Declines (rejects) a pending friend request from [requesterUid].
190:   Future<String> declineRequest(String currentUid, String requesterUid) async {
191:     final relRef = _relationshipRef(currentUid, requesterUid);
192:     return _db.runTransaction<String>((transaction) async {
193:       final relSnap = await transaction.get(relRef);
194:       if (!relSnap.exists) {
195:         return 'no_request_found';
196:       }
197:       final data = relSnap.data() as Map<String, dynamic>;
198:       final type = data['type'] as String?;
199:       final requestedBy = data['requestedBy'] as String?;
200:       if (type != 'pending') {
201:         return 'not_pending';
202:       }
203:       if (requestedBy == currentUid) {
204:         return 'cannot_decline_own_request';
205:       }
206:       transaction.delete(relRef);
207:       transaction.delete(_userRelRef(currentUid, requesterUid));
208:       transaction.delete(_userRelRef(requesterUid, currentUid));
209:       return 'declined';
210:     });
211:   }
212:   // ─── REVOKE SENT REQUEST ──────────────────────────────────────────────
213:   /// Revokes (cancels) a friend request that [currentUid] previously sent.
214:   Future<String> revokeRequest(String currentUid, String targetUid) async {
215:     final relRef = _relationshipRef(currentUid, targetUid);
216:     return _db.runTransaction<String>((transaction) async {
217:       final relSnap = await transaction.get(relRef);
218:       if (!relSnap.exists) {
219:         return 'no_request_found';
220:       }
221:       final data = relSnap.data() as Map<String, dynamic>;
222:       final type = data['type'] as String?;
223:       final requestedBy = data['requestedBy'] as String?;
224:       if (type != 'pending') {
225:         return 'not_pending';
226:       }
227:       if (requestedBy != currentUid) {
228:         // Can't revoke a request you didn't send
229:         return 'not_your_request';
230:       }
231:       transaction.delete(relRef);
232:       transaction.delete(_userRelRef(currentUid, targetUid));
233:       transaction.delete(_userRelRef(targetUid, currentUid));
234:       return 'revoked';
235:     });
236:   }
237:   // ─── REMOVE FRIEND ────────────────────────────────────────────────────
238:   /// Removes an existing friendship between [currentUid] and [friendUid].
239:   Future<String> removeFriend(String currentUid, String friendUid) async {
240:     final relRef = _relationshipRef(currentUid, friendUid);
241:     return _db.runTransaction<String>((transaction) async {
242:       final relSnap = await transaction.get(relRef);
243:       if (!relSnap.exists) {
244:         return 'not_friends';
245:       }
246:       final data = relSnap.data() as Map<String, dynamic>;
247:       final type = data['type'] as String?;
248:       if (type != 'friends') {
249:         return 'not_friends';
250:       }
251:       transaction.delete(relRef);
252:       transaction.delete(_userRelRef(currentUid, friendUid));
253:       transaction.delete(_userRelRef(friendUid, currentUid));
254:       return 'removed';
255:     });
256:   }
257:   // ─── QUERY: INCOMING FRIEND REQUESTS ──────────────────────────────────
258:   /// Returns a real-time stream of all pending friend requests received by [uid].
259:   Stream<List<RelationshipInfo>> incomingRequestsStream(String uid) {
260:     return _db
261:         .collection('users')
262:         .doc(uid)
263:         .collection('relationships')
264:         .where('type', isEqualTo: 'pending_received')
265:         .snapshots()
266:         .map((snapshot) {
267:           return snapshot.docs.map((doc) {
268:             return RelationshipInfo(
269:               otherUid: doc.id,
270:               type: UserRelationshipType.pendingReceived,
271:               updatedAt: doc.data()['updatedAt'] as Timestamp?,
272:             );
273:           }).toList();
274:         });
275:   }
276:   // ─── QUERY: OUTGOING FRIEND REQUESTS ──────────────────────────────────
277:   Stream<List<RelationshipInfo>> outgoingRequestsStream(String uid) {
278:     return _db
279:         .collection('users')
280:         .doc(uid)
281:         .collection('relationships')
282:         .where('type', isEqualTo: 'pending_sent')
283:         .snapshots()
284:         .map((snapshot) {
285:           return snapshot.docs.map((doc) {
286:             return RelationshipInfo(
287:               otherUid: doc.id,
288:               type: UserRelationshipType.pendingSent,
289:               updatedAt: doc.data()['updatedAt'] as Timestamp?,
290:             );
291:           }).toList();
292:         });
293:   }
294:   // ─── QUERY: FRIENDS LIST ──────────────────────────────────────────────
295:   Stream<List<RelationshipInfo>> friendsStream(String uid) {
296:     return _db
297:         .collection('users')
298:         .doc(uid)
299:         .collection('relationships')
300:         .where('type', isEqualTo: 'friends')
301:         .snapshots()
302:         .map((snapshot) {
303:           return snapshot.docs.map((doc) {
304:             return RelationshipInfo(
305:               otherUid: doc.id,
306:               type: UserRelationshipType.friends,
307:               updatedAt: doc.data()['updatedAt'] as Timestamp?,
308:             );
309:           }).toList();
310:         });
311:   }
312:   // ─── QUERY: INCOMING REQUEST COUNT ────────────────────────────────────
313:   Stream<int> incomingRequestCountStream(String uid) {
314:     return _db
315:         .collection('users')
316:         .doc(uid)
317:         .collection('relationships')
318:         .where('type', isEqualTo: 'pending_received')
319:         .snapshots()
320:         .map((snapshot) => snapshot.docs.length);
321:   }
322:   // ─── BATCH STATUS CHECK ───────────────────────────────────────────────
323:   /// Checks relationship status for multiple targets at once.
324:   /// Much more efficient than checking one at a time.
325:   Future<Map<String, FriendStatus>> batchGetStatuses(
326:     String currentUid,
327:     List<String> targetUids,
328:   ) async {
329:     if (targetUids.isEmpty) return {};
330:     final results = <String, FriendStatus>{};
331:     // Firestore 'in' queries support max 30 values, but we're querying by doc ID
332:     // so we'll do individual gets in parallel
333:     final futures = targetUids.map((targetUid) async {
334:       final status = await getStatus(currentUid, targetUid);
335:       return MapEntry(targetUid, status);
336:     });
337:     final entries = await Future.wait(futures);
338:     for (final entry in entries) {
339:       results[entry.key] = entry.value;
340:     }
341:     return results;
342:   }
343: }
344: /// Data class for relationship query results
345: class RelationshipInfo {
346:   final String otherUid;
347:   final UserRelationshipType type;
348:   final Timestamp? updatedAt;
349:   RelationshipInfo({
350:     required this.otherUid,
351:     required this.type,
352:     this.updatedAt,
353:   });
354: }
````

## File: lib/widgets/friend_action_button.dart
````dart
  1: import 'dart:async';
  2: import 'package:flutter/material.dart';
  3: import '../services/friend_service.dart';
  4: import '../services/chat_service.dart';
  5: import '../screens/chat_screen.dart';
  6: class FriendActionButton extends StatefulWidget {
  7:   final String targetUid;
  8:   final String currentUserId;
  9:   final String targetUsername;
 10:   final bool expanded;
 11:   const FriendActionButton({
 12:     super.key,
 13:     required this.targetUid,
 14:     required this.currentUserId,
 15:     this.targetUsername = '',
 16:     this.expanded = false,
 17:   });
 18:   @override
 19:   State<FriendActionButton> createState() => _FriendActionButtonState();
 20: }
 21: class _FriendActionButtonState extends State<FriendActionButton> {
 22:   final _friendService = FriendService();
 23:   StreamSubscription<FriendStatus>? _statusSub;
 24:   FriendStatus _status = FriendStatus.loading;
 25:   bool _actionInProgress = false;
 26:   @override
 27:   void initState() {
 28:     super.initState();
 29:     _listenStatus();
 30:   }
 31:   @override
 32:   void didUpdateWidget(covariant FriendActionButton oldWidget) {
 33:     super.didUpdateWidget(oldWidget);
 34:     if (oldWidget.targetUid != widget.targetUid ||
 35:         oldWidget.currentUserId != widget.currentUserId) {
 36:       _statusSub?.cancel();
 37:       setState(() => _status = FriendStatus.loading);
 38:       _listenStatus();
 39:     }
 40:   }
 41:   void _listenStatus() {
 42:     _statusSub = _friendService
 43:         .statusStream(widget.currentUserId, widget.targetUid)
 44:         .listen(
 45:           (status) {
 46:             if (mounted) setState(() => _status = status);
 47:           },
 48:           onError: (_) {
 49:             if (mounted) setState(() => _status = FriendStatus.none);
 50:           },
 51:         );
 52:   }
 53:   @override
 54:   void dispose() {
 55:     _statusSub?.cancel();
 56:     super.dispose();
 57:   }
 58:   void _showSnackBar(String message) {
 59:     if (!mounted) return;
 60:     ScaffoldMessenger.of(context).showSnackBar(
 61:       SnackBar(
 62:         content: Text(message),
 63:         behavior: SnackBarBehavior.floating,
 64:         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
 65:         duration: const Duration(seconds: 2),
 66:       ),
 67:     );
 68:   }
 69:   Future<void> _sendRequest() async {
 70:     if (_actionInProgress) return;
 71:     setState(() => _actionInProgress = true);
 72:     try {
 73:       final result = await _friendService.sendRequest(
 74:         widget.currentUserId,
 75:         widget.targetUid,
 76:       );
 77:       if (mounted) {
 78:         if (result == 'auto_accepted') _showSnackBar('You are now friends! 🎉');
 79:         if (result == 'already_friends') _showSnackBar('Already friends.');
 80:         if (result == 'already_sent') _showSnackBar('Request already sent.');
 81:       }
 82:     } catch (e) {
 83:       if (mounted) _showSnackBar('Failed to send request.');
 84:     } finally {
 85:       if (mounted) setState(() => _actionInProgress = false);
 86:     }
 87:   }
 88:   Future<void> _revokeRequest() async {
 89:     if (_actionInProgress) return;
 90:     setState(() => _actionInProgress = true);
 91:     try {
 92:       await _friendService.revokeRequest(
 93:         widget.currentUserId,
 94:         widget.targetUid,
 95:       );
 96:     } catch (e) {
 97:       if (mounted) _showSnackBar('Failed to revoke.');
 98:     } finally {
 99:       if (mounted) setState(() => _actionInProgress = false);
100:     }
101:   }
102:   Future<void> _acceptRequest() async {
103:     if (_actionInProgress) return;
104:     setState(() => _actionInProgress = true);
105:     try {
106:       final result = await _friendService.acceptRequest(
107:         widget.currentUserId,
108:         widget.targetUid,
109:       );
110:       if (mounted && result == 'accepted') {
111:         _showSnackBar('Friend request accepted! 🎉');
112:       }
113:     } catch (e) {
114:       if (mounted) _showSnackBar('Failed to accept.');
115:     } finally {
116:       if (mounted) setState(() => _actionInProgress = false);
117:     }
118:   }
119:   void _showRevokeDialog() {
120:     final theme = Theme.of(context);
121:     final cs = theme.colorScheme;
122:     showDialog(
123:       context: context,
124:       builder: (ctx) => Dialog(
125:         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
126:         child: Padding(
127:           padding: const EdgeInsets.all(20),
128:           child: Column(
129:             mainAxisSize: MainAxisSize.min,
130:             children: [
131:               Icon(Icons.undo_rounded, color: cs.error, size: 48),
132:               const SizedBox(height: 16),
133:               Text(
134:                 'Revoke Friend Request?',
135:                 textAlign: TextAlign.center,
136:                 style: theme.textTheme.titleMedium?.copyWith(
137:                   fontWeight: FontWeight.w700,
138:                 ),
139:               ),
140:               const SizedBox(height: 8),
141:               Text(
142:                 'Withdraw your friend request?',
143:                 textAlign: TextAlign.center,
144:                 style: theme.textTheme.bodyMedium?.copyWith(
145:                   color: cs.onSurface.withValues(alpha: 0.6),
146:                 ),
147:               ),
148:               const SizedBox(height: 24),
149:               Row(
150:                 children: [
151:                   Expanded(
152:                     child: OutlinedButton(
153:                       style: OutlinedButton.styleFrom(
154:                         padding: const EdgeInsets.symmetric(vertical: 14),
155:                         shape: RoundedRectangleBorder(
156:                           borderRadius: BorderRadius.circular(12),
157:                         ),
158:                       ),
159:                       onPressed: () => Navigator.pop(ctx),
160:                       child: const Text('Cancel'),
161:                     ),
162:                   ),
163:                   const SizedBox(width: 12),
164:                   Expanded(
165:                     child: ElevatedButton(
166:                       style: ElevatedButton.styleFrom(
167:                         backgroundColor: cs.error,
168:                         foregroundColor: cs.onError,
169:                         padding: const EdgeInsets.symmetric(vertical: 14),
170:                         shape: RoundedRectangleBorder(
171:                           borderRadius: BorderRadius.circular(12),
172:                         ),
173:                       ),
174:                       onPressed: () {
175:                         Navigator.pop(ctx);
176:                         _revokeRequest();
177:                       },
178:                       child: const Text(
179:                         'Revoke',
180:                         style: TextStyle(fontWeight: FontWeight.bold),
181:                       ),
182:                     ),
183:                   ),
184:                 ],
185:               ),
186:             ],
187:           ),
188:         ),
189:       ),
190:     );
191:   }
192:   void _openChat() {
193:     final chatService = ChatService();
194:     final chatId = chatService.getChatId(
195:       widget.currentUserId,
196:       widget.targetUid,
197:     );
198:     Navigator.of(context).push(
199:       MaterialPageRoute(
200:         builder: (_) => ChatScreen(
201:           chatId: chatId,
202:           friendUid: widget.targetUid,
203:           friendUsername: widget.targetUsername,
204:         ),
205:       ),
206:     );
207:   }
208:   @override
209:   Widget build(BuildContext context) {
210:     final cs = Theme.of(context).colorScheme;
211:     switch (_status) {
212:       case FriendStatus.loading:
213:         return SizedBox(
214:           width: 24,
215:           height: 24,
216:           child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
217:         );
218:       case FriendStatus.none:
219:         return _btn(
220:           label: 'Add Friend',
221:           icon: Icons.person_add_rounded,
222:           color: cs.primary,
223:           textColor: cs.onPrimary,
224:           onTap: _sendRequest,
225:         );
226:       case FriendStatus.requestSent:
227:         return _btn(
228:           label: 'Requested',
229:           icon: Icons.schedule_rounded,
230:           color: cs.onSurface.withValues(alpha: 0.1),
231:           textColor: cs.onSurface.withValues(alpha: 0.6),
232:           onTap: _showRevokeDialog,
233:         );
234:       case FriendStatus.requestReceived:
235:         return _btn(
236:           label: 'Accept',
237:           icon: Icons.check_circle_outline_rounded,
238:           color: cs.tertiary,
239:           textColor: cs.onTertiary,
240:           onTap: _acceptRequest,
241:         );
242:       case FriendStatus.friends:
243:         return _btn(
244:           label: 'Chat',
245:           icon: Icons.chat_bubble_rounded,
246:           color: cs.primary,
247:           textColor: cs.onPrimary,
248:           onTap: _openChat,
249:         );
250:     }
251:   }
252:   Widget _btn({
253:     required String label,
254:     required IconData icon,
255:     required Color color,
256:     required Color textColor,
257:     required VoidCallback onTap,
258:   }) {
259:     return GestureDetector(
260:       onTap: _actionInProgress ? null : onTap,
261:       child: AnimatedContainer(
262:         duration: const Duration(milliseconds: 300),
263:         curve: Curves.easeOutCubic,
264:         padding: EdgeInsets.symmetric(
265:           horizontal: widget.expanded ? 20 : 12,
266:           vertical: widget.expanded ? 12 : 8,
267:         ),
268:         decoration: BoxDecoration(
269:           color: color,
270:           borderRadius: BorderRadius.circular(12),
271:         ),
272:         child: _actionInProgress
273:             ? SizedBox(
274:                 width: 18,
275:                 height: 18,
276:                 child: CircularProgressIndicator(
277:                   strokeWidth: 2,
278:                   color: textColor,
279:                 ),
280:               )
281:             : Row(
282:                 mainAxisSize: widget.expanded
283:                     ? MainAxisSize.max
284:                     : MainAxisSize.min,
285:                 mainAxisAlignment: MainAxisAlignment.center,
286:                 children: [
287:                   Icon(icon, size: 16, color: textColor),
288:                   const SizedBox(width: 6),
289:                   Flexible(
290:                     child: Text(
291:                       label,
292:                       style: TextStyle(
293:                         color: textColor,
294:                         fontWeight: FontWeight.w600,
295:                         fontSize: 13,
296:                       ),
297:                       maxLines: 1,
298:                       overflow: TextOverflow.ellipsis,
299:                     ),
300:                   ),
301:                 ],
302:               ),
303:       ),
304:     );
305:   }
306: }
````

## File: lib/widgets/search_result_tile.dart
````dart
 1: import 'package:flutter/material.dart';
 2: import 'friend_action_button.dart';
 3: class SearchResultTile extends StatelessWidget {
 4:   final Map<String, dynamic> userData;
 5:   final String currentUserId;
 6:   final VoidCallback onTap;
 7:   const SearchResultTile({
 8:     super.key,
 9:     required this.userData,
10:     required this.currentUserId,
11:     required this.onTap,
12:   });
13:   @override
14:   Widget build(BuildContext context) {
15:     final theme = Theme.of(context);
16:     final cs = theme.colorScheme;
17:     final username = userData['username'] ?? 'Unknown';
18:     final uid = userData['uid'] ?? '';
19:     return GestureDetector(
20:       onTap: onTap,
21:       child: Container(
22:         margin: const EdgeInsets.only(bottom: 10),
23:         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
24:         decoration: BoxDecoration(
25:           color: cs.onSurface.withValues(alpha: 0.04),
26:           borderRadius: BorderRadius.circular(18),
27:         ),
28:         child: Row(
29:           children: [
30:             CircleAvatar(
31:               radius: 25,
32:               backgroundColor: cs.primary.withValues(alpha: 0.15),
33:               child: Text(
34:                 username.isNotEmpty ? username[0].toUpperCase() : '?',
35:                 style: TextStyle(
36:                   fontSize: 20,
37:                   fontWeight: FontWeight.bold,
38:                   color: cs.primary,
39:                 ),
40:               ),
41:             ),
42:             const SizedBox(width: 14),
43:             Expanded(
44:               child: Column(
45:                 crossAxisAlignment: CrossAxisAlignment.start,
46:                 children: [
47:                   Text(
48:                     username,
49:                     style: theme.textTheme.bodyLarge?.copyWith(
50:                       fontWeight: FontWeight.w600,
51:                       color: cs.onSurface,
52:                     ),
53:                     maxLines: 1,
54:                     overflow: TextOverflow.ellipsis,
55:                   ),
56:                   const SizedBox(height: 2),
57:                   Text(
58:                     '@$username',
59:                     style: theme.textTheme.bodySmall?.copyWith(
60:                       color: cs.onSurface.withValues(alpha: 0.45),
61:                     ),
62:                     maxLines: 1,
63:                     overflow: TextOverflow.ellipsis,
64:                   ),
65:                 ],
66:               ),
67:             ),
68:             const SizedBox(width: 8),
69:             FriendActionButton(
70:               targetUid: uid,
71:               currentUserId: currentUserId,
72:               targetUsername: username, // ← ADDED
73:             ),
74:           ],
75:         ),
76:       ),
77:     );
78:   }
79: }
````

## File: lib/screens/user_profile_view.dart
````dart
  1: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2: // FILE: lib/screens/user_profile_view.dart
  3: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  4: import 'dart:async';
  5: import 'package:flutter/material.dart';
  6: import '../services/friend_service.dart';
  7: import '../services/chat_service.dart';
  8: import 'chat_screen.dart';
  9: class UserProfileView extends StatefulWidget {
 10:   final Map<String, dynamic> userData;
 11:   final String currentUserId;
 12:   const UserProfileView({
 13:     super.key,
 14:     required this.userData,
 15:     required this.currentUserId,
 16:   });
 17:   @override
 18:   State<UserProfileView> createState() => _UserProfileViewState();
 19: }
 20: class _UserProfileViewState extends State<UserProfileView> {
 21:   late Map<String, dynamic> _userData;
 22:   final _friendService = FriendService();
 23:   late StreamSubscription<FriendStatus> _statusSubscription;
 24:   FriendStatus _friendStatus = FriendStatus.loading;
 25:   bool _actionInProgress = false;
 26:   @override
 27:   void initState() {
 28:     super.initState();
 29:     _userData = widget.userData;
 30:     _statusSubscription = _friendService
 31:         .statusStream(widget.currentUserId, _userData['uid'])
 32:         .listen(
 33:           (status) {
 34:             if (mounted) setState(() => _friendStatus = status);
 35:           },
 36:           onError: (_) {
 37:             if (mounted) setState(() => _friendStatus = FriendStatus.none);
 38:           },
 39:         );
 40:   }
 41:   @override
 42:   void dispose() {
 43:     _statusSubscription.cancel();
 44:     super.dispose();
 45:   }
 46:   // ─── ACTIONS ──────────────────────────────────────────────────────────
 47:   Future<void> _sendRequest() async {
 48:     if (_actionInProgress) return;
 49:     setState(() => _actionInProgress = true);
 50:     try {
 51:       final result = await _friendService.sendRequest(
 52:         widget.currentUserId,
 53:         _userData['uid'],
 54:       );
 55:       if (mounted) {
 56:         if (result == 'auto_accepted') {
 57:           _showSnackBar('You are now friends! 🎉');
 58:         }
 59:       }
 60:     } catch (e) {
 61:       if (mounted) _showSnackBar('Failed to send request.');
 62:     } finally {
 63:       if (mounted) setState(() => _actionInProgress = false);
 64:     }
 65:   }
 66:   Future<void> _revokeRequest() async {
 67:     if (_actionInProgress) return;
 68:     setState(() => _actionInProgress = true);
 69:     try {
 70:       await _friendService.revokeRequest(
 71:         widget.currentUserId,
 72:         _userData['uid'],
 73:       );
 74:     } catch (e) {
 75:       if (mounted) _showSnackBar('Failed to revoke request.');
 76:     } finally {
 77:       if (mounted) setState(() => _actionInProgress = false);
 78:     }
 79:   }
 80:   Future<void> _acceptRequest() async {
 81:     if (_actionInProgress) return;
 82:     setState(() => _actionInProgress = true);
 83:     try {
 84:       final result = await _friendService.acceptRequest(
 85:         widget.currentUserId,
 86:         _userData['uid'],
 87:       );
 88:       if (mounted && result == 'accepted') {
 89:         _showSnackBar('Friend request accepted! 🎉');
 90:       }
 91:     } catch (e) {
 92:       if (mounted) _showSnackBar('Failed to accept request.');
 93:     } finally {
 94:       if (mounted) setState(() => _actionInProgress = false);
 95:     }
 96:   }
 97:   Future<void> _removeFriend() async {
 98:     if (_actionInProgress) return;
 99:     setState(() => _actionInProgress = true);
100:     try {
101:       await _friendService.removeFriend(widget.currentUserId, _userData['uid']);
102:     } catch (e) {
103:       if (mounted) _showSnackBar('Failed to remove friend.');
104:     } finally {
105:       if (mounted) setState(() => _actionInProgress = false);
106:     }
107:   }
108:   void _showSnackBar(String message) {
109:     if (!mounted) return;
110:     ScaffoldMessenger.of(context).showSnackBar(
111:       SnackBar(
112:         content: Text(message),
113:         behavior: SnackBarBehavior.floating,
114:         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
115:       ),
116:     );
117:   }
118:   void _openChat() {
119:     final chatService = ChatService();
120:     final chatId = chatService.getChatId(
121:       widget.currentUserId,
122:       _userData['uid'],
123:     );
124:     Navigator.of(context).push(
125:       MaterialPageRoute(
126:         builder: (_) => ChatScreen(
127:           chatId: chatId,
128:           friendUid: _userData['uid'],
129:           friendUsername: _userData['username'] ?? 'Unknown',
130:         ),
131:       ),
132:     );
133:   }
134:   // ─── DIALOGS ──────────────────────────────────────────────────────────
135:   void _showRevokeDialog() {
136:     final theme = Theme.of(context);
137:     final colorScheme = theme.colorScheme;
138:     showDialog(
139:       context: context,
140:       builder: (ctx) => Dialog(
141:         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
142:         child: Padding(
143:           padding: const EdgeInsets.all(20),
144:           child: Column(
145:             mainAxisSize: MainAxisSize.min,
146:             children: [
147:               Icon(Icons.undo_rounded, color: colorScheme.error, size: 48),
148:               const SizedBox(height: 16),
149:               Text(
150:                 'Revoke Friend Request?',
151:                 textAlign: TextAlign.center,
152:                 style: theme.textTheme.titleMedium?.copyWith(
153:                   fontWeight: FontWeight.w700,
154:                 ),
155:               ),
156:               const SizedBox(height: 8),
157:               Text(
158:                 'Do you want to withdraw your friend request?',
159:                 textAlign: TextAlign.center,
160:                 style: theme.textTheme.bodyMedium?.copyWith(
161:                   color: colorScheme.onSurface.withValues(alpha: 0.6),
162:                 ),
163:               ),
164:               const SizedBox(height: 24),
165:               Row(
166:                 children: [
167:                   Expanded(
168:                     child: OutlinedButton(
169:                       style: OutlinedButton.styleFrom(
170:                         padding: const EdgeInsets.symmetric(vertical: 14),
171:                         shape: RoundedRectangleBorder(
172:                           borderRadius: BorderRadius.circular(12),
173:                         ),
174:                       ),
175:                       onPressed: () => Navigator.pop(ctx),
176:                       child: const Text('Cancel'),
177:                     ),
178:                   ),
179:                   const SizedBox(width: 12),
180:                   Expanded(
181:                     child: ElevatedButton(
182:                       style: ElevatedButton.styleFrom(
183:                         backgroundColor: colorScheme.error,
184:                         foregroundColor: colorScheme.onError,
185:                         padding: const EdgeInsets.symmetric(vertical: 14),
186:                         shape: RoundedRectangleBorder(
187:                           borderRadius: BorderRadius.circular(12),
188:                         ),
189:                       ),
190:                       onPressed: () {
191:                         Navigator.pop(ctx);
192:                         _revokeRequest();
193:                       },
194:                       child: const Text(
195:                         'Revoke',
196:                         style: TextStyle(fontWeight: FontWeight.bold),
197:                       ),
198:                     ),
199:                   ),
200:                 ],
201:               ),
202:             ],
203:           ),
204:         ),
205:       ),
206:     );
207:   }
208:   void _showRemoveFriendDialog() {
209:     final theme = Theme.of(context);
210:     final colorScheme = theme.colorScheme;
211:     final username = _userData['username'] ?? 'this user';
212:     showDialog(
213:       context: context,
214:       builder: (ctx) => Dialog(
215:         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
216:         child: Padding(
217:           padding: const EdgeInsets.all(20),
218:           child: Column(
219:             mainAxisSize: MainAxisSize.min,
220:             children: [
221:               Icon(
222:                 Icons.person_remove_rounded,
223:                 color: colorScheme.error,
224:                 size: 48,
225:               ),
226:               const SizedBox(height: 16),
227:               Text(
228:                 'Remove Friend',
229:                 textAlign: TextAlign.center,
230:                 style: theme.textTheme.titleMedium?.copyWith(
231:                   fontWeight: FontWeight.w700,
232:                 ),
233:               ),
234:               const SizedBox(height: 8),
235:               Text(
236:                 'Are you sure you want to remove $username from your friends?',
237:                 textAlign: TextAlign.center,
238:                 style: theme.textTheme.bodyMedium?.copyWith(
239:                   color: colorScheme.onSurface.withValues(alpha: 0.6),
240:                 ),
241:               ),
242:               const SizedBox(height: 24),
243:               Row(
244:                 children: [
245:                   Expanded(
246:                     child: OutlinedButton(
247:                       style: OutlinedButton.styleFrom(
248:                         padding: const EdgeInsets.symmetric(vertical: 14),
249:                         shape: RoundedRectangleBorder(
250:                           borderRadius: BorderRadius.circular(12),
251:                         ),
252:                       ),
253:                       onPressed: () => Navigator.pop(ctx),
254:                       child: const Text('Cancel'),
255:                     ),
256:                   ),
257:                   const SizedBox(width: 12),
258:                   Expanded(
259:                     child: ElevatedButton(
260:                       style: ElevatedButton.styleFrom(
261:                         backgroundColor: colorScheme.error,
262:                         foregroundColor: colorScheme.onError,
263:                         padding: const EdgeInsets.symmetric(vertical: 14),
264:                         shape: RoundedRectangleBorder(
265:                           borderRadius: BorderRadius.circular(12),
266:                         ),
267:                       ),
268:                       onPressed: () {
269:                         Navigator.pop(ctx);
270:                         _removeFriend();
271:                       },
272:                       child: const Text(
273:                         'Remove',
274:                         style: TextStyle(fontWeight: FontWeight.bold),
275:                       ),
276:                     ),
277:                   ),
278:                 ],
279:               ),
280:             ],
281:           ),
282:         ),
283:       ),
284:     );
285:   }
286:   // ─── BUILD ─────────────────────────────────────────────────────────────
287:   @override
288:   Widget build(BuildContext context) {
289:     final theme = Theme.of(context);
290:     final colorScheme = theme.colorScheme;
291:     final username = _userData['username'] ?? 'Unknown';
292:     final email = _userData['email'] ?? '';
293:     return Scaffold(
294:       backgroundColor: colorScheme.surface,
295:       appBar: AppBar(
296:         title: Text(
297:           username,
298:           style: theme.textTheme.titleLarge?.copyWith(
299:             fontWeight: FontWeight.w700,
300:           ),
301:         ),
302:         centerTitle: true,
303:         actions: [
304:           if (_friendStatus == FriendStatus.friends)
305:             PopupMenuButton<String>(
306:               icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface),
307:               shape: RoundedRectangleBorder(
308:                 borderRadius: BorderRadius.circular(14),
309:               ),
310:               onSelected: (value) {
311:                 if (value == 'remove') _showRemoveFriendDialog();
312:               },
313:               itemBuilder: (context) => [
314:                 PopupMenuItem<String>(
315:                   value: 'remove',
316:                   child: Row(
317:                     children: [
318:                       Icon(
319:                         Icons.person_remove_rounded,
320:                         color: colorScheme.error,
321:                         size: 20,
322:                       ),
323:                       const SizedBox(width: 12),
324:                       Text(
325:                         'Remove Friend',
326:                         style: TextStyle(color: colorScheme.error),
327:                       ),
328:                     ],
329:                   ),
330:                 ),
331:               ],
332:             ),
333:         ],
334:       ),
335:       body: SingleChildScrollView(
336:         physics: const BouncingScrollPhysics(),
337:         padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
338:         child: Column(
339:           children: [
340:             CircleAvatar(
341:               radius: 60,
342:               backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
343:               child: Text(
344:                 username.isNotEmpty ? username[0].toUpperCase() : '?',
345:                 style: TextStyle(
346:                   fontSize: 50,
347:                   fontWeight: FontWeight.bold,
348:                   color: colorScheme.primary,
349:                 ),
350:               ),
351:             ),
352:             const SizedBox(height: 16),
353:             Text(
354:               username,
355:               style: theme.textTheme.headlineSmall?.copyWith(
356:                 fontWeight: FontWeight.w800,
357:                 color: colorScheme.onSurface,
358:               ),
359:             ),
360:             const SizedBox(height: 4),
361:             Text(
362:               '@$username',
363:               style: theme.textTheme.bodyMedium?.copyWith(
364:                 color: colorScheme.onSurface.withValues(alpha: 0.5),
365:               ),
366:             ),
367:             const SizedBox(height: 28),
368:             _buildProfileActionButton(theme, colorScheme),
369:             const SizedBox(height: 32),
370:             Card(
371:               shape: RoundedRectangleBorder(
372:                 borderRadius: BorderRadius.circular(16),
373:               ),
374:               elevation: 4,
375:               child: Padding(
376:                 padding: const EdgeInsets.all(20),
377:                 child: Column(
378:                   children: [
379:                     _infoTile(Icons.person, 'Username', username, theme),
380:                     if (email.isNotEmpty) ...[
381:                       const Divider(),
382:                       _infoTile(Icons.email, 'Email', email, theme),
383:                     ],
384:                     const Divider(),
385:                     _infoTile(
386:                       Icons.info_outline_rounded,
387:                       'Status',
388:                       _friendStatusLabel(),
389:                       theme,
390:                     ),
391:                   ],
392:                 ),
393:               ),
394:             ),
395:           ],
396:         ),
397:       ),
398:     );
399:   }
400:   String _friendStatusLabel() {
401:     switch (_friendStatus) {
402:       case FriendStatus.friends:
403:         return 'Friends';
404:       case FriendStatus.requestSent:
405:         return 'Request Sent';
406:       case FriendStatus.requestReceived:
407:         return 'Request Received';
408:       case FriendStatus.none:
409:         return 'Not Connected';
410:       case FriendStatus.loading:
411:         return 'Checking...';
412:     }
413:   }
414:   Widget _buildProfileActionButton(ThemeData theme, ColorScheme colorScheme) {
415:     if (_friendStatus == FriendStatus.loading) {
416:       return SizedBox(
417:         width: 28,
418:         height: 28,
419:         child: CircularProgressIndicator(
420:           strokeWidth: 2.5,
421:           color: colorScheme.primary,
422:         ),
423:       );
424:     }
425:     IconData icon;
426:     String label;
427:     Color bgColor;
428:     Color fgColor;
429:     VoidCallback onTap;
430:     switch (_friendStatus) {
431:       case FriendStatus.none:
432:         icon = Icons.person_add_rounded;
433:         label = 'Add Friend';
434:         bgColor = colorScheme.primary;
435:         fgColor = colorScheme.onPrimary;
436:         onTap = _sendRequest;
437:         break;
438:       case FriendStatus.requestSent:
439:         icon = Icons.schedule_rounded;
440:         label = 'Requested';
441:         bgColor = colorScheme.onSurface.withValues(alpha: 0.1);
442:         fgColor = colorScheme.onSurface.withValues(alpha: 0.6);
443:         onTap = _showRevokeDialog;
444:         break;
445:       case FriendStatus.requestReceived:
446:         icon = Icons.check_circle_outline_rounded;
447:         label = 'Accept Request';
448:         bgColor = colorScheme.tertiary;
449:         fgColor = colorScheme.onTertiary;
450:         onTap = _acceptRequest;
451:         break;
452:       case FriendStatus.friends:
453:         icon = Icons.chat_bubble_rounded;
454:         label = 'Chat';
455:         bgColor = colorScheme.primary;
456:         fgColor = colorScheme.onPrimary;
457:         onTap = _openChat;
458:         break;
459:       default:
460:         return const SizedBox.shrink();
461:     }
462:     return GestureDetector(
463:       onTap: _actionInProgress ? null : onTap,
464:       child: AnimatedContainer(
465:         duration: const Duration(milliseconds: 300),
466:         curve: Curves.easeOutCubic,
467:         width: double.infinity,
468:         constraints: const BoxConstraints(maxWidth: 280),
469:         padding: const EdgeInsets.symmetric(vertical: 14),
470:         decoration: BoxDecoration(
471:           color: bgColor,
472:           borderRadius: BorderRadius.circular(16),
473:           boxShadow: [
474:             if (_friendStatus != FriendStatus.requestSent)
475:               BoxShadow(
476:                 color: bgColor.withValues(alpha: 0.35),
477:                 blurRadius: 16,
478:                 offset: const Offset(0, 6),
479:               ),
480:           ],
481:         ),
482:         child: _actionInProgress
483:             ? Center(
484:                 child: SizedBox(
485:                   width: 22,
486:                   height: 22,
487:                   child: CircularProgressIndicator(
488:                     strokeWidth: 2.5,
489:                     color: fgColor,
490:                   ),
491:                 ),
492:               )
493:             : Row(
494:                 mainAxisAlignment: MainAxisAlignment.center,
495:                 children: [
496:                   Icon(icon, color: fgColor, size: 20),
497:                   const SizedBox(width: 10),
498:                   Flexible(
499:                     child: Text(
500:                       label,
501:                       style: TextStyle(
502:                         color: fgColor,
503:                         fontWeight: FontWeight.w700,
504:                         fontSize: 15,
505:                       ),
506:                       maxLines: 1,
507:                       overflow: TextOverflow.ellipsis,
508:                     ),
509:                   ),
510:                 ],
511:               ),
512:       ),
513:     );
514:   }
515:   Widget _infoTile(IconData icon, String title, String value, ThemeData theme) {
516:     return Padding(
517:       padding: const EdgeInsets.symmetric(vertical: 8),
518:       child: Row(
519:         children: [
520:           Icon(icon, color: theme.colorScheme.primary),
521:           const SizedBox(width: 16),
522:           Expanded(
523:             child: Column(
524:               crossAxisAlignment: CrossAxisAlignment.start,
525:               children: [
526:                 Text(title, style: theme.textTheme.bodySmall),
527:                 const SizedBox(height: 4),
528:                 Text(
529:                   value,
530:                   style: theme.textTheme.bodyLarge?.copyWith(
531:                     fontWeight: FontWeight.w500,
532:                   ),
533:                 ),
534:               ],
535:             ),
536:           ),
537:         ],
538:       ),
539:     );
540:   }
541: }
````

## File: lib/services/chat_service.dart
````dart
 1: import 'package:cloud_firestore/cloud_firestore.dart';
 2: class ChatService {
 3:   static final ChatService _instance = ChatService._internal();
 4:   factory ChatService() => _instance;
 5:   ChatService._internal();
 6:   final FirebaseFirestore _db = FirebaseFirestore.instance;
 7:   /// Generates a deterministic chat ID for two users
 8:   /// Same logic as relationship canonical ID
 9:   String getChatId(String uid1, String uid2) {
10:     final sorted = [uid1, uid2]..sort();
11:     return '${sorted[0]}_${sorted[1]}';
12:   }
13:   /// Opens or creates a chat between two users
14:   /// Returns the chat ID
15:   Future<String> openChat({
16:     required String currentUid,
17:     required String friendUid,
18:   }) async {
19:     final chatId = getChatId(currentUid, friendUid);
20:     // Chat document will be created when first message is sent
21:     // No need to create it here
22:     return chatId;
23:   }
24:   /// Migration function to populate usernames in existing chats
25:   Future<void> migrateChats() async {
26:     final chats = await _db.collection('chats').get();
27:     for (var chat in chats.docs) {
28:       final data = chat.data();
29:       if (data.containsKey('participantUsernames')) continue;
30:       final participants = List<String>.from(data['participants'] ?? []);
31:       List<String> usernames = [];
32:       for (var uid in participants) {
33:         final userDoc = await _db.collection('users').doc(uid).get();
34:         if (userDoc.exists) {
35:           usernames.add(
36:             (userDoc['username'] as String? ?? 'Unknown').toLowerCase(),
37:           );
38:         } else {
39:           usernames.add('unknown');
40:         }
41:       }
42:       if (usernames.isNotEmpty) {
43:         await chat.reference.update({
44:           'participantUsernames': usernames,
45:         });
46:       }
47:     }
48:   }
49:   /// Update all chats containing a user when they change their username
50:   Future<void> updateUsernameEverywhere(
51:     String uid,
52:     String newUsername,
53:   ) async {
54:     final chats = await _db
55:         .collection('chats')
56:         .where('participants', arrayContains: uid)
57:         .get();
58:     for (var chat in chats.docs) {
59:       final data = chat.data();
60:       List<String> usernames = List<String>.from(data['participantUsernames'] ?? []);
61:       List<String> participants = List<String>.from(data['participants'] ?? []);
62:       final index = participants.indexOf(uid);
63:       if (index != -1) {
64:         // Ensure the list is long enough, though it should be if participants matches
65:         while (usernames.length <= index) {
66:           usernames.add('unknown');
67:         }
68:         usernames[index] = newUsername.toLowerCase();
69:         await chat.reference.update({
70:           'participantUsernames': usernames,
71:         });
72:       }
73:     }
74:   }
75: }
````

## File: pubspec.yaml
````yaml
 1: name: chat_app
 2: description: "A Flutter Project for chatting"
 3: # The following line prevents the package from being accidentally published to
 4: # pub.dev using `flutter pub publish`. This is preferred for private packages.
 5: publish_to: 'none' # Remove this line if you wish to publish to pub.dev
 6: # The following defines the version and build number for your application.
 7: # A version number is three numbers separated by dots, like 1.2.43
 8: # followed by an optional build number separated by a +.
 9: # Both the version and the builder number may be overridden in flutter
10: # build by specifying --build-name and --build-number, respectively.
11: # In Android, build-name is used as versionName while build-number used as versionCode.
12: # Read more about Android versioning at https://developer.android.com/studio/publish/versioning
13: # In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
14: # Read more about iOS versioning at
15: # https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
16: # In Windows, build-name is used as the major, minor, and patch parts
17: # of the product and file versions while build-number is used as the build suffix.
18: version: 1.0.0+1
19: environment:
20:   sdk: ^3.11.0
21: # Dependencies specify other packages that your package needs in order to work.
22: # To automatically upgrade your package dependencies to the latest versions
23: # consider running `flutter pub upgrade --major-versions`. Alternatively,
24: # dependencies can be manually updated by changing the version numbers below to
25: # the latest version available on pub.dev. To see which dependencies have newer
26: # versions available, run `flutter pub outdated`.
27: dependencies:
28:   flutter:
29:     sdk: flutter
30:   # The following adds the Cupertino Icons font to your application.
31:   # Use with the CupertinoIcons class for iOS style icons.
32:   cupertino_icons: ^1.0.8
33:   firebase_core: ^4.4.0
34:   firebase_auth: ^6.1.4
35:   cloud_firestore: ^6.1.2
36:   intl: ^0.18.0
37:   shared_preferences: ^2.2.2
38: dev_dependencies:
39:   flutter_test:
40:     sdk: flutter
41:   # The "flutter_lints" package below contains a set of recommended lints to
42:   # encourage good coding practices. The lint set provided by the package is
43:   # activated in the `analysis_options.yaml` file located at the root of your
44:   # package. See that file for information about deactivating specific lint
45:   # rules and activating additional ones.
46:   flutter_lints: ^6.0.0
47: # For information on the generic Dart part of this file, see the
48: # following page: https://dart.dev/tools/pub/pubspec
49: # The following section is specific to Flutter packages.
50: flutter:
51:   # The following line ensures that the Material Icons font is
52:   # included with your application, so that you can use the icons in
53:   # the material Icons class.
54:   uses-material-design: true
55:   # To add assets to your application, add an assets section, like this:
56:   # assets:
57:   #   - images/a_dot_burr.jpeg
58:   #   - images/a_dot_ham.jpeg
59:   # An image asset can refer to one or more resolution-specific "variants", see
60:   # https://flutter.dev/to/resolution-aware-images
61:   # For details regarding adding assets from package dependencies, see
62:   # https://flutter.dev/to/asset-from-package
63:   # To add custom fonts to your application, add a fonts section here,
64:   # in this "flutter" section. Each entry in this list should have a
65:   # "family" key with the font family name, and a "fonts" key with a
66:   # list giving the asset and other descriptors for the font. For
67:   # example:
68:   # fonts:
69:   #   - family: Schyler
70:   #     fonts:
71:   #       - asset: fonts/Schyler-Regular.ttf
72:   #       - asset: fonts/Schyler-Italic.ttf
73:   #         style: italic
74:   #   - family: Trajan Pro
75:   #     fonts:
76:   #       - asset: fonts/TrajanPro.ttf
77:   #       - asset: fonts/TrajanPro_Bold.ttf
78:   #         weight: 700
79:   #
80:   # For details regarding fonts from package dependencies,
81:   # see https://flutter.dev/to/font-from-package
````

## File: lib/screens/chat_screen.dart
````dart
  1: import 'package:flutter/material.dart';
  2: import 'package:cloud_firestore/cloud_firestore.dart';
  3: import 'package:firebase_auth/firebase_auth.dart';
  4: class ChatScreen extends StatefulWidget {
  5:   final String chatId;
  6:   final String friendUid;
  7:   final String friendUsername;
  8:   const ChatScreen({
  9:     super.key,
 10:     required this.chatId,
 11:     required this.friendUid,
 12:     required this.friendUsername,
 13:   });
 14:   @override
 15:   State<ChatScreen> createState() => _ChatScreenState();
 16: }
 17: class _ChatScreenState extends State<ChatScreen> {
 18:   final TextEditingController _messageController = TextEditingController();
 19:   final ScrollController _scrollController = ScrollController();
 20:   final _currentUser = FirebaseAuth.instance.currentUser;
 21:   bool _isSending = false;
 22:   @override
 23:   void dispose() {
 24:     _messageController.dispose();
 25:     _scrollController.dispose();
 26:     super.dispose();
 27:   }
 28:   Stream<DocumentSnapshot?> _friendshipStream() {
 29:     return FirebaseFirestore.instance
 30:         .collection('relationships')
 31:         .where('users', arrayContains: _currentUser!.uid)
 32:         .snapshots()
 33:         .map((snapshot) {
 34:           try {
 35:             return snapshot.docs.firstWhere((doc) {
 36:               final users = List<String>.from(doc['users']);
 37:               return users.contains(widget.friendUid);
 38:             });
 39:           } catch (e) {
 40:             return null;
 41:           }
 42:         });
 43:   }
 44:   // ─── SEND MESSAGE ─────────────────────────────────────────────────────
 45:   Future<void> _sendMessage() async {
 46:     final text = _messageController.text.trim();
 47:     if (text.isEmpty || _isSending || _currentUser == null) return;
 48:     // ✅ Double-check friendship BEFORE modifying UI
 49:     final relationshipQuery = await FirebaseFirestore.instance
 50:         .collection('relationships')
 51:         .where('users', arrayContains: _currentUser!.uid)
 52:         .get();
 53:     bool areFriends = false;
 54:     for (var doc in relationshipQuery.docs) {
 55:       final users = List<String>.from(doc['users']);
 56:       if (users.contains(widget.friendUid) && doc['type'] == 'friends') {
 57:         areFriends = true;
 58:         break;
 59:       }
 60:     }
 61:     if (!areFriends) {
 62:       ScaffoldMessenger.of(context).showSnackBar(
 63:         const SnackBar(content: Text("You are no longer friends")),
 64:       );
 65:       return;
 66:     }
 67:     // ✅ NOW start sending state
 68:     setState(() => _isSending = true);
 69:     _messageController.clear();
 70:     try {
 71:       final now = FieldValue.serverTimestamp();
 72:       final chatRef = FirebaseFirestore.instance
 73:           .collection('chats')
 74:           .doc(widget.chatId);
 75:       final chatDoc = await chatRef.get();
 76:       if (!chatDoc.exists) {
 77:         // Fetch both users' usernames to store in chat metadata for search
 78:         final usersRef = FirebaseFirestore.instance.collection('users');
 79:         final currentUserDoc = await usersRef.doc(_currentUser!.uid).get();
 80:         final friendDoc = await usersRef.doc(widget.friendUid).get();
 81:         final currentUsername = currentUserDoc['username'] as String? ?? 'Unknown';
 82:         final friendUsername = friendDoc['username'] as String? ?? widget.friendUsername;
 83:         await chatRef.set({
 84:           'participants': [_currentUser!.uid, widget.friendUid],
 85:           'participantUsernames': [
 86:             currentUsername.toLowerCase(),
 87:             friendUsername.toLowerCase(),
 88:           ],
 89:           'lastMessage': text,
 90:           'lastMessageTime': now,
 91:           'lastMessageSender': _currentUser!.uid,
 92:           'createdAt': now,
 93:         });
 94:       } else {
 95:         await chatRef.update({
 96:           'lastMessage': text,
 97:           'lastMessageTime': now,
 98:           'lastMessageSender': _currentUser!.uid,
 99:         });
100:       }
101:       await chatRef.collection('messages').add({
102:         'text': text,
103:         'senderId': _currentUser!.uid,
104:         'timestamp': now,
105:       });
106:       _scrollToBottom();
107:     } catch (e) {
108:       if (mounted) {
109:         ScaffoldMessenger.of(context).showSnackBar(
110:           const SnackBar(content: Text('Failed to send message.')),
111:         );
112:       }
113:     } finally {
114:       if (mounted) setState(() => _isSending = false);
115:     }
116:   }
117:   void _scrollToBottom() {
118:     Future.delayed(const Duration(milliseconds: 100), () {
119:       if (_scrollController.hasClients) {
120:         _scrollController.animateTo(
121:           0,
122:           duration: const Duration(milliseconds: 300),
123:           curve: Curves.easeOut,
124:         );
125:       }
126:     });
127:   }
128:   // ─── BUILD ─────────────────────────────────────────────────────────────
129:   @override
130:   Widget build(BuildContext context) {
131:     final theme = Theme.of(context);
132:     final cs = theme.colorScheme;
133:     return Scaffold(
134:       backgroundColor: cs.surface,
135:       appBar: AppBar(
136:         titleSpacing: 0,
137:         title: Row(
138:           children: [
139:             CircleAvatar(
140:               radius: 18,
141:               backgroundColor: cs.primary.withValues(alpha: 0.15),
142:               child: Text(
143:                 widget.friendUsername.isNotEmpty
144:                     ? widget.friendUsername[0].toUpperCase()
145:                     : '?',
146:                 style: TextStyle(
147:                   fontWeight: FontWeight.bold,
148:                   color: cs.primary,
149:                   fontSize: 16,
150:                 ),
151:               ),
152:             ),
153:             const SizedBox(width: 12),
154:             Expanded(
155:               child: Text(
156:                 widget.friendUsername,
157:                 style: theme.textTheme.titleMedium?.copyWith(
158:                   fontWeight: FontWeight.w700,
159:                 ),
160:                 maxLines: 1,
161:                 overflow: TextOverflow.ellipsis,
162:               ),
163:             ),
164:           ],
165:         ),
166:       ),
167:       body: StreamBuilder<DocumentSnapshot?>(
168:         stream: _friendshipStream(),
169:         builder: (context, snapshot) {
170:           if (snapshot.connectionState == ConnectionState.waiting) {
171:             return const Center(child: CircularProgressIndicator());
172:           }
173:           final relationshipDoc = snapshot.data;
174:           bool areFriends = false;
175:           if (relationshipDoc != null && relationshipDoc.exists) {
176:             final data = relationshipDoc.data() as Map<String, dynamic>?;
177:             final type = data?['type'];
178:             areFriends = type == 'friends';
179:           }
180:           return Column(
181:             children: [
182:               Expanded(child: _buildMessagesList(cs)),
183:               _buildInputBar(theme, cs, areFriends),
184:             ],
185:           );
186:         },
187:       ),
188:     );
189:   }
190:   // ─── MESSAGES LIST ────────────────────────────────────────────────────
191:   Widget _buildMessagesList(ColorScheme cs) {
192:     return StreamBuilder<QuerySnapshot>(
193:       stream: FirebaseFirestore.instance
194:           .collection('chats')
195:           .doc(widget.chatId)
196:           .collection('messages')
197:           .orderBy('timestamp', descending: true)
198:           .snapshots(),
199:       builder: (context, snapshot) {
200:         if (snapshot.connectionState == ConnectionState.waiting) {
201:           return const Center(child: CircularProgressIndicator());
202:         }
203:         final messages = snapshot.data?.docs ?? [];
204:         if (messages.isEmpty) {
205:           return Center(
206:             child: Column(
207:               mainAxisSize: MainAxisSize.min,
208:               children: [
209:                 Icon(
210:                   Icons.chat_bubble_outline_rounded,
211:                   size: 64,
212:                   color: cs.onSurface.withValues(alpha: 0.15),
213:                 ),
214:                 const SizedBox(height: 16),
215:                 Text(
216:                   'No messages yet',
217:                   style: TextStyle(
218:                     color: cs.onSurface.withValues(alpha: 0.5),
219:                     fontSize: 16,
220:                   ),
221:                 ),
222:                 const SizedBox(height: 8),
223:                 Text(
224:                   'Say hello! 👋',
225:                   style: TextStyle(
226:                     color: cs.onSurface.withValues(alpha: 0.3),
227:                     fontSize: 14,
228:                   ),
229:                 ),
230:               ],
231:             ),
232:           );
233:         }
234:         return ListView.builder(
235:           controller: _scrollController,
236:           reverse: true,
237:           padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
238:           physics: const BouncingScrollPhysics(),
239:           itemCount: messages.length,
240:           itemBuilder: (context, index) {
241:             final data = messages[index].data() as Map<String, dynamic>;
242:             final isMe = data['senderId'] == _currentUser?.uid;
243:             final text = data['text'] ?? '';
244:             final timestamp = data['timestamp'] as Timestamp?;
245:             // Check if we should show date separator
246:             bool showDate = false;
247:             if (index == messages.length - 1) {
248:               showDate = true;
249:             } else {
250:               final nextData =
251:                   messages[index + 1].data() as Map<String, dynamic>;
252:               final nextTimestamp = nextData['timestamp'] as Timestamp?;
253:               if (timestamp != null && nextTimestamp != null) {
254:                 final current = timestamp.toDate();
255:                 final next = nextTimestamp.toDate();
256:                 if (current.day != next.day ||
257:                     current.month != next.month ||
258:                     current.year != next.year) {
259:                   showDate = true;
260:                 }
261:               }
262:             }
263:             return Column(
264:               children: [
265:                 if (showDate && timestamp != null)
266:                   _buildDateSeparator(timestamp, Theme.of(context).colorScheme),
267:                 _MessageBubble(text: text, isMe: isMe, timestamp: timestamp),
268:               ],
269:             );
270:           },
271:         );
272:       },
273:     );
274:   }
275:   Widget _buildDateSeparator(Timestamp timestamp, ColorScheme cs) {
276:     final date = timestamp.toDate();
277:     final now = DateTime.now();
278:     String label;
279:     if (date.year == now.year &&
280:         date.month == now.month &&
281:         date.day == now.day) {
282:       label = 'Today';
283:     } else if (date.year == now.year &&
284:         date.month == now.month &&
285:         date.day == now.day - 1) {
286:       label = 'Yesterday';
287:     } else {
288:       label = '${date.day}/${date.month}/${date.year}';
289:     }
290:     return Padding(
291:       padding: const EdgeInsets.symmetric(vertical: 16),
292:       child: Container(
293:         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
294:         decoration: BoxDecoration(
295:           color: cs.onSurface.withValues(alpha: 0.06),
296:           borderRadius: BorderRadius.circular(12),
297:         ),
298:         child: Text(
299:           label,
300:           style: TextStyle(
301:             fontSize: 12,
302:             color: cs.onSurface.withValues(alpha: 0.45),
303:             fontWeight: FontWeight.w500,
304:           ),
305:         ),
306:       ),
307:     );
308:   }
309:   // ─── INPUT BAR ────────────────────────────────────────────────────────
310:   Widget _buildInputBar(ThemeData theme, ColorScheme cs, bool areFriends) {
311:     if (!areFriends) {
312:       return Container(
313:         padding: EdgeInsets.fromLTRB(
314:           16,
315:           14,
316:           16,
317:           MediaQuery.of(context).padding.bottom + 14,
318:         ),
319:         decoration: BoxDecoration(
320:           color: cs.surface,
321:           border: Border(
322:             top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
323:           ),
324:         ),
325:         child: Center(
326:           child: Text(
327:             "You are no longer friends",
328:             style: TextStyle(color: cs.error, fontWeight: FontWeight.w600),
329:           ),
330:         ),
331:       );
332:     }
333:     // ✅ Normal input bar if friends
334:     return Container(
335:       padding: EdgeInsets.fromLTRB(
336:         16,
337:         10,
338:         16,
339:         MediaQuery.of(context).padding.bottom + 10,
340:       ),
341:       decoration: BoxDecoration(
342:         color: cs.surface,
343:         border: Border(
344:           top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
345:         ),
346:       ),
347:       child: Row(
348:         children: [
349:           Expanded(
350:             child: Container(
351:               decoration: BoxDecoration(
352:                 color: cs.onSurface.withValues(alpha: 0.06),
353:                 borderRadius: BorderRadius.circular(24),
354:               ),
355:               child: TextField(
356:                 controller: _messageController,
357:                 enabled: areFriends,
358:                 decoration: const InputDecoration(
359:                   hintText: 'Type a message...',
360:                   border: InputBorder.none,
361:                   contentPadding: EdgeInsets.symmetric(
362:                     horizontal: 18,
363:                     vertical: 12,
364:                   ),
365:                 ),
366:                 onSubmitted: (_) => _sendMessage(),
367:               ),
368:             ),
369:           ),
370:           const SizedBox(width: 8),
371:           GestureDetector(
372:             onTap: areFriends ? _sendMessage : null,
373:             child: Container(
374:               width: 46,
375:               height: 46,
376:               decoration: BoxDecoration(
377:                 color: cs.primary,
378:                 shape: BoxShape.circle,
379:               ),
380:               child: Icon(Icons.send_rounded, color: cs.onPrimary, size: 20),
381:             ),
382:           ),
383:         ],
384:       ),
385:     );
386:   }
387: }
388: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
389: // MESSAGE BUBBLE
390: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
391: class _MessageBubble extends StatelessWidget {
392:   final String text;
393:   final bool isMe;
394:   final Timestamp? timestamp;
395:   const _MessageBubble({
396:     required this.text,
397:     required this.isMe,
398:     this.timestamp,
399:   });
400:   @override
401:   Widget build(BuildContext context) {
402:     final cs = Theme.of(context).colorScheme;
403:     return Align(
404:       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
405:       child: Container(
406:         constraints: BoxConstraints(
407:           maxWidth: MediaQuery.of(context).size.width * 0.75,
408:         ),
409:         margin: const EdgeInsets.symmetric(vertical: 3),
410:         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
411:         decoration: BoxDecoration(
412:           color: isMe ? cs.primary : cs.onSurface.withValues(alpha: 0.08),
413:           borderRadius: BorderRadius.only(
414:             topLeft: const Radius.circular(18),
415:             topRight: const Radius.circular(18),
416:             bottomLeft: Radius.circular(isMe ? 18 : 4),
417:             bottomRight: Radius.circular(isMe ? 4 : 18),
418:           ),
419:         ),
420:         child: Column(
421:           crossAxisAlignment: isMe
422:               ? CrossAxisAlignment.end
423:               : CrossAxisAlignment.start,
424:           children: [
425:             Text(
426:               text,
427:               style: TextStyle(
428:                 color: isMe ? cs.onPrimary : cs.onSurface,
429:                 fontSize: 15,
430:                 height: 1.4,
431:               ),
432:             ),
433:             if (timestamp != null) ...[
434:               const SizedBox(height: 4),
435:               Text(
436:                 _formatTime(timestamp!),
437:                 style: TextStyle(
438:                   color: isMe
439:                       ? cs.onPrimary.withValues(alpha: 0.6)
440:                       : cs.onSurface.withValues(alpha: 0.35),
441:                   fontSize: 11,
442:                 ),
443:               ),
444:             ],
445:           ],
446:         ),
447:       ),
448:     );
449:   }
450:   String _formatTime(Timestamp timestamp) {
451:     final date = timestamp.toDate();
452:     final hour = date.hour.toString().padLeft(2, '0');
453:     final minute = date.minute.toString().padLeft(2, '0');
454:     return '$hour:$minute';
455:   }
456: }
````

## File: lib/screens/login_screen.dart
````dart
 1: import 'package:flutter/material.dart';
 2: import 'package:firebase_auth/firebase_auth.dart';
 3: import 'package:flutter/widget_previews.dart';
 4: import 'register_screen.dart';
 5: @Preview(name: 'My Login Page')
 6: Widget previewLoginScreen() {
 7:   return const MaterialApp(home: LoginScreen());
 8: }
 9: class LoginScreen extends StatefulWidget {
10:   const LoginScreen({super.key});
11:   @override
12:   State<LoginScreen> createState() => _LoginScreenState();
13: }
14: class _LoginScreenState extends State<LoginScreen> {
15:   final emailController = TextEditingController();
16:   final passwordController = TextEditingController();
17:   bool _isLoading = false;
18:   Future<void> login() async {
19:     if (_isLoading) return;
20:     setState(() {
21:       _isLoading = true;
22:     });
23:     try {
24:       await FirebaseAuth.instance.signInWithEmailAndPassword(
25:         email: emailController.text.trim(),
26:         password: passwordController.text.trim(),
27:       );
28:     } on FirebaseAuthException catch (e) {
29:       if (!mounted) return;
30:       String message = "Login failed";
31:       if (e.code == 'user-not-found') {
32:         message = "No user found with this email.";
33:       } else if (e.code == 'wrong-password') {
34:         message = "Incorrect password.";
35:       } else if (e.code == 'invalid-email') {
36:         message = "Invalid email format.";
37:       }
38:       ScaffoldMessenger.of(
39:         context,
40:       ).showSnackBar(SnackBar(content: Text(message)));
41:     } catch (e) {
42:       if (!mounted) return;
43:       ScaffoldMessenger.of(
44:         context,
45:       ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
46:     } finally {
47:       if (mounted) {
48:         setState(() {
49:           _isLoading = false;
50:         });
51:       }
52:     }
53:   }
54:   @override
55:   Widget build(BuildContext context) {
56:     return Scaffold(
57:       appBar: AppBar(title: const Text("Login")),
58:       body: Padding(
59:         padding: const EdgeInsets.all(16),
60:         child: Column(
61:           children: [
62:             TextField(
63:               controller: emailController,
64:               decoration: const InputDecoration(labelText: "Email"),
65:             ),
66:             TextField(
67:               controller: passwordController,
68:               decoration: const InputDecoration(labelText: "Password"),
69:               obscureText: true,
70:             ),
71:             const SizedBox(height: 20),
72:             ElevatedButton(
73:               onPressed: _isLoading ? null : login,
74:               child: _isLoading
75:                   ? const SizedBox(
76:                       height: 20,
77:                       width: 20,
78:                       child: CircularProgressIndicator(
79:                         strokeWidth: 2,
80:                         color: Colors.white,
81:                       ),
82:                     )
83:                   : const Text("Login"),
84:             ),
85:             TextButton(
86:               onPressed: () {
87:                 Navigator.push(
88:                   context,
89:                   MaterialPageRoute(builder: (_) => const RegisterScreen()),
90:                 );
91:               },
92:               child: const Text("Create Account"),
93:             ),
94:           ],
95:         ),
96:       ),
97:     );
98:   }
99: }
````

## File: lib/screens/register_screen.dart
````dart
  1: import 'package:flutter/material.dart';
  2: import 'package:firebase_auth/firebase_auth.dart';
  3: import 'package:cloud_firestore/cloud_firestore.dart';
  4: class RegisterScreen extends StatefulWidget {
  5:   const RegisterScreen({super.key});
  6:   @override
  7:   State<RegisterScreen> createState() => _RegisterScreenState();
  8: }
  9: class _RegisterScreenState extends State<RegisterScreen> {
 10:   final emailController = TextEditingController();
 11:   final passwordController = TextEditingController();
 12:   bool _isLoading = false;
 13:   Future<void> register() async {
 14:     if (_isLoading) return;
 15:     setState(() => _isLoading = true);
 16:     try {
 17:       String email = emailController.text.trim();
 18:       String password = passwordController.text.trim();
 19:       if (email.isEmpty || password.isEmpty) {
 20:         throw FirebaseAuthException(
 21:           code: "empty-fields",
 22:           message: "All fields are required.",
 23:         );
 24:       }
 25:       UserCredential userCredential = await FirebaseAuth.instance
 26:           .createUserWithEmailAndPassword(email: email, password: password);
 27:       String uid = userCredential.user!.uid;
 28:       // 🔥 Generate Safe & Unique Username
 29:       String username = await generateUniqueUsername(email);
 30:       WriteBatch batch = FirebaseFirestore.instance.batch();
 31:       DocumentReference userRef = FirebaseFirestore.instance
 32:           .collection('users')
 33:           .doc(uid);
 34:       DocumentReference usernameRef = FirebaseFirestore.instance
 35:           .collection('usernames')
 36:           .doc(username);
 37:       batch.set(userRef, {
 38:         'uid': uid,
 39:         'email': email,
 40:         'username': username,
 41:         'createdAt': FieldValue.serverTimestamp(),
 42:       });
 43:       batch.set(usernameRef, {'uid': uid});
 44:       await batch.commit();
 45:       if (!mounted) return;
 46:       Navigator.pop(context);
 47:     } on FirebaseAuthException catch (e) {
 48:       if (!mounted) return;
 49:       String message = "Registration failed";
 50:       if (e.code == 'email-already-in-use') {
 51:         message = "This email is already registered.";
 52:       } else if (e.code == 'invalid-email') {
 53:         message = "Invalid email format.";
 54:       } else if (e.code == 'weak-password') {
 55:         message = "Password should be at least 6 characters.";
 56:       } else if (e.code == 'empty-fields') {
 57:         message = "All fields are required.";
 58:       }
 59:       ScaffoldMessenger.of(
 60:         context,
 61:       ).showSnackBar(SnackBar(content: Text(message)));
 62:     } catch (e) {
 63:       if (!mounted) return;
 64:       ScaffoldMessenger.of(
 65:         context,
 66:       ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
 67:     } finally {
 68:       if (mounted) {
 69:         setState(() => _isLoading = false);
 70:       }
 71:     }
 72:   }
 73:   // 🔥 Generate Unique Username
 74:   Future<String> generateUniqueUsername(String email) async {
 75:     String baseUsername = email.split('@')[0].toLowerCase();
 76:     // Allow only a-z, 0-9, . and %
 77:     baseUsername = baseUsername.replaceAll(RegExp(r'[^a-z0-9.%]'), '');
 78:     // Ensure minimum 6 characters
 79:     if (baseUsername.length < 6) {
 80:       baseUsername = baseUsername.padRight(6, '0');
 81:     }
 82:     String username = baseUsername;
 83:     int counter = 1;
 84:     while (true) {
 85:       DocumentSnapshot doc = await FirebaseFirestore.instance
 86:           .collection('usernames')
 87:           .doc(username)
 88:           .get();
 89:       if (!doc.exists) {
 90:         return username;
 91:       }
 92:       username = "$baseUsername$counter";
 93:       counter++;
 94:     }
 95:   }
 96:   @override
 97:   Widget build(BuildContext context) {
 98:     return Scaffold(
 99:       appBar: AppBar(title: const Text("Register")),
100:       body: Padding(
101:         padding: const EdgeInsets.all(16),
102:         child: Column(
103:           children: [
104:             TextField(
105:               controller: emailController,
106:               decoration: const InputDecoration(labelText: "Email"),
107:             ),
108:             TextField(
109:               controller: passwordController,
110:               decoration: const InputDecoration(labelText: "Password"),
111:               obscureText: true,
112:             ),
113:             const SizedBox(height: 20),
114:             ElevatedButton(
115:               onPressed: _isLoading ? null : register,
116:               child: _isLoading
117:                   ? const SizedBox(
118:                       height: 20,
119:                       width: 20,
120:                       child: CircularProgressIndicator(
121:                         strokeWidth: 2,
122:                         color: Colors.white,
123:                       ),
124:                     )
125:                   : const Text("Register"),
126:             ),
127:           ],
128:         ),
129:       ),
130:     );
131:   }
132: }
````

## File: lib/widgets/empty_chat_state.dart
````dart
  1: import 'dart:math' as math;
  2: import 'package:flutter/material.dart';
  3: class EmptyChatState extends StatefulWidget {
  4:   const EmptyChatState({super.key});
  5:   @override
  6:   State<EmptyChatState> createState() => _EmptyChatStateState();
  7: }
  8: class _EmptyChatStateState extends State<EmptyChatState>
  9:     with TickerProviderStateMixin {
 10:   late AnimationController floatingController;
 11:   late AnimationController pulseController;
 12:   @override
 13:   void initState() {
 14:     super.initState();
 15:     floatingController = AnimationController(
 16:       vsync: this,
 17:       duration: const Duration(seconds: 3),
 18:     )..repeat(reverse: true);
 19:     pulseController = AnimationController(
 20:       vsync: this,
 21:       duration: const Duration(seconds: 2),
 22:     )..repeat(reverse: true);
 23:   }
 24:   @override
 25:   void dispose() {
 26:     floatingController.dispose();
 27:     pulseController.dispose();
 28:     super.dispose();
 29:   }
 30:   @override
 31:   Widget build(BuildContext context) {
 32:     return SingleChildScrollView(
 33:       physics: const BouncingScrollPhysics(),
 34:       padding: const EdgeInsets.only(bottom: 120),
 35:       child: Column(
 36:         children: [
 37:           const SizedBox(height: 20),
 38:           _illustration(),
 39:           const SizedBox(height: 10),
 40:           _title(),
 41:           const SizedBox(height: 14),
 42:           _subtitle(),
 43:           const SizedBox(height: 36),
 44:           _buttons(),
 45:           const SizedBox(height: 30),
 46:           _tipCard(),
 47:         ],
 48:       ),
 49:     );
 50:   }
 51:   Widget _illustration() {
 52:     return SizedBox(
 53:       height: 300,
 54:       child: Stack(
 55:         alignment: Alignment.center,
 56:         children: [
 57:           AnimatedBuilder(
 58:             animation: pulseController,
 59:             builder: (_, _) {
 60:               final pulse = 0.3 + pulseController.value * 0.15;
 61:               return Container(
 62:                 width: 200,
 63:                 height: 200,
 64:                 decoration: BoxDecoration(
 65:                   shape: BoxShape.circle,
 66:                   gradient: RadialGradient(
 67:                     colors: [
 68:                       const Color(0xFF7F00FF).withValues(alpha: pulse),
 69:                       const Color(0xFFE100FF).withValues(alpha: pulse * 0.5),
 70:                       Colors.transparent,
 71:                     ],
 72:                   ),
 73:                 ),
 74:               );
 75:             },
 76:           ),
 77:           ..._floatingBubbles(),
 78:           AnimatedBuilder(
 79:             animation: floatingController,
 80:             builder: (_, child) {
 81:               final offset = 8.0 * floatingController.value;
 82:               return Transform.translate(
 83:                 offset: Offset(0, -offset),
 84:                 child: child,
 85:               );
 86:             },
 87:             child: _mainCircle(),
 88:           ),
 89:         ],
 90:       ),
 91:     );
 92:   }
 93:   List<Widget> _floatingBubbles() {
 94:     final bubbles = [
 95:       _BubbleData(
 96:         const Offset(-90, -80),
 97:         40,
 98:         const Color(0xFF7F00FF),
 99:         Icons.chat_bubble,
100:       ),
101:       _BubbleData(
102:         const Offset(85, -60),
103:         35,
104:         const Color(0xFFE100FF),
105:         Icons.favorite,
106:       ),
107:       _BubbleData(
108:         const Offset(-70, 70),
109:         30,
110:         const Color(0xFF4ECDC4),
111:         Icons.emoji_emotions,
112:       ),
113:     ];
114:     return bubbles.map((b) {
115:       return AnimatedBuilder(
116:         animation: floatingController,
117:         builder: (_, _) {
118:           final float = math.sin(floatingController.value * math.pi) * 6;
119:           return Transform.translate(
120:             offset: b.offset + Offset(0, float),
121:             child: Container(
122:               width: b.size,
123:               height: b.size,
124:               decoration: BoxDecoration(
125:                 color: b.color.withValues(alpha: 0.15),
126:                 shape: BoxShape.circle,
127:               ),
128:               child: Icon(b.icon, color: b.color, size: b.size * 0.5),
129:             ),
130:           );
131:         },
132:       );
133:     }).toList();
134:   }
135:   Widget _mainCircle() {
136:     return Container(
137:       width: 140,
138:       height: 140,
139:       decoration: BoxDecoration(
140:         shape: BoxShape.circle,
141:         gradient: LinearGradient(
142:           colors: [
143:             Theme.of(context).colorScheme.surface,
144:             Theme.of(context).colorScheme.surfaceContainerHighest,
145:           ],
146:         ),
147:         border: Border.all(
148:           color: Theme.of(
149:             context,
150:           ).colorScheme.onSurface.withValues(alpha: 0.08),
151:           width: 2,
152:         ),
153:       ),
154:       child: Icon(
155:         Icons.forum_rounded,
156:         color: Theme.of(context).colorScheme.onSurface,
157:         size: 52,
158:       ),
159:     );
160:   }
161:   Widget _title() {
162:     return Text(
163:       'No Conversations Yet',
164:       style: TextStyle(
165:         fontSize: 26,
166:         fontWeight: FontWeight.w800,
167:         color: Theme.of(context).colorScheme.onSurface,
168:       ),
169:     );
170:   }
171:   Widget _subtitle() {
172:     return Padding(
173:       padding: const EdgeInsets.symmetric(horizontal: 50),
174:       child: Text(
175:         'Your inbox is waiting for its first message.\nConnect with friends and start chatting!',
176:         textAlign: TextAlign.center,
177:         style: TextStyle(
178:           color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
179:           height: 1.6,
180:         ),
181:       ),
182:     );
183:   }
184:   Widget _buttons() {
185:     return Padding(
186:       padding: const EdgeInsets.symmetric(horizontal: 40),
187:       child: Column(
188:         children: [
189:           _primaryButton(Icons.person_add, 'Find Friends'),
190:           const SizedBox(height: 14),
191:           _secondaryButton(Icons.group_add, 'Create Group'),
192:           const SizedBox(height: 14),
193:           _secondaryButton(Icons.qr_code, 'Scan QR'),
194:         ],
195:       ),
196:     );
197:   }
198:   Widget _primaryButton(IconData icon, String text) {
199:     return Container(
200:       height: 56,
201:       width: double.infinity,
202:       decoration: BoxDecoration(
203:         gradient: const LinearGradient(
204:           colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
205:         ),
206:         borderRadius: BorderRadius.circular(18),
207:       ),
208:       child: Row(
209:         mainAxisAlignment: MainAxisAlignment.center,
210:         children: [
211:           Icon(icon, color: Colors.white),
212:           const SizedBox(width: 10),
213:           Text(
214:             text,
215:             style: const TextStyle(
216:               color: Colors.white,
217:               fontWeight: FontWeight.w700,
218:             ),
219:           ),
220:         ],
221:       ),
222:     );
223:   }
224:   Widget _secondaryButton(IconData icon, String text) {
225:     return Container(
226:       height: 52,
227:       width: double.infinity,
228:       decoration: BoxDecoration(
229:         color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
230:         borderRadius: BorderRadius.circular(16),
231:       ),
232:       child: Row(
233:         mainAxisAlignment: MainAxisAlignment.center,
234:         children: [
235:           Icon(
236:             icon,
237:             color: Theme.of(
238:               context,
239:             ).colorScheme.onSurface.withValues(alpha: 0.6),
240:           ),
241:           const SizedBox(width: 10),
242:           Text(
243:             text,
244:             style: TextStyle(
245:               color: Theme.of(
246:                 context,
247:               ).colorScheme.onSurface.withValues(alpha: 0.7),
248:             ),
249:           ),
250:         ],
251:       ),
252:     );
253:   }
254:   Widget _tipCard() {
255:     return Container(
256:       margin: const EdgeInsets.symmetric(horizontal: 30),
257:       padding: const EdgeInsets.all(18),
258:       decoration: BoxDecoration(
259:         borderRadius: BorderRadius.circular(20),
260:         color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
261:       ),
262:       child: Text(
263:         "💡 Share your profile link to connect instantly!",
264:         style: TextStyle(
265:           color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
266:         ),
267:       ),
268:     );
269:   }
270: }
271: class _BubbleData {
272:   final Offset offset;
273:   final double size;
274:   final Color color;
275:   final IconData icon;
276:   _BubbleData(this.offset, this.size, this.color, this.icon);
277: }
````

## File: lib/widgets/glass_bottom_nav.dart
````dart
  1: import 'dart:ui';
  2: import 'package:flutter/material.dart';
  3: class GlassBottomNavBar extends StatelessWidget {
  4:   final int currentIndex;
  5:   final Function(int) onTap;
  6:   const GlassBottomNavBar({
  7:     super.key,
  8:     required this.currentIndex,
  9:     required this.onTap,
 10:   });
 11:   @override
 12:   Widget build(BuildContext context) {
 13:     final items = [
 14:       _NavItemData(Icons.chat_bubble_rounded, 'Chats'),
 15:       _NavItemData(Icons.group_rounded, 'Friends'),
 16:       _NavItemData(Icons.search_rounded, 'Search'),
 17:       _NavItemData(Icons.person_rounded, 'Profile'),
 18:     ];
 19:     return Padding(
 20:       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
 21:       child: ClipRRect(
 22:         borderRadius: BorderRadius.circular(40),
 23:         child: BackdropFilter(
 24:           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
 25:           child: Container(
 26:             height: 62,
 27:             decoration: BoxDecoration(
 28:               color: Theme.of(
 29:                 context,
 30:               ).colorScheme.surface.withValues(alpha: 0.9),
 31:               borderRadius: BorderRadius.circular(40),
 32:               border: Border.all(
 33:                 color: Theme.of(
 34:                   context,
 35:                 ).colorScheme.onSurface.withValues(alpha: 0.06),
 36:               ),
 37:               boxShadow: [
 38:                 BoxShadow(
 39:                   color: Theme.of(
 40:                     context,
 41:                   ).colorScheme.shadow.withValues(alpha: 0.3),
 42:                   blurRadius: 20,
 43:                   offset: const Offset(0, 5),
 44:                 ),
 45:               ],
 46:             ),
 47:             child: LayoutBuilder(
 48:               builder: (context, constraints) {
 49:                 final itemWidth = constraints.maxWidth / items.length;
 50:                 return Stack(
 51:                   children: [
 52:                     AnimatedPositioned(
 53:                       duration: const Duration(milliseconds: 350),
 54:                       curve: Curves.easeInOutCubic,
 55:                       left: currentIndex * itemWidth,
 56:                       top: 0,
 57:                       bottom: 0,
 58:                       child: SizedBox(
 59:                         width: itemWidth,
 60:                         child: Center(
 61:                           child: Container(
 62:                             width: 44,
 63:                             height: 44,
 64:                             decoration: const BoxDecoration(
 65:                               shape: BoxShape.circle,
 66:                               gradient: LinearGradient(
 67:                                 colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
 68:                               ),
 69:                             ),
 70:                           ),
 71:                         ),
 72:                       ),
 73:                     ),
 74:                     Row(
 75:                       children: List.generate(items.length, (index) {
 76:                         final isActive = currentIndex == index;
 77:                         return Expanded(
 78:                           child: GestureDetector(
 79:                             behavior: HitTestBehavior.opaque,
 80:                             onTap: () => onTap(index),
 81:                             child: Column(
 82:                               mainAxisAlignment: MainAxisAlignment.center,
 83:                               children: [
 84:                                 AnimatedScale(
 85:                                   duration: const Duration(milliseconds: 250),
 86:                                   scale: isActive ? 1.1 : 1.0,
 87:                                   child: Icon(
 88:                                     items[index].icon,
 89:                                     size: 21,
 90:                                     color: isActive
 91:                                         ? Colors.white
 92:                                         : Theme.of(context)
 93:                                               .colorScheme
 94:                                               .onSurface
 95:                                               .withValues(alpha: 0.38),
 96:                                   ),
 97:                                 ),
 98:                                 if (!isActive) ...[
 99:                                   const SizedBox(height: 2),
100:                                   Text(
101:                                     items[index].label,
102:                                     style: TextStyle(
103:                                       fontSize: 9,
104:                                       color: Theme.of(context)
105:                                           .colorScheme
106:                                           .onSurface
107:                                           .withValues(alpha: 0.25),
108:                                     ),
109:                                   ),
110:                                 ],
111:                               ],
112:                             ),
113:                           ),
114:                         );
115:                       }),
116:                     ),
117:                   ],
118:                 );
119:               },
120:             ),
121:           ),
122:         ),
123:       ),
124:     );
125:   }
126: }
127: class _NavItemData {
128:   final IconData icon;
129:   final String label;
130:   _NavItemData(this.icon, this.label);
131: }
````

## File: lib/screens/friends_screen.dart
````dart
  1: import 'package:flutter/material.dart';
  2: import 'package:chat_app/services/friend_service.dart';
  3: import 'package:chat_app/services/chat_service.dart';
  4: import 'package:chat_app/screens/friend_requests_screen.dart';
  5: import 'package:chat_app/screens/chat_screen.dart';
  6: import 'package:chat_app/screens/user_profile_view.dart';
  7: import 'package:firebase_auth/firebase_auth.dart';
  8: import 'package:cloud_firestore/cloud_firestore.dart';
  9: class FriendsScreen extends StatelessWidget {
 10:   FriendsScreen({super.key});
 11:   final FriendService _friendService = FriendService();
 12:   final ChatService _chatService = ChatService();
 13:   final User? _currentUser = FirebaseAuth.instance.currentUser;
 14:   @override
 15:   Widget build(BuildContext context) {
 16:     final colorScheme = Theme.of(context).colorScheme;
 17:     if (_currentUser == null) {
 18:       return const Center(child: Text("No user"));
 19:     }
 20:     return Scaffold(
 21:       backgroundColor: colorScheme.surface,
 22:       body: SafeArea(
 23:         bottom: false,
 24:         child: Column(
 25:           children: [
 26:             _pendingRequestsButton(context),
 27:             const SizedBox(height: 6),
 28:             Expanded(child: _friendsList(context)),
 29:           ],
 30:         ),
 31:       ),
 32:     );
 33:   }
 34:   // ───────────────── Pending Requests Button ─────────────────
 35:   Widget _pendingRequestsButton(BuildContext context) {
 36:     final colorScheme = Theme.of(context).colorScheme;
 37:     return Padding(
 38:       padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
 39:       child: StreamBuilder<int>(
 40:         stream: _friendService.incomingRequestCountStream(_currentUser!.uid),
 41:         builder: (context, snapshot) {
 42:           final count = snapshot.data ?? 0;
 43:           return Material(
 44:             color: Colors.transparent,
 45:             child: InkWell(
 46:               borderRadius: BorderRadius.circular(18),
 47:               onTap: () {
 48:                 Navigator.of(context).push(
 49:                   MaterialPageRoute(
 50:                     builder: (_) =>
 51:                         FriendRequestsScreen(currentUserId: _currentUser!.uid),
 52:                   ),
 53:                 );
 54:               },
 55:               child: Container(
 56:                 padding: const EdgeInsets.symmetric(
 57:                   vertical: 16,
 58:                   horizontal: 18,
 59:                 ),
 60:                 decoration: BoxDecoration(
 61:                   borderRadius: BorderRadius.circular(18),
 62:                   color: colorScheme.onSurface.withValues(alpha: 0.05),
 63:                 ),
 64:                 child: Row(
 65:                   children: [
 66:                     Icon(Icons.person_add_rounded, color: colorScheme.primary),
 67:                     const SizedBox(width: 14),
 68:                     Expanded(
 69:                       child: Text(
 70:                         "Friend Requests",
 71:                         style: TextStyle(
 72:                           fontWeight: FontWeight.w700,
 73:                           fontSize: 16,
 74:                           color: colorScheme.onSurface,
 75:                         ),
 76:                       ),
 77:                     ),
 78:                     if (count > 0)
 79:                       Container(
 80:                         padding: const EdgeInsets.symmetric(
 81:                           horizontal: 10,
 82:                           vertical: 4,
 83:                         ),
 84:                         decoration: BoxDecoration(
 85:                           color: colorScheme.error,
 86:                           borderRadius: BorderRadius.circular(12),
 87:                         ),
 88:                         child: Text(
 89:                           count > 9 ? "9+" : "$count",
 90:                           style: const TextStyle(
 91:                             color: Colors.white,
 92:                             fontWeight: FontWeight.bold,
 93:                             fontSize: 12,
 94:                           ),
 95:                         ),
 96:                       ),
 97:                     const SizedBox(width: 6),
 98:                     Icon(
 99:                       Icons.arrow_forward_ios_rounded,
100:                       size: 16,
101:                       color: colorScheme.onSurface.withValues(alpha: 0.5),
102:                     ),
103:                   ],
104:                 ),
105:               ),
106:             ),
107:           );
108:         },
109:       ),
110:     );
111:   }
112:   // ───────────────── Friends List ─────────────────
113:   Widget _friendsList(BuildContext context) {
114:     final colorScheme = Theme.of(context).colorScheme;
115:     return StreamBuilder<List<RelationshipInfo>>(
116:       stream: _friendService.friendsStream(_currentUser!.uid),
117:       builder: (context, snapshot) {
118:         if (snapshot.connectionState == ConnectionState.waiting) {
119:           return Center(
120:             child: CircularProgressIndicator(
121:               strokeWidth: 2.5,
122:               color: colorScheme.primary,
123:             ),
124:           );
125:         }
126:         final friends = snapshot.data ?? [];
127:         if (friends.isEmpty) {
128:           return Center(
129:             child: Text(
130:               "No friends yet",
131:               style: TextStyle(
132:                 color: colorScheme.onSurface.withValues(alpha: 0.5),
133:               ),
134:             ),
135:           );
136:         }
137:         return ListView.builder(
138:           padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
139:           physics: const BouncingScrollPhysics(),
140:           itemCount: friends.length,
141:           itemBuilder: (context, index) {
142:             return _friendTile(context, friends[index]);
143:           },
144:         );
145:       },
146:     );
147:   }
148:   // ───────────────── Friend Tile ─────────────────
149:   Widget _friendTile(BuildContext context, RelationshipInfo friend) {
150:     final colorScheme = Theme.of(context).colorScheme;
151:     return FutureBuilder<DocumentSnapshot>(
152:       future: FirebaseFirestore.instance
153:           .collection('users')
154:           .doc(friend.otherUid)
155:           .get(),
156:       builder: (context, snapshot) {
157:         if (!snapshot.hasData || !snapshot.data!.exists) {
158:           return const SizedBox.shrink();
159:         }
160:         final userData = snapshot.data!.data() as Map<String, dynamic>;
161:         final username = userData['username'] ?? 'User';
162:         return Padding(
163:           padding: const EdgeInsets.only(bottom: 10),
164:           child: ClipRRect(
165:             borderRadius: BorderRadius.circular(18),
166:             child: Material(
167:               color: colorScheme.onSurface.withValues(alpha: 0.04),
168:               child: InkWell(
169:                 onTap: () {
170:                   Navigator.of(context).push(
171:                     MaterialPageRoute(
172:                       builder: (_) => UserProfileView(
173:                         userData: {
174:                           'uid': friend.otherUid,
175:                           'username': username,
176:                           'email': userData['email'],
177:                         },
178:                         currentUserId: _currentUser!.uid,
179:                       ),
180:                     ),
181:                   );
182:                 },
183:                 child: Padding(
184:                   padding: const EdgeInsets.all(14),
185:                   child: Row(
186:                     children: [
187:                       CircleAvatar(
188:                         radius: 26,
189:                         backgroundColor: colorScheme.primary.withValues(
190:                           alpha: 0.15,
191:                         ),
192:                         child: Text(
193:                           username.isNotEmpty ? username[0].toUpperCase() : '?',
194:                           style: TextStyle(
195:                             color: colorScheme.primary,
196:                             fontWeight: FontWeight.bold,
197:                           ),
198:                         ),
199:                       ),
200:                       const SizedBox(width: 14),
201:                       Expanded(
202:                         child: Text(
203:                           username,
204:                           style: TextStyle(
205:                             fontSize: 16,
206:                             fontWeight: FontWeight.w600,
207:                             color: colorScheme.onSurface,
208:                           ),
209:                         ),
210:                       ),
211:                       IconButton(
212:                         icon: Icon(
213:                           Icons.chat_bubble_rounded,
214:                           color: colorScheme.primary,
215:                         ),
216:                         onPressed: () {
217:                           final chatId = _chatService.getChatId(
218:                             _currentUser!.uid,
219:                             friend.otherUid,
220:                           );
221:                           Navigator.of(context).push(
222:                             MaterialPageRoute(
223:                               builder: (_) => ChatScreen(
224:                                 chatId: chatId,
225:                                 friendUid: friend.otherUid,
226:                                 friendUsername: username,
227:                               ),
228:                             ),
229:                           );
230:                         },
231:                       ),
232:                     ],
233:                   ),
234:                 ),
235:               ),
236:             ),
237:           ),
238:         );
239:       },
240:     );
241:   }
242: }
````

## File: lib/screens/search_screen.dart
````dart
  1: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2: // FILE: lib/screens/search_screen.dart
  3: // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  4: import 'dart:async';
  5: import 'dart:math' as math;
  6: import 'package:chat_app/widgets/search_result_tile.dart';
  7: import 'package:flutter/material.dart';
  8: import 'package:firebase_auth/firebase_auth.dart';
  9: import 'package:cloud_firestore/cloud_firestore.dart';
 10: import '../services/friend_service.dart';
 11: import 'user_profile_view.dart';
 12: import 'friend_requests_screen.dart';
 13: class SearchScreen extends StatefulWidget {
 14:   const SearchScreen({super.key});
 15:   @override
 16:   State<SearchScreen> createState() => _SearchScreenState();
 17: }
 18: class _SearchScreenState extends State<SearchScreen>
 19:     with TickerProviderStateMixin {
 20:   final TextEditingController _searchController = TextEditingController();
 21:   final FocusNode _searchFocusNode = FocusNode();
 22:   List<Map<String, dynamic>> _searchResults = [];
 23:   bool _isSearching = false;
 24:   bool _hasSearched = false;
 25:   String _lastQuery = '';
 26:   Timer? _debounceTimer;
 27:   late AnimationController _floatingController;
 28:   late AnimationController _pulseController;
 29:   final _currentUser = FirebaseAuth.instance.currentUser;
 30:   final _friendService = FriendService();
 31:   @override
 32:   void initState() {
 33:     super.initState();
 34:     _floatingController = AnimationController(
 35:       vsync: this,
 36:       duration: const Duration(seconds: 3),
 37:     )..repeat(reverse: true);
 38:     _pulseController = AnimationController(
 39:       vsync: this,
 40:       duration: const Duration(seconds: 2),
 41:     )..repeat(reverse: true);
 42:   }
 43:   @override
 44:   void dispose() {
 45:     _searchController.dispose();
 46:     _searchFocusNode.dispose();
 47:     _floatingController.dispose();
 48:     _pulseController.dispose();
 49:     _debounceTimer?.cancel();
 50:     super.dispose();
 51:   }
 52:   // ─── DEBOUNCED SEARCH ──────────────────────────────────────────────────
 53:   void _onSearchChanged(String value) {
 54:     setState(() {}); // for suffix icon visibility
 55:     _debounceTimer?.cancel();
 56:     _debounceTimer = Timer(const Duration(milliseconds: 400), () {
 57:       _performSearch(value);
 58:     });
 59:   }
 60:   Future<void> _performSearch(String query) async {
 61:     final trimmed = query.trim().toLowerCase();
 62:     if (trimmed.isEmpty) {
 63:       setState(() {
 64:         _searchResults = [];
 65:         _hasSearched = false;
 66:         _lastQuery = '';
 67:       });
 68:       return;
 69:     }
 70:     if (trimmed == _lastQuery) return;
 71:     _lastQuery = trimmed;
 72:     setState(() => _isSearching = true);
 73:     try {
 74:       final snapshot = await FirebaseFirestore.instance
 75:           .collection('users')
 76:           .where('username', isGreaterThanOrEqualTo: trimmed)
 77:           .where('username', isLessThanOrEqualTo: '$trimmed\uf8ff')
 78:           .limit(20)
 79:           .get();
 80:       if (!mounted) return;
 81:       final results = snapshot.docs
 82:           .where((doc) => doc.id != _currentUser?.uid)
 83:           .map((doc) {
 84:             final data = doc.data();
 85:             data['uid'] = doc.id;
 86:             return data;
 87:           })
 88:           .toList();
 89:       setState(() {
 90:         _searchResults = results;
 91:         _isSearching = false;
 92:         _hasSearched = true;
 93:       });
 94:     } catch (e) {
 95:       if (!mounted) return;
 96:       setState(() {
 97:         _isSearching = false;
 98:         _hasSearched = true;
 99:         _searchResults = [];
100:       });
101:     }
102:   }
103:   // ─── RECENTLY VIEWED ──────────────────────────────────────────────────
104:   Future<void> _saveRecentlyViewed(String viewedUid) async {
105:     if (_currentUser == null) return;
106:     final ref = FirebaseFirestore.instance
107:         .collection('users')
108:         .doc(_currentUser!.uid)
109:         .collection('recentlyViewed')
110:         .doc(viewedUid);
111:     await ref.set({
112:       'uid': viewedUid,
113:       'viewedAt': FieldValue.serverTimestamp(),
114:     }, SetOptions(merge: true));
115:   }
116:   Stream<QuerySnapshot> _recentlyViewedStream() {
117:     if (_currentUser == null) return const Stream.empty();
118:     return FirebaseFirestore.instance
119:         .collection('users')
120:         .doc(_currentUser!.uid)
121:         .collection('recentlyViewed')
122:         .orderBy('viewedAt', descending: true)
123:         .limit(10)
124:         .snapshots();
125:   }
126:   void _openUserProfile(Map<String, dynamic> userData) {
127:     _saveRecentlyViewed(userData['uid']);
128:     Navigator.of(context).push(
129:       MaterialPageRoute(
130:         builder: (_) => UserProfileView(
131:           userData: userData,
132:           currentUserId: _currentUser!.uid,
133:         ),
134:       ),
135:     );
136:   }
137:   // ─── BUILD ─────────────────────────────────────────────────────────────
138:   @override
139:   Widget build(BuildContext context) {
140:     final theme = Theme.of(context);
141:     final colorScheme = theme.colorScheme;
142:     return Scaffold(
143:       backgroundColor: colorScheme.surface,
144:       body: SafeArea(
145:         bottom: false,
146:         child: Column(
147:           children: [
148:             _buildSearchHeader(theme, colorScheme),
149:             Expanded(
150:               child: _isSearching
151:                   ? _buildLoadingState(theme)
152:                   : _hasSearched
153:                   ? _buildSearchResults(theme, colorScheme)
154:                   : _buildDefaultState(theme, colorScheme),
155:             ),
156:           ],
157:         ),
158:       ),
159:     );
160:   }
161:   // ─── SEARCH HEADER ────────────────────────────────────────────────────
162:   Widget _buildSearchHeader(ThemeData theme, ColorScheme colorScheme) {
163:     return Padding(
164:       padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
165:       child: Column(
166:         crossAxisAlignment: CrossAxisAlignment.start,
167:         children: [
168:           Row(
169:             mainAxisAlignment: MainAxisAlignment.spaceBetween,
170:             children: [
171:               Text(
172:                 'Search',
173:                 style: theme.textTheme.headlineMedium?.copyWith(
174:                   fontWeight: FontWeight.w800,
175:                   color: colorScheme.onSurface,
176:                 ),
177:               ),
178:               // Friend Requests badge button
179:               // _buildRequestsBadge(colorScheme),
180:             ],
181:           ),
182:           const SizedBox(height: 16),
183:           Container(
184:             decoration: BoxDecoration(
185:               color: colorScheme.onSurface.withValues(alpha: 0.06),
186:               borderRadius: BorderRadius.circular(16),
187:             ),
188:             child: TextField(
189:               controller: _searchController,
190:               focusNode: _searchFocusNode,
191:               style: theme.textTheme.bodyLarge?.copyWith(
192:                 color: colorScheme.onSurface,
193:               ),
194:               decoration: InputDecoration(
195:                 hintText: 'Search by username...',
196:                 hintStyle: theme.textTheme.bodyLarge?.copyWith(
197:                   color: colorScheme.onSurface.withValues(alpha: 0.4),
198:                 ),
199:                 prefixIcon: Icon(
200:                   Icons.search_rounded,
201:                   color: colorScheme.onSurface.withValues(alpha: 0.5),
202:                 ),
203:                 suffixIcon: _searchController.text.isNotEmpty
204:                     ? IconButton(
205:                         icon: Icon(
206:                           Icons.close_rounded,
207:                           color: colorScheme.onSurface.withValues(alpha: 0.5),
208:                         ),
209:                         onPressed: () {
210:                           _searchController.clear();
211:                           _debounceTimer?.cancel();
212:                           setState(() {
213:                             _searchResults = [];
214:                             _hasSearched = false;
215:                             _lastQuery = '';
216:                           });
217:                         },
218:                       )
219:                     : null,
220:                 border: InputBorder.none,
221:                 contentPadding: const EdgeInsets.symmetric(
222:                   horizontal: 16,
223:                   vertical: 14,
224:                 ),
225:               ),
226:               onChanged: _onSearchChanged,
227:             ),
228:           ),
229:           const SizedBox(height: 8),
230:         ],
231:       ),
232:     );
233:   }
234:   // ─── LOADING STATE ────────────────────────────────────────────────────
235:   Widget _buildLoadingState(ThemeData theme) {
236:     return ListView.builder(
237:       padding: const EdgeInsets.symmetric(horizontal: 20),
238:       physics: const BouncingScrollPhysics(),
239:       itemCount: 5,
240:       itemBuilder: (context, index) {
241:         return Container(
242:           margin: const EdgeInsets.only(bottom: 12),
243:           padding: const EdgeInsets.all(14),
244:           decoration: BoxDecoration(
245:             color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
246:             borderRadius: BorderRadius.circular(18),
247:           ),
248:           child: Row(
249:             children: [
250:               Container(
251:                 width: 50,
252:                 height: 50,
253:                 decoration: BoxDecoration(
254:                   shape: BoxShape.circle,
255:                   color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
256:                 ),
257:               ),
258:               const SizedBox(width: 14),
259:               Expanded(
260:                 child: Column(
261:                   crossAxisAlignment: CrossAxisAlignment.start,
262:                   children: [
263:                     Container(
264:                       width: 120,
265:                       height: 12,
266:                       decoration: BoxDecoration(
267:                         color: theme.colorScheme.onSurface.withValues(
268:                           alpha: 0.06,
269:                         ),
270:                         borderRadius: BorderRadius.circular(6),
271:                       ),
272:                     ),
273:                     const SizedBox(height: 8),
274:                     Container(
275:                       width: 80,
276:                       height: 10,
277:                       decoration: BoxDecoration(
278:                         color: theme.colorScheme.onSurface.withValues(
279:                           alpha: 0.04,
280:                         ),
281:                         borderRadius: BorderRadius.circular(5),
282:                       ),
283:                     ),
284:                   ],
285:                 ),
286:               ),
287:             ],
288:           ),
289:         );
290:       },
291:     );
292:   }
293:   // ─── SEARCH RESULTS ───────────────────────────────────────────────────
294:   Widget _buildSearchResults(ThemeData theme, ColorScheme colorScheme) {
295:     if (_searchResults.isEmpty) {
296:       return _buildNoResults(theme, colorScheme);
297:     }
298:     return ListView.builder(
299:       padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
300:       physics: const BouncingScrollPhysics(),
301:       itemCount: _searchResults.length,
302:       itemBuilder: (context, index) {
303:         final user = _searchResults[index];
304:         return SearchResultTile(
305:           userData: user,
306:           currentUserId: _currentUser!.uid,
307:           onTap: () => _openUserProfile(user),
308:         );
309:       },
310:     );
311:   }
312:   Widget _buildNoResults(ThemeData theme, ColorScheme colorScheme) {
313:     return Center(
314:       child: Padding(
315:         padding: const EdgeInsets.symmetric(horizontal: 40),
316:         child: Column(
317:           mainAxisSize: MainAxisSize.min,
318:           children: [
319:             Icon(
320:               Icons.search_off_rounded,
321:               size: 80,
322:               color: colorScheme.onSurface.withValues(alpha: 0.15),
323:             ),
324:             const SizedBox(height: 20),
325:             Text(
326:               'No users found',
327:               style: theme.textTheme.titleLarge?.copyWith(
328:                 fontWeight: FontWeight.w700,
329:                 color: colorScheme.onSurface,
330:               ),
331:             ),
332:             const SizedBox(height: 10),
333:             Text(
334:               'Try a different username or check the spelling.',
335:               textAlign: TextAlign.center,
336:               style: theme.textTheme.bodyMedium?.copyWith(
337:                 color: colorScheme.onSurface.withValues(alpha: 0.5),
338:                 height: 1.5,
339:               ),
340:             ),
341:           ],
342:         ),
343:       ),
344:     );
345:   }
346:   // ─── DEFAULT STATE ────────────────────────────────────────────────────
347:   Widget _buildDefaultState(ThemeData theme, ColorScheme colorScheme) {
348:     return StreamBuilder<QuerySnapshot>(
349:       stream: _recentlyViewedStream(),
350:       builder: (context, snapshot) {
351:         if (snapshot.connectionState == ConnectionState.waiting) {
352:           return _buildLoadingState(theme);
353:         }
354:         final docs = snapshot.data?.docs ?? [];
355:         if (docs.isEmpty) {
356:           return _buildEmptySearchState(theme, colorScheme);
357:         }
358:         return _buildRecentlyViewed(docs, theme, colorScheme);
359:       },
360:     );
361:   }
362:   Widget _buildRecentlyViewed(
363:     List<QueryDocumentSnapshot> recentDocs,
364:     ThemeData theme,
365:     ColorScheme colorScheme,
366:   ) {
367:     return Column(
368:       crossAxisAlignment: CrossAxisAlignment.start,
369:       children: [
370:         Padding(
371:           padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
372:           child: Row(
373:             children: [
374:               Icon(
375:                 Icons.history_rounded,
376:                 size: 20,
377:                 color: colorScheme.onSurface.withValues(alpha: 0.5),
378:               ),
379:               const SizedBox(width: 8),
380:               Text(
381:                 'Recently Viewed',
382:                 style: theme.textTheme.titleSmall?.copyWith(
383:                   fontWeight: FontWeight.w600,
384:                   color: colorScheme.onSurface.withValues(alpha: 0.6),
385:                   letterSpacing: 0.5,
386:                 ),
387:               ),
388:             ],
389:           ),
390:         ),
391:         Expanded(
392:           child: ListView.builder(
393:             padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
394:             physics: const BouncingScrollPhysics(),
395:             itemCount: recentDocs.length,
396:             itemBuilder: (context, index) {
397:               final data = recentDocs[index].data() as Map<String, dynamic>;
398:               final uid = data['uid'] as String;
399:               return FutureBuilder<DocumentSnapshot>(
400:                 future: FirebaseFirestore.instance
401:                     .collection('users')
402:                     .doc(uid)
403:                     .get(),
404:                 builder: (context, userSnapshot) {
405:                   if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
406:                     return const SizedBox.shrink();
407:                   }
408:                   final userData =
409:                       userSnapshot.data!.data() as Map<String, dynamic>;
410:                   userData['uid'] = uid;
411:                   return SearchResultTile(
412:                     userData: userData,
413:                     currentUserId: _currentUser!.uid,
414:                     onTap: () => _openUserProfile(userData),
415:                   );
416:                 },
417:               );
418:             },
419:           ),
420:         ),
421:       ],
422:     );
423:   }
424:   // ─── EMPTY SEARCH STATE ───────────────────────────────────────────────
425:   Widget _buildEmptySearchState(ThemeData theme, ColorScheme colorScheme) {
426:     return SingleChildScrollView(
427:       physics: const BouncingScrollPhysics(),
428:       padding: const EdgeInsets.only(bottom: 120),
429:       child: Column(
430:         children: [
431:           const SizedBox(height: 30),
432:           _emptyIllustration(colorScheme),
433:           const SizedBox(height: 10),
434:           Text(
435:             'Discover People',
436:             style: TextStyle(
437:               fontSize: 26,
438:               fontWeight: FontWeight.w800,
439:               color: colorScheme.onSurface,
440:             ),
441:           ),
442:           const SizedBox(height: 14),
443:           Padding(
444:             padding: const EdgeInsets.symmetric(horizontal: 50),
445:             child: Text(
446:               'Search for friends by username.\nConnect, chat, and stay close!',
447:               textAlign: TextAlign.center,
448:               style: TextStyle(
449:                 color: colorScheme.onSurface.withValues(alpha: 0.4),
450:                 height: 1.6,
451:               ),
452:             ),
453:           ),
454:           const SizedBox(height: 36),
455:           Padding(
456:             padding: const EdgeInsets.symmetric(horizontal: 40),
457:             child: GestureDetector(
458:               onTap: () => _searchFocusNode.requestFocus(),
459:               child: Container(
460:                 height: 56,
461:                 width: double.infinity,
462:                 decoration: BoxDecoration(
463:                   gradient: LinearGradient(
464:                     colors: [colorScheme.primary, colorScheme.secondary],
465:                   ),
466:                   borderRadius: BorderRadius.circular(18),
467:                   boxShadow: [
468:                     BoxShadow(
469:                       color: colorScheme.primary.withValues(alpha: 0.3),
470:                       blurRadius: 16,
471:                       offset: const Offset(0, 6),
472:                     ),
473:                   ],
474:                 ),
475:                 child: Row(
476:                   mainAxisAlignment: MainAxisAlignment.center,
477:                   children: [
478:                     Icon(Icons.search_rounded, color: colorScheme.onPrimary),
479:                     const SizedBox(width: 10),
480:                     Text(
481:                       'Start Searching',
482:                       style: TextStyle(
483:                         color: colorScheme.onPrimary,
484:                         fontWeight: FontWeight.w700,
485:                       ),
486:                     ),
487:                   ],
488:                 ),
489:               ),
490:             ),
491:           ),
492:           const SizedBox(height: 30),
493:           Container(
494:             margin: const EdgeInsets.symmetric(horizontal: 30),
495:             padding: const EdgeInsets.all(18),
496:             decoration: BoxDecoration(
497:               borderRadius: BorderRadius.circular(20),
498:               color: colorScheme.onSurface.withValues(alpha: 0.05),
499:             ),
500:             child: Row(
501:               children: [
502:                 const Text('💡', style: TextStyle(fontSize: 20)),
503:                 const SizedBox(width: 12),
504:                 Expanded(
505:                   child: Text(
506:                     'Type a username to find and connect with people!',
507:                     style: TextStyle(
508:                       color: colorScheme.onSurface.withValues(alpha: 0.7),
509:                     ),
510:                   ),
511:                 ),
512:               ],
513:             ),
514:           ),
515:         ],
516:       ),
517:     );
518:   }
519:   Widget _emptyIllustration(ColorScheme colorScheme) {
520:     return SizedBox(
521:       height: 260,
522:       child: Stack(
523:         alignment: Alignment.center,
524:         children: [
525:           AnimatedBuilder(
526:             animation: _pulseController,
527:             builder: (_, __) {
528:               final pulse = 0.2 + _pulseController.value * 0.15;
529:               return Container(
530:                 width: 180,
531:                 height: 180,
532:                 decoration: BoxDecoration(
533:                   shape: BoxShape.circle,
534:                   gradient: RadialGradient(
535:                     colors: [
536:                       colorScheme.primary.withValues(alpha: pulse),
537:                       colorScheme.secondary.withValues(alpha: pulse * 0.5),
538:                       Colors.transparent,
539:                     ],
540:                   ),
541:                 ),
542:               );
543:             },
544:           ),
545:           ..._buildFloatingBubbles(colorScheme),
546:           AnimatedBuilder(
547:             animation: _floatingController,
548:             builder: (_, child) {
549:               final offset = 8.0 * _floatingController.value;
550:               return Transform.translate(
551:                 offset: Offset(0, -offset),
552:                 child: child,
553:               );
554:             },
555:             child: Container(
556:               width: 120,
557:               height: 120,
558:               decoration: BoxDecoration(
559:                 shape: BoxShape.circle,
560:                 gradient: LinearGradient(
561:                   colors: [
562:                     colorScheme.surface,
563:                     colorScheme.surfaceContainerHighest,
564:                   ],
565:                 ),
566:                 border: Border.all(
567:                   color: colorScheme.onSurface.withValues(alpha: 0.08),
568:                   width: 2,
569:                 ),
570:               ),
571:               child: Icon(
572:                 Icons.person_search_rounded,
573:                 color: colorScheme.onSurface,
574:                 size: 48,
575:               ),
576:             ),
577:           ),
578:         ],
579:       ),
580:     );
581:   }
582:   List<Widget> _buildFloatingBubbles(ColorScheme colorScheme) {
583:     final bubbles = [
584:       _BubbleInfo(
585:         const Offset(-80, -70),
586:         38,
587:         colorScheme.primary,
588:         Icons.search,
589:       ),
590:       _BubbleInfo(
591:         const Offset(75, -50),
592:         33,
593:         colorScheme.secondary,
594:         Icons.person_add,
595:       ),
596:       _BubbleInfo(
597:         const Offset(-60, 60),
598:         28,
599:         colorScheme.tertiary,
600:         Icons.chat_bubble,
601:       ),
602:     ];
603:     return bubbles.map((b) {
604:       return AnimatedBuilder(
605:         animation: _floatingController,
606:         builder: (_, __) {
607:           final float = math.sin(_floatingController.value * math.pi) * 6;
608:           return Transform.translate(
609:             offset: b.offset + Offset(0, float),
610:             child: Container(
611:               width: b.size,
612:               height: b.size,
613:               decoration: BoxDecoration(
614:                 color: b.color.withValues(alpha: 0.15),
615:                 shape: BoxShape.circle,
616:               ),
617:               child: Icon(b.icon, color: b.color, size: b.size * 0.5),
618:             ),
619:           );
620:         },
621:       );
622:     }).toList();
623:   }
624: }
625: class _BubbleInfo {
626:   final Offset offset;
627:   final double size;
628:   final Color color;
629:   final IconData icon;
630:   _BubbleInfo(this.offset, this.size, this.color, this.icon);
631: }
````

## File: lib/widgets/chat_tile.dart
````dart
  1: import 'package:flutter/material.dart';
  2: import 'package:cloud_firestore/cloud_firestore.dart';
  3: class ChatTile extends StatelessWidget {
  4:   final String chatId;
  5:   final Map<String, dynamic> data;
  6:   final String currentUserId;
  7:   final int index;
  8:   final VoidCallback? onTap;
  9:   const ChatTile({
 10:     super.key,
 11:     required this.chatId,
 12:     required this.data,
 13:     required this.currentUserId,
 14:     required this.index,
 15:     this.onTap,
 16:   });
 17:   @override
 18:   Widget build(BuildContext context) {
 19:     final participants = List<String>.from(data['participants'] ?? []);
 20:     final otherUserId = participants.firstWhere(
 21:       (id) => id != currentUserId,
 22:       orElse: () => '',
 23:     );
 24:     final lastMessage = data['lastMessage'] ?? '';
 25:     final lastMessageTime = data['lastMessageTime'] as Timestamp?;
 26:     final unreadCount = data['unreadCount_$currentUserId'] ?? 0;
 27:     return FutureBuilder<DocumentSnapshot>(
 28:       future: FirebaseFirestore.instance
 29:           .collection('users')
 30:           .doc(otherUserId)
 31:           .get(),
 32:       builder: (context, userSnapshot) {
 33:         String name = 'Unknown';
 34:         String? photoUrl;
 35:         if (userSnapshot.hasData && userSnapshot.data!.exists) {
 36:           final userData = userSnapshot.data!.data() as Map<String, dynamic>;
 37:           name = userData['username'] ?? 'Unknown'; // ✅ FIXED
 38:           photoUrl = userData['photoUrl']; // ✅ correct field
 39:         }
 40:         return TweenAnimationBuilder<double>(
 41:           tween: Tween(begin: 0, end: 1),
 42:           duration: Duration(milliseconds: 400 + index * 80),
 43:           curve: Curves.easeOutCubic,
 44:           builder: (context, value, child) {
 45:             return Opacity(
 46:               opacity: value,
 47:               child: Transform.translate(
 48:                 offset: Offset(0, 20 * (1 - value)),
 49:                 child: child,
 50:               ),
 51:             );
 52:           },
 53:           child: Container(
 54:             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
 55:             child: Material(
 56:               color: Colors.transparent,
 57:               child: InkWell(
 58:                 borderRadius: BorderRadius.circular(18),
 59:                 onTap: onTap,
 60:                 child: Container(
 61:                   padding: const EdgeInsets.symmetric(
 62:                     horizontal: 14,
 63:                     vertical: 12,
 64:                   ),
 65:                   decoration: BoxDecoration(
 66:                     color: unreadCount > 0
 67:                         ? Theme.of(
 68:                             context,
 69:                           ).colorScheme.onSurface.withValues(alpha: 0.04)
 70:                         : Colors.transparent,
 71:                     borderRadius: BorderRadius.circular(18),
 72:                   ),
 73:                   child: Row(
 74:                     children: [
 75:                       _buildAvatar(context, name, photoUrl, otherUserId),
 76:                       const SizedBox(width: 14),
 77:                       Expanded(
 78:                         child: Column(
 79:                           crossAxisAlignment: CrossAxisAlignment.start,
 80:                           children: [
 81:                             Row(
 82:                               children: [
 83:                                 Expanded(
 84:                                   child: Text(
 85:                                     name,
 86:                                     maxLines: 1,
 87:                                     overflow: TextOverflow.ellipsis,
 88:                                     style: TextStyle(
 89:                                       fontSize: 15,
 90:                                       fontWeight: unreadCount > 0
 91:                                           ? FontWeight.w700
 92:                                           : FontWeight.w600,
 93:                                       color: Theme.of(
 94:                                         context,
 95:                                       ).colorScheme.onSurface,
 96:                                     ),
 97:                                   ),
 98:                                 ),
 99:                                 if (lastMessageTime != null)
100:                                   Text(
101:                                     _formatTime(lastMessageTime),
102:                                     style: TextStyle(
103:                                       fontSize: 11,
104:                                       color: unreadCount > 0
105:                                           ? const Color(0xFFE100FF)
106:                                           : Theme.of(context)
107:                                                 .colorScheme
108:                                                 .onSurface
109:                                                 .withValues(alpha: 0.3),
110:                                     ),
111:                                   ),
112:                               ],
113:                             ),
114:                             const SizedBox(height: 4),
115:                             Row(
116:                               children: [
117:                                 Expanded(
118:                                   child: Text(
119:                                     lastMessage,
120:                                     maxLines: 1,
121:                                     overflow: TextOverflow.ellipsis,
122:                                     style: TextStyle(
123:                                       fontSize: 13,
124:                                       color: unreadCount > 0
125:                                           ? Theme.of(context)
126:                                                 .colorScheme
127:                                                 .onSurface
128:                                                 .withValues(alpha: 0.6)
129:                                           : Theme.of(context)
130:                                                 .colorScheme
131:                                                 .onSurface
132:                                                 .withValues(alpha: 0.3),
133:                                     ),
134:                                   ),
135:                                 ),
136:                                 if (unreadCount > 0)
137:                                   Container(
138:                                     padding: const EdgeInsets.symmetric(
139:                                       horizontal: 7,
140:                                       vertical: 3,
141:                                     ),
142:                                     decoration: BoxDecoration(
143:                                       gradient: const LinearGradient(
144:                                         colors: [
145:                                           Color(0xFF7F00FF),
146:                                           Color(0xFFE100FF),
147:                                         ],
148:                                       ),
149:                                       borderRadius: BorderRadius.circular(10),
150:                                     ),
151:                                     child: Text(
152:                                       unreadCount > 99 ? '99+' : '$unreadCount',
153:                                       style: TextStyle(
154:                                         fontSize: 10,
155:                                         fontWeight: FontWeight.w700,
156:                                         color: Theme.of(
157:                                           context,
158:                                         ).colorScheme.onPrimary,
159:                                       ),
160:                                     ),
161:                                   ),
162:                               ],
163:                             ),
164:                           ],
165:                         ),
166:                       ),
167:                     ],
168:                   ),
169:                 ),
170:               ),
171:             ),
172:           ),
173:         );
174:       },
175:     );
176:   }
177:   Widget _buildAvatar(
178:     BuildContext context,
179:     String name,
180:     String? photoUrl,
181:     String userId,
182:   ) {
183:     final colors = [
184:       const Color(0xFFFF6B6B),
185:       const Color(0xFF4ECDC4),
186:       const Color(0xFFA78BFA),
187:       const Color(0xFFFFE66D),
188:       const Color(0xFF60A5FA),
189:       const Color(0xFFF472B6),
190:     ];
191:     final color = colors[userId.hashCode % colors.length];
192:     return Stack(
193:       children: [
194:         Container(
195:           width: 52,
196:           height: 52,
197:           decoration: BoxDecoration(
198:             shape: BoxShape.circle,
199:             gradient: LinearGradient(
200:               colors: [
201:                 color.withValues(alpha: 0.8),
202:                 color.withValues(alpha: 0.4),
203:               ],
204:             ),
205:           ),
206:           child: photoUrl != null
207:               ? ClipOval(
208:                   child: Image.network(
209:                     photoUrl,
210:                     fit: BoxFit.cover,
211:                     errorBuilder: (_, _, _) => _initial(name),
212:                   ),
213:                 )
214:               : _initial(name),
215:         ),
216:         Positioned(
217:           bottom: 1,
218:           right: 1,
219:           child: Container(
220:             width: 13,
221:             height: 13,
222:             decoration: BoxDecoration(
223:               color: const Color(0xFF34D399),
224:               shape: BoxShape.circle,
225:               border: Border.all(
226:                 color: Theme.of(context).colorScheme.surface,
227:                 width: 2.5,
228:               ),
229:             ),
230:           ),
231:         ),
232:       ],
233:     );
234:   }
235:   Widget _initial(String name) {
236:     return Center(
237:       child: Text(
238:         name.isNotEmpty ? name[0].toUpperCase() : '?',
239:         style: const TextStyle(
240:           fontSize: 20,
241:           fontWeight: FontWeight.w700,
242:           color: Colors.white,
243:         ),
244:       ),
245:     );
246:   }
247:   String _formatTime(Timestamp timestamp) {
248:     final now = DateTime.now();
249:     final date = timestamp.toDate();
250:     final diff = now.difference(date);
251:     if (diff.inMinutes < 1) return 'now';
252:     if (diff.inHours < 1) return '${diff.inMinutes}m';
253:     if (diff.inDays < 1) return '${diff.inHours}h';
254:     if (diff.inDays < 7) return '${diff.inDays}d';
255:     return '${date.day}/${date.month}';
256:   }
257: }
````

## File: lib/widgets/chat_home_header.dart
````dart
  1: import 'package:flutter/material.dart';
  2: import 'package:firebase_auth/firebase_auth.dart';
  3: import 'package:cloud_firestore/cloud_firestore.dart';
  4: import 'package:chat_app/services/friend_service.dart';
  5: class ChatHomeHeader extends StatelessWidget {
  6:   final User? currentUser;
  7:   final Stream<QuerySnapshot>? chatStream;
  8:   final Function(String?) onSearchChanged;
  9:   final FriendService _friendService = FriendService();
 10:   ChatHomeHeader({
 11:     super.key,
 12:     required this.currentUser,
 13:     required this.chatStream,
 14:     required this.onSearchChanged,
 15:   });
 16:   @override
 17:   Widget build(BuildContext context) {
 18:     return Padding(
 19:       padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
 20:       child: Column(
 21:         crossAxisAlignment: CrossAxisAlignment.start,
 22:         children: [
 23:           _topRow(context),
 24:           const SizedBox(height: 20),
 25:           _searchBar(context),
 26:           const SizedBox(height: 16),
 27:           _messageHeader(context),
 28:         ],
 29:       ),
 30:     );
 31:   }
 32:   Widget _topRow(BuildContext context) {
 33:     final colorScheme = Theme.of(context).colorScheme;
 34:     return Row(
 35:       children: [
 36:         Expanded(
 37:           child: Column(
 38:             crossAxisAlignment: CrossAxisAlignment.start,
 39:             children: [
 40:               Text(
 41:                 _getGreeting(),
 42:                 style: TextStyle(
 43:                   fontSize: 14,
 44:                   color: colorScheme.onSurface.withValues(alpha: 0.5),
 45:                 ),
 46:               ),
 47:               const SizedBox(height: 4),
 48:               // ✅ Fetch name from Firestore
 49:               currentUser == null
 50:                   ? const Text('User')
 51:                   : StreamBuilder<DocumentSnapshot>(
 52:                       stream: FirebaseFirestore.instance
 53:                           .collection('users')
 54:                           .doc(currentUser!.uid)
 55:                           .snapshots(),
 56:                       builder: (context, snapshot) {
 57:                         if (!snapshot.hasData) {
 58:                           return Text(
 59:                             '...',
 60:                             style: TextStyle(
 61:                               fontSize: 26,
 62:                               color: colorScheme.onSurface,
 63:                               fontWeight: FontWeight.w700,
 64:                             ),
 65:                           );
 66:                         }
 67:                         final data =
 68:                             snapshot.data!.data() as Map<String, dynamic>?;
 69:                         final name = data?['username'] ?? 'User';
 70:                         return Text(
 71:                           name,
 72:                           style: TextStyle(
 73:                             fontSize: 26,
 74:                             color: colorScheme.onSurface,
 75:                             fontWeight: FontWeight.w700,
 76:                           ),
 77:                         );
 78:                       },
 79:                     ),
 80:             ],
 81:           ),
 82:         ),
 83:       ],
 84:     );
 85:   }
 86:   Widget _searchBar(BuildContext context) {
 87:     return Container(
 88:       height: 48,
 89:       decoration: BoxDecoration(
 90:         color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
 91:         borderRadius: BorderRadius.circular(16),
 92:       ),
 93:       child: Row(
 94:         children: [
 95:           const SizedBox(width: 16),
 96:           Icon(
 97:             Icons.search,
 98:             color: Theme.of(
 99:               context,
100:             ).colorScheme.onSurface.withValues(alpha: 0.3),
101:           ),
102:           const SizedBox(width: 10),
103:           Expanded(
104:             child: TextField(
105:               onChanged: (value) => onSearchChanged(value),
106:               style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
107:               decoration: InputDecoration(
108:                 hintText: 'Search conversations...',
109:                 hintStyle: TextStyle(
110:                   color: Theme.of(
111:                     context,
112:                   ).colorScheme.onSurface.withValues(alpha: 0.25),
113:                 ),
114:                 border: InputBorder.none,
115:               ),
116:             ),
117:           ),
118:         ],
119:       ),
120:     );
121:   }
122:   Widget _messageHeader(BuildContext context) {
123:     return Row(
124:       children: [
125:         Text(
126:           'Messages',
127:           style: TextStyle(
128:             fontSize: 18,
129:             fontWeight: FontWeight.w700,
130:             color: Theme.of(context).colorScheme.onSurface,
131:           ),
132:         ),
133:         const SizedBox(width: 8),
134:         Container(
135:           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
136:           decoration: BoxDecoration(
137:             gradient: const LinearGradient(
138:               colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
139:             ),
140:             borderRadius: BorderRadius.circular(10),
141:           ),
142:           child: StreamBuilder<QuerySnapshot>(
143:             stream: chatStream,
144:             builder: (_, snapshot) {
145:               final count = snapshot.data?.docs.length ?? 0;
146:               return Text(
147:                 '$count',
148:                 style: TextStyle(
149:                   fontSize: 11,
150:                   color: Theme.of(context).colorScheme.onPrimary,
151:                   fontWeight: FontWeight.w700,
152:                 ),
153:               );
154:             },
155:           ),
156:         ),
157:       ],
158:     );
159:   }
160:   String _getGreeting() {
161:     final hour = DateTime.now().hour;
162:     if (hour < 12) return 'Good Morning 🌅';
163:     if (hour < 17) return 'Good Afternoon ☀️';
164:     if (hour < 21) return 'Good Evening 🌆';
165:     return 'Good Night 🌙';
166:   }
167: }
````

## File: lib/main.dart
````dart
  1: import 'package:chat_app/screens/home_screen.dart';
  2: import 'package:chat_app/screens/login_screen.dart';
  3: import 'package:chat_app/services/chat_service.dart';
  4: import 'package:firebase_auth/firebase_auth.dart';
  5: import 'package:flutter/material.dart';
  6: import 'package:firebase_core/firebase_core.dart';
  7: import 'package:shared_preferences/shared_preferences.dart';
  8: import 'firebase_options.dart';
  9: Future<void> main() async {
 10:   WidgetsFlutterBinding.ensureInitialized();
 11:   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 12:   runApp(const MyApp());
 13: }
 14: // 🔹 ADDED
 15: class _InheritedMyApp extends InheritedWidget {
 16:   final MyAppState data;
 17:   const _InheritedMyApp({required this.data, required super.child});
 18:   @override
 19:   bool updateShouldNotify(_InheritedMyApp oldWidget) {
 20:     return true;
 21:   }
 22: }
 23: // 🔹 MODIFIED
 24: class MyApp extends StatefulWidget {
 25:   const MyApp({super.key});
 26:   // 🔹 ADDED
 27:   static MyAppState of(BuildContext context) {
 28:     return context.dependOnInheritedWidgetOfExactType<_InheritedMyApp>()!.data;
 29:   }
 30:   @override
 31:   State<MyApp> createState() => MyAppState();
 32: }
 33: class MyAppState extends State<MyApp> {
 34:   ThemeMode _themeMode = ThemeMode.system;
 35:   ThemeMode get currentThemeMode => _themeMode;
 36:   @override
 37:   void initState() {
 38:     super.initState();
 39:     _loadTheme();
 40:     ChatService().migrateChats();
 41:   }
 42:   Future<void> _loadTheme() async {
 43:     final prefs = await SharedPreferences.getInstance();
 44:     final theme = prefs.getString('theme') ?? 'system';
 45:     setState(() {
 46:       switch (theme) {
 47:         case 'light':
 48:           _themeMode = ThemeMode.light;
 49:           break;
 50:         case 'dark':
 51:           _themeMode = ThemeMode.dark;
 52:           break;
 53:         default:
 54:           _themeMode = ThemeMode.system;
 55:       }
 56:     });
 57:   }
 58:   void updateTheme(ThemeMode mode) {
 59:     setState(() {
 60:       _themeMode = mode;
 61:     });
 62:     _saveTheme(mode);
 63:   }
 64:   Future<void> _saveTheme(ThemeMode mode) async {
 65:     final prefs = await SharedPreferences.getInstance();
 66:     String theme;
 67:     switch (mode) {
 68:       case ThemeMode.light:
 69:         theme = 'light';
 70:         break;
 71:       case ThemeMode.dark:
 72:         theme = 'dark';
 73:         break;
 74:       default:
 75:         theme = 'system';
 76:     }
 77:     await prefs.setString('theme', theme);
 78:   }
 79:   @override
 80:   Widget build(BuildContext context) {
 81:     // 🔹 ADDED
 82:     final lightTheme = ThemeData(
 83:       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
 84:       useMaterial3: true,
 85:     );
 86:     final darkTheme = ThemeData(
 87:       brightness: Brightness.dark,
 88:       colorScheme: ColorScheme.fromSeed(
 89:         seedColor: Colors.deepPurple,
 90:         brightness: Brightness.dark,
 91:       ),
 92:       useMaterial3: true,
 93:     );
 94:     return _InheritedMyApp(
 95:       data: this,
 96:       child: MaterialApp(
 97:         scrollBehavior: NoGlowScrollBehavior(),
 98:         debugShowCheckedModeBanner: false,
 99:         title: 'Flutter Chat App',
100:         // 🔹 MODIFIED
101:         theme: lightTheme,
102:         darkTheme: darkTheme,
103:         themeMode: _themeMode,
104:         home: const AuthWrapper(),
105:       ),
106:     );
107:   }
108: }
109: class AuthWrapper extends StatelessWidget {
110:   const AuthWrapper({super.key});
111:   @override
112:   Widget build(BuildContext context) {
113:     return StreamBuilder<User?>(
114:       stream: FirebaseAuth.instance.authStateChanges(),
115:       builder: (context, snapshot) {
116:         if (snapshot.hasData) {
117:           return const HomeScreen();
118:         } else {
119:           return const LoginScreen();
120:         }
121:       },
122:     );
123:   }
124: }
125: class NoGlowScrollBehavior extends ScrollBehavior {
126:   @override
127:   Widget buildOverscrollIndicator(
128:     BuildContext context,
129:     Widget child,
130:     ScrollableDetails details,
131:   ) {
132:     return child; // removes black glow
133:   }
134: }
````

## File: lib/screens/profile_screen.dart
````dart
  1: import 'dart:async';
  2: import 'package:chat_app/main.dart';
  3: import 'package:chat_app/services/chat_service.dart';
  4: import 'package:flutter/material.dart';
  5: import 'package:firebase_auth/firebase_auth.dart';
  6: import 'package:cloud_firestore/cloud_firestore.dart';
  7: import 'package:intl/intl.dart';
  8: class ProfileScreen extends StatefulWidget {
  9:   const ProfileScreen({super.key});
 10:   @override
 11:   State<ProfileScreen> createState() => _ProfileScreenState();
 12: }
 13: class _ProfileScreenState extends State<ProfileScreen> {
 14:   final TextEditingController _usernameController = TextEditingController();
 15:   bool _isEditingUsername = false;
 16:   Timer? _debounce;
 17:   bool _isChecking = false;
 18:   bool _isAvailable = false;
 19:   bool _isLoading = false;
 20:   String _feedbackMessage = "";
 21:   ThemeMode _selectedThemeMode = ThemeMode.system;
 22:   final user = FirebaseAuth.instance.currentUser;
 23:   @override
 24:   void dispose() {
 25:     _debounce?.cancel();
 26:     _usernameController.dispose();
 27:     super.dispose();
 28:   }
 29:   @override
 30:   void didChangeDependencies() {
 31:     super.didChangeDependencies();
 32:     // Get the current theme mode from the parent MyApp state
 33:     // This ensures the dropdown reflects the actual app state when the screen loads
 34:     _selectedThemeMode = MyApp.of(context).currentThemeMode;
 35:   }
 36:   // ✅ Username Format Validation
 37:   bool _validateUsernameFormat(String username) {
 38:     final regex = RegExp(r'^[a-zA-Z0-9._]+$');
 39:     return regex.hasMatch(username);
 40:   }
 41:   // ✅ Debounce Username Check
 42:   void _onUsernameChanged(String value, String currentUsername) {
 43:     if (_debounce?.isActive ?? false) _debounce!.cancel();
 44:     _debounce = Timer(const Duration(milliseconds: 600), () async {
 45:       final username = value.trim().toLowerCase();
 46:       // 🔹 1. Minimum length check
 47:       if (username.length < 6) {
 48:         setState(() {
 49:           _feedbackMessage = "Username must be at least 6 characters";
 50:           _isAvailable = false;
 51:           _isChecking = false;
 52:         });
 53:         return;
 54:       }
 55:       // 🔹 2. Format validation
 56:       if (!_validateUsernameFormat(username)) {
 57:         setState(() {
 58:           _feedbackMessage =
 59:               "Only letters, numbers, . (Dot) and _ (Underscore) allowed.";
 60:           _isAvailable = false;
 61:           _isChecking = false;
 62:         });
 63:         return;
 64:       }
 65:       // 🔹 3. Same as current username (CHECK FIRST)
 66:       if (username == currentUsername) {
 67:         setState(() {
 68:           _feedbackMessage = "This is already your current username";
 69:           _isAvailable = false;
 70:           _isChecking = false;
 71:         });
 72:         return;
 73:       }
 74:       // 🔹 4. Now check Firestore
 75:       setState(() {
 76:         _isChecking = true;
 77:         _feedbackMessage = "";
 78:       });
 79:       final doc = await FirebaseFirestore.instance
 80:           .collection('usernames')
 81:           .doc(username)
 82:           .get();
 83:       if (!mounted) return;
 84:       if (!doc.exists) {
 85:         setState(() {
 86:           _feedbackMessage = "Username available for use";
 87:           _isAvailable = true;
 88:           _isChecking = false;
 89:         });
 90:       } else {
 91:         setState(() {
 92:           _feedbackMessage = "Username already exists";
 93:           _isAvailable = false;
 94:           _isChecking = false;
 95:         });
 96:       }
 97:     });
 98:   }
 99:   // ✅ Final Username Change
100:   Future<void> _changeUsername(String oldUsername) async {
101:     final newUsername = _usernameController.text.trim().toLowerCase();
102:     if (newUsername == oldUsername) {
103:       ScaffoldMessenger.of(context).showSnackBar(
104:         const SnackBar(content: Text("You are already using this username")),
105:       );
106:       return;
107:     }
108:     if (!_isAvailable) return;
109:     setState(() => _isLoading = true);
110:     try {
111:       final batch = FirebaseFirestore.instance.batch();
112:       final oldRef = FirebaseFirestore.instance
113:           .collection('usernames')
114:           .doc(oldUsername);
115:       final newRef = FirebaseFirestore.instance
116:           .collection('usernames')
117:           .doc(newUsername);
118:       final userRef = FirebaseFirestore.instance
119:           .collection('users')
120:           .doc(user!.uid);
121:       batch.delete(oldRef);
122:       batch.set(newRef, {"uid": user!.uid});
123:       batch.update(userRef, {"username": newUsername});
124:       await batch.commit();
125:       // ✅ Update username in all chat metadata for searchable conversations
126:       await ChatService().updateUsernameEverywhere(user!.uid, newUsername);
127:       if (!mounted) return;
128:       _usernameController.clear();
129:       ScaffoldMessenger.of(context).showSnackBar(
130:         const SnackBar(content: Text("Username updated successfully")),
131:       );
132:     } catch (e) {
133:       if (!mounted) return;
134:       ScaffoldMessenger.of(
135:         context,
136:       ).showSnackBar(SnackBar(content: Text("Error: $e")));
137:     }
138:     if (!mounted) return;
139:     setState(() {
140:       _isLoading = false;
141:       _isAvailable = false;
142:       _feedbackMessage = "";
143:     });
144:   }
145:   @override
146:   Widget build(BuildContext context) {
147:     final theme = Theme.of(context);
148:     final colorScheme = theme.colorScheme;
149:     final textTheme = theme.textTheme;
150:     if (user == null) {
151:       return Scaffold(
152:         body: Center(
153:           child: Text("No user logged in", style: textTheme.bodyLarge),
154:         ),
155:       );
156:     }
157:     final creationTime = user!.metadata.creationTime;
158:     final formattedDate = creationTime != null
159:         ? DateFormat('dd MMM yyyy, hh:mm a').format(creationTime.toLocal())
160:         : "Unknown";
161:     return Scaffold(
162:       appBar: AppBar(title: const Text("Profile")),
163:       body: StreamBuilder<DocumentSnapshot>(
164:         stream: FirebaseFirestore.instance
165:             .collection('users')
166:             .doc(user!.uid)
167:             .snapshots(),
168:         builder: (context, snapshot) {
169:           if (!snapshot.hasData || !snapshot.data!.exists) {
170:             return Center(
171:               child: CircularProgressIndicator(color: colorScheme.primary),
172:             );
173:           }
174:           final userData = snapshot.data!;
175:           final username = userData['username'] ?? "";
176:           return LayoutBuilder(
177:             builder: (context, constraints) {
178:               return SingleChildScrollView(
179:                 physics: const BouncingScrollPhysics(
180:                   parent: AlwaysScrollableScrollPhysics(),
181:                 ),
182:                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
183:                 child: ConstrainedBox(
184:                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
185:                   child: Column(
186:                     crossAxisAlignment: CrossAxisAlignment.stretch,
187:                     children: [
188:                       const SizedBox(height: 20),
189:                       CircleAvatar(
190:                         radius: 50,
191:                         backgroundColor: colorScheme.primary.withValues(
192:                           alpha: 0.15,
193:                         ),
194:                         child: Text(
195:                           username.isNotEmpty ? username[0].toUpperCase() : "?",
196:                           style: TextStyle(
197:                             fontSize: 40,
198:                             fontWeight: FontWeight.bold,
199:                             color: colorScheme.primary,
200:                           ),
201:                         ),
202:                       ),
203:                       const SizedBox(height: 12),
204:                       Center(
205:                         child: Text(username, style: textTheme.headlineSmall),
206:                       ),
207:                       const SizedBox(height: 30),
208:                       Card(
209:                         shape: RoundedRectangleBorder(
210:                           borderRadius: BorderRadius.circular(16),
211:                         ),
212:                         elevation: 4,
213:                         child: Padding(
214:                           padding: const EdgeInsets.all(20),
215:                           child: Column(
216:                             crossAxisAlignment: CrossAxisAlignment.start,
217:                             children: [
218:                               AnimatedSwitcher(
219:                                 duration: const Duration(milliseconds: 300),
220:                                 child: !_isEditingUsername
221:                                     ? _buildUsernameView(username, theme)
222:                                     : _buildUsernameEdit(username, theme),
223:                               ),
224:                               const SizedBox(height: 8),
225:                               const Divider(),
226:                               _modernTile(
227:                                 Icons.email,
228:                                 "Email",
229:                                 user!.email ?? "Not available",
230:                                 theme,
231:                               ),
232:                               const Divider(),
233:                               _modernTile(
234:                                 Icons.calendar_today,
235:                                 "Account Created",
236:                                 formattedDate,
237:                                 theme,
238:                               ),
239:                               const Divider(),
240:                               _buildThemeTile(theme),
241:                             ],
242:                           ),
243:                         ),
244:                       ),
245:                       const SizedBox(height: 30),
246:                       _buildLogoutButton(theme),
247:                       const SizedBox(height: 40),
248:                     ],
249:                   ),
250:                 ),
251:               );
252:             },
253:           );
254:         },
255:       ),
256:     );
257:   }
258:   Widget _buildThemeTile(ThemeData theme) {
259:     // 1. Get the current theme directly from MyApp state
260:     // This ensures the dropdown always shows what is actually active in the app
261:     final currentAppTheme = MyApp.of(context).currentThemeMode;
262:     return Padding(
263:       padding: const EdgeInsets.symmetric(vertical: 8),
264:       child: Row(
265:         children: [
266:           Icon(Icons.palette, color: theme.colorScheme.primary),
267:           const SizedBox(width: 16),
268:           Expanded(
269:             child: Column(
270:               crossAxisAlignment: CrossAxisAlignment.start,
271:               children: [
272:                 Text("Theme", style: theme.textTheme.bodySmall),
273:                 const SizedBox(height: 4),
274:                 DropdownButton<ThemeMode>(
275:                   // 2. Use the value from MyApp instead of the local _selectedThemeMode
276:                   value: currentAppTheme,
277:                   underline: const SizedBox(),
278:                   isDense: true,
279:                   items: const [
280:                     DropdownMenuItem(
281:                       value: ThemeMode.light,
282:                       child: Text("Light"),
283:                     ),
284:                     DropdownMenuItem(
285:                       value: ThemeMode.dark,
286:                       child: Text("Dark"),
287:                     ),
288:                     DropdownMenuItem(
289:                       value: ThemeMode.system,
290:                       child: Text("Device Theme"),
291:                     ),
292:                   ],
293:                   onChanged: (ThemeMode? mode) {
294:                     if (mode == null) return;
295:                     // 3. Update the global state (this will trigger a rebuild
296:                     // and update this dropdown automatically)
297:                     MyApp.of(context).updateTheme(mode);
298:                   },
299:                 ),
300:               ],
301:             ),
302:           ),
303:         ],
304:       ),
305:     );
306:   }
307:   Widget _modernTile(
308:     IconData icon,
309:     String title,
310:     String value,
311:     ThemeData theme,
312:   ) {
313:     return Padding(
314:       padding: const EdgeInsets.symmetric(vertical: 8),
315:       child: Row(
316:         children: [
317:           Icon(icon, color: theme.colorScheme.primary),
318:           const SizedBox(width: 16),
319:           Expanded(
320:             child: Column(
321:               crossAxisAlignment: CrossAxisAlignment.start,
322:               children: [
323:                 Text(title, style: theme.textTheme.bodySmall),
324:                 const SizedBox(height: 4),
325:                 Text(
326:                   value,
327:                   style: theme.textTheme.bodyLarge?.copyWith(
328:                     fontWeight: FontWeight.w500,
329:                   ),
330:                 ),
331:               ],
332:             ),
333:           ),
334:         ],
335:       ),
336:     );
337:   }
338:   Widget _buildUsernameView(String username, ThemeData theme) {
339:     return Column(
340:       key: const ValueKey("viewMode"),
341:       crossAxisAlignment: CrossAxisAlignment.start,
342:       children: [
343:         Row(
344:           crossAxisAlignment: CrossAxisAlignment.center,
345:           children: [
346:             Icon(Icons.person, color: theme.colorScheme.primary),
347:             const SizedBox(width: 16),
348:             Expanded(
349:               child: Column(
350:                 crossAxisAlignment: CrossAxisAlignment.start,
351:                 children: [
352:                   Text("Username", style: theme.textTheme.bodySmall),
353:                   const SizedBox(height: 4),
354:                   Text(
355:                     username,
356:                     style: theme.textTheme.bodyLarge?.copyWith(
357:                       fontWeight: FontWeight.w500,
358:                     ),
359:                   ),
360:                 ],
361:               ),
362:             ),
363:             Transform.translate(
364:               offset: const Offset(0, 8),
365:               child: IconButton(
366:                 padding: EdgeInsets.zero,
367:                 constraints: const BoxConstraints(),
368:                 iconSize: 18,
369:                 icon: const Icon(Icons.edit, size: 22),
370:                 onPressed: () {
371:                   setState(() {
372:                     _isEditingUsername = true;
373:                     _usernameController.text = username;
374:                   });
375:                 },
376:               ),
377:             ),
378:           ],
379:         ),
380:       ],
381:     );
382:   }
383:   Widget _buildUsernameEdit(String username, ThemeData theme) {
384:     final colorScheme = theme.colorScheme;
385:     return Column(
386:       key: const ValueKey("editMode"),
387:       crossAxisAlignment: CrossAxisAlignment.start,
388:       children: [
389:         Row(
390:           crossAxisAlignment: CrossAxisAlignment.start,
391:           children: [
392:             Icon(Icons.person, color: colorScheme.primary),
393:             const SizedBox(width: 16),
394:             Expanded(
395:               child: Column(
396:                 crossAxisAlignment: CrossAxisAlignment.start,
397:                 children: [
398:                   Text("Username", style: theme.textTheme.bodySmall),
399:                   const SizedBox(height: 6),
400:                   TextField(
401:                     controller: _usernameController,
402:                     decoration: InputDecoration(
403:                       isDense: true,
404:                       contentPadding: const EdgeInsets.symmetric(
405:                         horizontal: 12,
406:                         vertical: 10,
407:                       ),
408:                       border: OutlineInputBorder(
409:                         borderRadius: BorderRadius.circular(10),
410:                       ),
411:                       suffixIcon: _isChecking
412:                           ? const Padding(
413:                               padding: EdgeInsets.all(12),
414:                               child: SizedBox(
415:                                 width: 16,
416:                                 height: 16,
417:                                 child: CircularProgressIndicator(
418:                                   strokeWidth: 2,
419:                                 ),
420:                               ),
421:                             )
422:                           : _feedbackMessage.isEmpty
423:                           ? null
424:                           : Icon(
425:                               _isAvailable ? Icons.check_circle : Icons.cancel,
426:                               color: _isAvailable
427:                                   ? colorScheme.primary
428:                                   : colorScheme.error,
429:                               size: 18,
430:                             ),
431:                     ),
432:                     onChanged: (value) => _onUsernameChanged(value, username),
433:                   ),
434:                   if (_feedbackMessage.isNotEmpty)
435:                     Padding(
436:                       padding: const EdgeInsets.only(top: 6),
437:                       child: Text(
438:                         _feedbackMessage,
439:                         style: TextStyle(
440:                           color: _isAvailable
441:                               ? colorScheme.primary
442:                               : colorScheme.error,
443:                           fontSize: 12,
444:                         ),
445:                       ),
446:                     ),
447:                   const SizedBox(height: 10),
448:                   Row(
449:                     children: [
450:                       TextButton(
451:                         onPressed: (_isAvailable && !_isLoading)
452:                             ? () async {
453:                                 await _changeUsername(username);
454:                                 setState(() {
455:                                   _isEditingUsername = false;
456:                                 });
457:                               }
458:                             : null,
459:                         child: const Text("Save"),
460:                       ),
461:                       TextButton(
462:                         onPressed: () {
463:                           setState(() {
464:                             _isEditingUsername = false;
465:                             _feedbackMessage = "";
466:                             _isAvailable = false;
467:                             _usernameController.clear();
468:                           });
469:                         },
470:                         child: const Text("Cancel"),
471:                       ),
472:                     ],
473:                   ),
474:                 ],
475:               ),
476:             ),
477:           ],
478:         ),
479:       ],
480:     );
481:   }
482:   Widget _buildLogoutButton(ThemeData theme) {
483:     final colorScheme = theme.colorScheme;
484:     return GestureDetector(
485:       onTap: _showLogoutDialog,
486:       child: Container(
487:         width: double.infinity,
488:         padding: const EdgeInsets.symmetric(vertical: 16),
489:         decoration: BoxDecoration(
490:           borderRadius: BorderRadius.circular(14),
491:           gradient: LinearGradient(
492:             colors: [
493:               colorScheme.error,
494:               colorScheme.error.withValues(alpha: 0.8),
495:             ],
496:           ),
497:           boxShadow: [
498:             BoxShadow(
499:               color: colorScheme.error.withValues(alpha: 0.5),
500:               blurRadius: 20,
501:               spreadRadius: 2,
502:               offset: const Offset(0, 6),
503:             ),
504:           ],
505:         ),
506:         child: Row(
507:           mainAxisAlignment: MainAxisAlignment.center,
508:           children: [
509:             Icon(Icons.logout, color: colorScheme.onError),
510:             const SizedBox(width: 10),
511:             Text(
512:               "Logout",
513:               style: TextStyle(
514:                 color: colorScheme.onError,
515:                 fontSize: 16,
516:                 fontWeight: FontWeight.bold,
517:                 letterSpacing: 1,
518:               ),
519:             ),
520:           ],
521:         ),
522:       ),
523:     );
524:   }
525:   void _showLogoutDialog() {
526:     final theme = Theme.of(context);
527:     final colorScheme = theme.colorScheme;
528:     showDialog(
529:       context: context,
530:       builder: (context) {
531:         return Dialog(
532:           shape: RoundedRectangleBorder(
533:             borderRadius: BorderRadius.circular(20),
534:           ),
535:           child: Padding(
536:             padding: const EdgeInsets.all(20),
537:             child: Column(
538:               mainAxisSize: MainAxisSize.min,
539:               children: [
540:                 Icon(Icons.warning_rounded, color: colorScheme.error, size: 50),
541:                 const SizedBox(height: 16),
542:                 Text(
543:                   "Do you really want to logout?",
544:                   textAlign: TextAlign.center,
545:                   style: theme.textTheme.titleMedium,
546:                 ),
547:                 const SizedBox(height: 24),
548:                 Row(
549:                   children: [
550:                     Expanded(
551:                       child: OutlinedButton(
552:                         style: OutlinedButton.styleFrom(
553:                           padding: const EdgeInsets.symmetric(vertical: 14),
554:                           shape: RoundedRectangleBorder(
555:                             borderRadius: BorderRadius.circular(12),
556:                           ),
557:                         ),
558:                         onPressed: () => Navigator.pop(context),
559:                         child: const Text("Cancel"),
560:                       ),
561:                     ),
562:                     const SizedBox(width: 12),
563:                     Expanded(
564:                       child: ElevatedButton(
565:                         style: ElevatedButton.styleFrom(
566:                           backgroundColor: colorScheme.error,
567:                           foregroundColor: colorScheme.onError,
568:                           padding: const EdgeInsets.symmetric(vertical: 14),
569:                           shape: RoundedRectangleBorder(
570:                             borderRadius: BorderRadius.circular(12),
571:                           ),
572:                           elevation: 8,
573:                         ),
574:                         onPressed: _logout,
575:                         child: const Text(
576:                           "Logout",
577:                           style: TextStyle(fontWeight: FontWeight.bold),
578:                         ),
579:                       ),
580:                     ),
581:                   ],
582:                 ),
583:               ],
584:             ),
585:           ),
586:         );
587:       },
588:     );
589:   }
590:   Future<void> _logout() async {
591:     await FirebaseAuth.instance.signOut();
592:     if (!mounted) return;
593:     Navigator.of(context).pop(); // close dialog
594:   }
595: }
````

## File: lib/screens/home_screen.dart
````dart
  1: import 'package:flutter/material.dart';
  2: import 'package:firebase_auth/firebase_auth.dart';
  3: import 'package:cloud_firestore/cloud_firestore.dart';
  4: import 'package:chat_app/screens/profile_screen.dart';
  5: import 'package:chat_app/widgets/chat_tile.dart';
  6: import 'package:chat_app/widgets/empty_chat_state.dart';
  7: import 'package:chat_app/widgets/glass_bottom_nav.dart';
  8: import 'package:chat_app/widgets/chat_home_header.dart';
  9: import 'package:chat_app/screens/friends_screen.dart';
 10: import 'package:chat_app/screens/search_screen.dart';
 11: import 'package:chat_app/screens/chat_screen.dart';
 12: import 'dart:async';
 13: class HomeScreen extends StatefulWidget {
 14:   const HomeScreen({super.key});
 15:   @override
 16:   State<HomeScreen> createState() => _HomeScreenState();
 17: }
 18: class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
 19:   int _currentIndex = 0;
 20:   @override
 21:   void initState() {
 22:     super.initState();
 23:   }
 24:   @override
 25:   Widget build(BuildContext context) {
 26:     return Scaffold(
 27:       backgroundColor: Theme.of(context).colorScheme.surface,
 28:       extendBody: true,
 29:       body: AnimatedSwitcher(
 30:         duration: const Duration(milliseconds: 400),
 31:         transitionBuilder: (child, animation) {
 32:           return FadeTransition(
 33:             opacity: animation,
 34:             child: SlideTransition(
 35:               position:
 36:                   Tween<Offset>(
 37:                     begin: const Offset(0.03, 0),
 38:                     end: Offset.zero,
 39:                   ).animate(
 40:                     CurvedAnimation(
 41:                       parent: animation,
 42:                       curve: Curves.easeOutCubic,
 43:                     ),
 44:                   ),
 45:               child: child,
 46:             ),
 47:           );
 48:         },
 49:         child: KeyedSubtree(
 50:           key: ValueKey(_currentIndex),
 51:           child: _buildPage(context),
 52:         ),
 53:       ),
 54:       bottomNavigationBar: GlassBottomNavBar(
 55:         currentIndex: _currentIndex,
 56:         onTap: (index) {
 57:           setState(() => _currentIndex = index);
 58:         },
 59:       ),
 60:     );
 61:   }
 62:   Widget _buildPage(BuildContext context) {
 63:     switch (_currentIndex) {
 64:       case 0:
 65:         return const ChatHomeBody();
 66:       case 1:
 67:         return FriendsScreen();
 68:       case 2:
 69:         return SearchScreen();
 70:       case 3:
 71:         return const ProfileScreen();
 72:       default:
 73:         return const SizedBox();
 74:     }
 75:   }
 76: }
 77: // ─── CHAT HOME BODY ───────────────────────────────────────────────────────────
 78: class ChatHomeBody extends StatefulWidget {
 79:   const ChatHomeBody({super.key});
 80:   @override
 81:   State<ChatHomeBody> createState() => _ChatHomeBodyState();
 82: }
 83: class _ChatHomeBodyState extends State<ChatHomeBody>
 84:     with TickerProviderStateMixin {
 85:   late AnimationController _floatingController;
 86:   late AnimationController _pulseController;
 87:   late AnimationController _shimmerController;
 88:   String _searchQuery = "";
 89:   List<String> _matchedUserIds = [];
 90:   Timer? _debounce;
 91:   Widget _buildLoadingItem() {
 92:     return Container(
 93:       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
 94:       padding: const EdgeInsets.all(14),
 95:       decoration: BoxDecoration(
 96:         color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
 97:         borderRadius: BorderRadius.circular(18),
 98:       ),
 99:       child: Row(
100:         children: [
101:           Container(
102:             width: 52,
103:             height: 52,
104:             decoration: BoxDecoration(
105:               shape: BoxShape.circle,
106:               color: Theme.of(context)
107:                   .colorScheme
108:                   .onSurface
109:                   .withValues(alpha: 0.06),
110:             ),
111:           ),
112:           const SizedBox(width: 14),
113:           Expanded(
114:             child: Column(
115:               crossAxisAlignment: CrossAxisAlignment.start,
116:               children: [
117:                 Container(
118:                   width: 120,
119:                   height: 12,
120:                   decoration: BoxDecoration(
121:                     color: Theme.of(context)
122:                         .colorScheme
123:                         .onSurface
124:                         .withValues(alpha: 0.06),
125:                     borderRadius: BorderRadius.circular(6),
126:                   ),
127:                 ),
128:                 const SizedBox(height: 8),
129:                 Container(
130:                   width: 180,
131:                   height: 10,
132:                   decoration: BoxDecoration(
133:                     color: Theme.of(context)
134:                         .colorScheme
135:                         .onSurface
136:                         .withValues(alpha: 0.04),
137:                     borderRadius: BorderRadius.circular(5),
138:                   ),
139:                 ),
140:               ],
141:             ),
142:           ),
143:         ],
144:       ),
145:     );
146:   }
147:   @override
148:   void initState() {
149:     super.initState();
150:     _floatingController = AnimationController(
151:       vsync: this,
152:       duration: const Duration(seconds: 3),
153:     )..repeat(reverse: true);
154:     _pulseController = AnimationController(
155:       vsync: this,
156:       duration: const Duration(seconds: 2),
157:     )..repeat(reverse: true);
158:     _shimmerController = AnimationController(
159:       vsync: this,
160:       duration: const Duration(seconds: 2),
161:     )..repeat();
162:   }
163:   @override
164:   void dispose() {
165:     _floatingController.dispose();
166:     _pulseController.dispose();
167:     _shimmerController.dispose();
168:     _debounce?.cancel();
169:     super.dispose();
170:   }
171:   /// 🔎 SEARCH USERS BY USERNAME PREFIX
172:   Future<List<String>> _searchUserIds(String query) async {
173:     if (query.isEmpty) return [];
174:     final snapshot = await FirebaseFirestore.instance
175:         .collection('users')
176:         .orderBy('username')
177:         .startAt([query])
178:         .endAt([query + '\uf8ff'])
179:         .limit(10)
180:         .get();
181:     return snapshot.docs.map((doc) => doc.id).toList();
182:   }
183:   /// 🔎 SEARCH HANDLER WITH DEBOUNCE
184:   void _onSearchChanged(String? query) {
185:     if (_debounce?.isActive ?? false) _debounce!.cancel();
186:     _debounce = Timer(const Duration(milliseconds: 350), () async {
187:       final text = (query ?? '').toLowerCase();
188:       if (text.isEmpty) {
189:         setState(() {
190:           _searchQuery = "";
191:           _matchedUserIds = [];
192:         });
193:         return;
194:       }
195:       final ids = await _searchUserIds(text);
196:       if (!mounted) return;
197:       setState(() {
198:         _searchQuery = text;
199:         _matchedUserIds = ids;
200:       });
201:     });
202:   }
203:   @override
204:   Widget build(BuildContext context) {
205:     final currentUser = FirebaseAuth.instance.currentUser;
206:     return Scaffold(
207:       backgroundColor: Theme.of(context).colorScheme.surface,
208:       body: CustomScrollView(
209:         physics: const BouncingScrollPhysics(),
210:         slivers: [
211:           SliverToBoxAdapter(
212:             child: SafeArea(
213:               bottom: false,
214:               child: ChatHomeHeader(
215:                 currentUser: currentUser,
216:                 chatStream: _getChatStream(currentUser),
217:                 onSearchChanged: _onSearchChanged,
218:               ),
219:             ),
220:           ),
221:           _buildChatSliver(currentUser),
222:         ],
223:       ),
224:     );
225:   }
226:   /// 📩 DEFAULT CHAT STREAM
227:   Stream<QuerySnapshot>? _getChatStream(User? currentUser) {
228:     if (currentUser == null) return null;
229:     return FirebaseFirestore.instance
230:         .collection('chats')
231:         .where('participants', arrayContains: currentUser.uid)
232:         .orderBy('lastMessageTime', descending: true)
233:         .snapshots();
234:   }
235:   Widget _buildChatSliver(User? currentUser) {
236:     if (currentUser == null) {
237:       return const SliverFillRemaining(child: EmptyChatState());
238:     }
239:     return StreamBuilder<QuerySnapshot>(
240:       stream: _getChatStream(currentUser),
241:       builder: (context, snapshot) {
242:         if (snapshot.connectionState == ConnectionState.waiting) {
243:           return SliverList(
244:             delegate: SliverChildBuilderDelegate(
245:                   (context, index) => _buildLoadingItem(),
246:               childCount: 6,
247:             ),
248:           );
249:         }
250:         if (snapshot.hasError) {
251:           return const SliverFillRemaining(
252:             child: Center(child: Text('Something went wrong')),
253:           );
254:         }
255:         final docs = snapshot.data?.docs.where((doc) {
256:           if (_searchQuery.isEmpty) return true;
257:           if (_matchedUserIds.isEmpty) return false;
258:           final participants =
259:           List<String>.from(doc['participants'] ?? []);
260:           return participants.any(_matchedUserIds.contains);
261:         }).toList() ?? [];
262:         if (docs.isEmpty) {
263:           return const SliverFillRemaining(
264:             hasScrollBody: false,
265:             child: EmptyChatState(),
266:           );
267:         }
268:         return SliverList(
269:           delegate: SliverChildBuilderDelegate((context, index) {
270:             final data = docs[index].data() as Map<String, dynamic>;
271:             final chatId = docs[index].id;
272:             return ChatTile(
273:               chatId: chatId,
274:               data: data,
275:               currentUserId: currentUser.uid,
276:               index: index,
277:               onTap: () {
278:                 final participants =
279:                 List<String>.from(data['participants'] ?? []);
280:                 final friendUid = participants.firstWhere(
281:                       (uid) => uid != currentUser.uid,
282:                   orElse: () => '',
283:                 );
284:                 if (friendUid.isEmpty) return;
285:                 FirebaseFirestore.instance
286:                     .collection('users')
287:                     .doc(friendUid)
288:                     .get()
289:                     .then((doc) {
290:                   if (doc.exists && context.mounted) {
291:                     final friendData = doc.data() as Map<String, dynamic>;
292:                     Navigator.of(context).push(
293:                       MaterialPageRoute(
294:                         builder: (_) => ChatScreen(
295:                           chatId: chatId,
296:                           friendUid: friendUid,
297:                           friendUsername:
298:                           friendData['username'] ?? 'Unknown',
299:                         ),
300:                       ),
301:                     );
302:                   }
303:                 });
304:               },
305:             );
306:           }, childCount: docs.length),
307:         );
308:       },
309:     );
310:   }
311: }
312: class AnimatedBuilder2 extends StatelessWidget {
313:   final Animation<double> animation;
314:   final Widget Function(BuildContext context, Widget? child) builder;
315:   final Widget? child;
316:   const AnimatedBuilder2({
317:     super.key,
318:     required this.animation,
319:     required this.builder,
320:     this.child,
321:   });
322:   @override
323:   Widget build(BuildContext context) {
324:     return AnimatedBuilder3(
325:       listenable: animation,
326:       builder: builder,
327:       child: child,
328:     );
329:   }
330: }
331: class AnimatedBuilder3 extends AnimatedWidget {
332:   final Widget Function(BuildContext context, Widget? child) builder;
333:   final Widget? child;
334:   const AnimatedBuilder3({
335:     super.key,
336:     required super.listenable,
337:     required this.builder,
338:     this.child,
339:   });
340:   @override
341:   Widget build(BuildContext context) {
342:     return builder(context, child);
343:   }
344: }
````
