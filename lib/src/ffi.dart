import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

const String _libName = 'stockfish';

final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final int Function() nativeInit = _dylib
    .lookup<NativeFunction<Int32 Function()>>('stockfish_init')
    .asFunction();

final int Function() nativeMain = _dylib
    .lookup<NativeFunction<Int32 Function()>>('stockfish_main')
    .asFunction();

final int Function(Pointer<Utf8>) nativeStdinWrite = _dylib
    .lookup<NativeFunction<IntPtr Function(Pointer<Utf8>)>>(
        'stockfish_stdin_write')
    .asFunction();

final Pointer<Utf8> Function() nativeStdoutRead = _dylib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>('stockfish_stdout_read')
    .asFunction();
