import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

// Define FFI type signatures for Kyber functions
typedef KyberKeypairFunc = ffi.Int32 Function(ffi.Pointer<ffi.Uint8> pk, ffi.Pointer<ffi.Uint8> sk);
typedef KyberKeypairFuncDart = int Function(ffi.Pointer<ffi.Uint8> pk, ffi.Pointer<ffi.Uint8> sk);

typedef KyberEncFunc = ffi.Int32 Function(ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> pk);
typedef KyberEncFuncDart = int Function(ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> pk);

typedef KyberDecFunc = ffi.Int32 Function(ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> sk);
typedef KyberDecFuncDart = int Function(ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> sk);

// Define FFI type signatures for Falcon functions
typedef FalconSignFunc = ffi.Int32 Function(ffi.Pointer<ffi.Uint8> sig, ffi.Pointer<ffi.Uint8> siglen, ffi.Pointer<ffi.Uint8> m, ffi.Size mlen, ffi.Pointer<ffi.Uint8> sk);
typedef FalconSignFuncDart = int Function(ffi.Pointer<ffi.Uint8> sig, ffi.Pointer<ffi.Uint8> siglen, ffi.Pointer<ffi.Uint8> m, int mlen, ffi.Pointer<ffi.Uint8> sk);

typedef FalconVerifyFunc = ffi.Int32 Function(ffi.Pointer<ffi.Uint8> sig, ffi.Size siglen, ffi.Pointer<ffi.Uint8> m, ffi.Size mlen, ffi.Pointer<ffi.Uint8> pk);
typedef FalconVerifyFuncDart = int Function(ffi.Pointer<ffi.Uint8> sig, int siglen, ffi.Pointer<ffi.Uint8> m, int mlen, ffi.Pointer<ffi.Uint8> pk);

class CryptoFFIHelper {
  static final ffi.DynamicLibrary _kyberLib = _loadLibrary('pqcrystals_kyber768_ref');
  static final ffi.DynamicLibrary _falconLib = _loadLibrary('falcon');

  // Load the dynamic library based on the platform and library name
  static ffi.DynamicLibrary _loadLibrary(String libraryName) {
    var libraryPath = path.join(Directory.current.path, 'libs', 'arm64-v8a', 'lib$libraryName.so');

    if (Platform.isMacOS) {
      libraryPath = path.join(Directory.current.path, 'libs', 'arm64-v8a', 'lib$libraryName.dylib');
    } else if (Platform.isWindows) {
      libraryPath = path.join(Directory.current.path, 'libs', 'arm64-v8a', '$libraryName.dll');
    }

    return ffi.DynamicLibrary.open(libraryPath);
  }

  // Expose Kyber functions
  static int kyberKeypair(ffi.Pointer<ffi.Uint8> pk, ffi.Pointer<ffi.Uint8> sk) {
    final KyberKeypairFuncDart kyberKeypair = _kyberLib
        .lookup<ffi.NativeFunction<KyberKeypairFunc>>('pqcrystals_kyber768_ref_keypair')
        .asFunction();
    return kyberKeypair(pk, sk);
  }

  static int kyberEnc(ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> pk) {
    final KyberEncFuncDart kyberEnc = _kyberLib
        .lookup<ffi.NativeFunction<KyberEncFunc>>('pqcrystals_kyber768_ref_enc')
        .asFunction();
    return kyberEnc(ct, ss, pk);
  }

  static int kyberDec(ffi.Pointer<ffi.Uint8> ss, ffi.Pointer<ffi.Uint8> ct, ffi.Pointer<ffi.Uint8> sk) {
    final KyberDecFuncDart kyberDec = _kyberLib
        .lookup<ffi.NativeFunction<KyberDecFunc>>('pqcrystals_kyber768_ref_dec')
        .asFunction();
    return kyberDec(ss, ct, sk);
  }

  // Expose Falcon functions
  static int falconSign(ffi.Pointer<ffi.Uint8> sig, ffi.Pointer<ffi.Uint8> siglen, ffi.Pointer<ffi.Uint8> m, int mlen, ffi.Pointer<ffi.Uint8> sk) {
    final FalconSignFuncDart falconSign = _falconLib
        .lookup<ffi.NativeFunction<FalconSignFunc>>('PQCLEAN_FALCON512_CLEAN_crypto_sign_signature')
        .asFunction();
    return falconSign(sig, siglen, m, mlen, sk);
  }

  static int falconVerify(ffi.Pointer<ffi.Uint8> sig, int siglen, ffi.Pointer<ffi.Uint8> m, int mlen, ffi.Pointer<ffi.Uint8> pk) {
    final FalconVerifyFuncDart falconVerify = _falconLib
        .lookup<ffi.NativeFunction<FalconVerifyFunc>>('PQCLEAN_FALCON512_CLEAN_crypto_sign_verify')
        .asFunction();
    return falconVerify(sig, siglen, m, mlen, pk);
  }
}
