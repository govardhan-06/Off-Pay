import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Global pointers for the keys
Pointer<Uint8>? publicKeyPointer;
Pointer<Uint8>? secretKeyPointer;
Pointer<Uint8>? falconPublicPointer;
Pointer<Uint8>? falconSecretPointer;
String? advertiserId;
String? recPublicKey = "0000";
String? paymentsign = "0000";
String? falconpublickey = "0000";
