library kite_ocr;

import 'package:kite_request_interface/kite_request_interface.dart';

class OcrRecognizeException implements Exception {
  final int code;
  final String msg;

  const OcrRecognizeException(this.code, this.msg);
}

class OcrService extends AService {
  static const _ocrServerUrl = 'https://kite.sunnysab.cn/api/ocr/captcha';

  OcrService(super.session);

  Future<String> recognize(String imageBase64) async {
    final response = await session.request(
      _ocrServerUrl,
      RequestMethod.post,
      data: imageBase64,
    );
    final result = response.data;
    final code = result['code'];
    if (code == 0) {
      return result['data'];
    } else {
      throw OcrRecognizeException(code, result['msg']);
    }
  }
}
