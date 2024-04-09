import 'dart:convert';
import 'dart:io';
import 'package:ws_nmh/ws_nmh.dart' show Message;

void main() async {
  // Listen on any available IPv4 or IPv6 address port 8080
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

  server.listen((request) async {
    // spec@https://datatracker.ietf.org/doc/html/rfc6455#section-1.2
    /* final response = request.response; */
    /* response.headers.add(HttpHeaders.connectionHeader, 'Upgrade'); */
    /* response.headers.add(HttpHeaders.upgradeHeader, 'websocket'); */
    if (request.headers
          .toString()
          .contains('chrome-extension://emjonidloclomfejbnegoalmifhhohgg')
      ){
      final websocket = await WebSocketTransformer.upgrade(request);
      final outboundMessage = Message('pong');
      websocket.add(jsonEncode(outboundMessage.toJson()));
      websocket.listen((message) {
        final inboundMessage = Message.fromJson(jsonDecode(message));
        print(inboundMessage.text);
      });
    } else {
      // DEV_NOTE # [server] is rather an instance of [Http], then [WebSocket]
      request.response.statusCode = HttpStatus.badRequest;
      request.response.write('Request not a WebSocket upgrade');
      await request.response.close();
    }
  });

  print('listening on port ${server.port}');
}
