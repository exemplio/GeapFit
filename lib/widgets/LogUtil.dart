// ignore_for_file: file_names

class LogUtil {
  static const _isDebug = true;
  static const int _limitLength = 800;

  // static void init({String title, @required bool isDebug,int limitLength}) {
  //   _title = title;
  //   _isDebug = isDebug;
  //   _limitLength = limitLength??=_limitLength;
  //   _startLine = "$_split$_title$_split";
  //   var endLineStr = StringBuffer();
  //   var cnCharReg = RegExp("[\u4e00-\u9fa5]");
  //   for (int i = 0; i < _startLine.length; i++) {
  //     if (cnCharReg.stringMatch(_startLine[i]) != null) {
  //       endLineStr.write(_separator);
  //     }
  //     endLineStr.write(_separator);
  //   }
  //   _endLine = endLineStr.toString();
  // }

  //仅Debug模式可见
  static void d(dynamic obj) {
    if (_isDebug) {
      _log(obj.toString());
    }
  }

  static void v(dynamic obj) {
    _log(obj.toString());
  }

  static void _log(String msg) {
    //print("$_startLine");
    _logEmpyLine();
    if (msg.length < _limitLength) {
      //  print(msg);
    } else {
      segmentationLog(msg);
    }
    _logEmpyLine();
    // print("$_endLine");
  }

  static void segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % _limitLength == 0 && index != 0) {
        // print(outStr);
        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < _limitLength) {
          //  print(remainderStr);
          break;
        }
      }
    }
  }

  static void _logEmpyLine() {
    // print("");
  }
}
