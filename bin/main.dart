import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

  server.listen((request) async {
    if (
      request.headers
          .toString()/* DEV_NOTE # 'chrome-extension://YOUR_EXTENSION_ID' */
          .contains('chrome-extension://emjonidloclomfejbnegoalmifhhohgg')
    ){
      final websocket = await WebSocketTransformer.upgrade(request);
      websocket.add( jsonEncode( {'text': 'pong'} ) );
      websocket.listen((message) {
        final inboundMessage = jsonDecode(message);
          print(inboundMessage["text"]);
      });
    } else {
      // DEV_NOTE # [server] is rather an instance of [Http], than [WebSocket]
      request.response.statusCode = HttpStatus.badRequest;
      request.response.write('Request not a WebSocket upgrade');
      await request.response.close();
    }
  });

  print('listening on port ${server.port}');
}
