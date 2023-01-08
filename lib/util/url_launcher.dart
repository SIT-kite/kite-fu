import 'package:url_launcher/url_launcher.dart';

import 'logger.dart';

Future<void> launchInBrowser(String url) async {
  Log.info('启动浏览器打开页面：$url');
  final uri = Uri.tryParse(url);
  if (uri == null) throw UnsupportedError('Cannot load $url');
  launchUrl(uri, mode: LaunchMode.externalApplication);
}
