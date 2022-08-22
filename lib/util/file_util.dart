import 'package:ingredients_expire_alarm/public.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// 获取文档目录
Future<String> _localfilePath() async {
  Directory tempDir = await getTemporaryDirectory();
  return tempDir.path;
}

Future<File> _localfile(String filename) async {
  // String path = await _localfilePath();
  var esdir = await getExternalStorageDirectory();
  var pullPath = path.join(esdir!.path, filename);
  // print(pullPath);
  return File(pullPath);
}

/// 保存内容到文本
Future<bool> saveFile(String filename, String val) async {
  try {
    File file = await _localfile(filename);
    IOSink sink = file.openWrite(mode: FileMode.append);
    sink.write(val);
    sink.close();

    ToastUtil.show('导出成功');
    return true;
  } catch (e) {
    // 写入错误
    ToastUtil.show(e.toString());

    return false;
  }
}
