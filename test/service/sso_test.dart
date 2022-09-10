import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/global/global.dart';
import 'package:kite/mock/index.dart';
import 'package:kite_request_interface/kite_request_interface.dart';

void main() async {
  await init();
  await login();
  var session = Global.ssoSession;
  test('test login', () async {
    final index = await session.request('https://myportal.sit.edu.cn/', RequestMethod.get);
    final list = BeautifulSoup(index.data)
        .find('div', class_: 'composer')!
        .findAll('li')
        .map((e) => e.text.trim().replaceAll('\n', '').replaceAll(' ', ''))
        .toList();
    expect(list[0].contains('姓名'), true);
  });
  test('get person name', () async {
    final name = await LoginInitializer.authServerService.getPersonName();
    print('姓名: $name');
  });
}
