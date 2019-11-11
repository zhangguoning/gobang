
import 'dart:async';

import 'dart:convert';

import 'dart:typed_data';

class SocketDecoder implements StreamTransformer<Uint8List,String>{

  final Utf8Decoder _utf8Decoder = utf8.decoder;
  SocketDecoder();

  @override
  Stream<String> bind(Stream<Uint8List> stream) {
    return _utf8Decoder.bind(stream);
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return _utf8Decoder.cast();
  }
}