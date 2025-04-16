// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get hasBiometrics async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      debugPrint('canCheck: $canCheck');
      final supported = await _auth.isDeviceSupported();
      debugPrint('supported: $supported');
      final biometrics = await _auth.getAvailableBiometrics();
      debugPrint('biometrics: $biometrics');
      return (canCheck || supported) && biometrics.isNotEmpty;
    } on PlatformException catch (e) {
      debugPrint('Error checking biometrics: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint('Error getting biometrics: $e');
      return <BiometricType>[];
    }
  }

  Future<bool> authenticateAndroid({
    required String reason,
    bool sensitiveTransaction = true,
    bool useErrorDialogs = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: '¡Acceso seguro!',
            biometricHint: 'Toca el sensor de huella',
            cancelButton: 'Volver',
            biometricNotRecognized: 'Huella no reconocida',
            biometricSuccess: '¡Éxito!',
            goToSettingsButton: 'Configurar huella',
          ),
        ],
        options: AuthenticationOptions(
          stickyAuth: true,
          sensitiveTransaction: sensitiveTransaction,
          useErrorDialogs: useErrorDialogs,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Android Authentication error: $e');
      return false;
    }
  }

  Future<bool> showAuthDialog(BuildContext context) async {
    final hasBiometrics = await this.hasBiometrics;

    if (!hasBiometrics) {
      _showMessage(context, 'No hay métodos biométricos configurados');
      return false;
    }

    final bool result;
    if (Platform.isIOS) {
      result = await authenticateIos(reason: 'Autentícate para continuar');
    } else {
      result = await authenticateAndroid(
        reason: 'Autentícate con tu huella digital',
      );
    }

    if (!result) {
      _showMessage(context, 'Autenticación fallida');
    }

    return result;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> authenticateWithTouchIdOrPasscode({
    required String reason,
    bool sensitiveTransaction = true,
  }) async {
    if (!Platform.isIOS) {
      debugPrint('Esta función es específica para iOS');
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason: reason,
        authMessages: const <AuthMessages>[
          IOSAuthMessages(
            cancelButton: 'Cancelar',
            goToSettingsButton: 'Configurar Autenticación',
            localizedFallbackTitle: 'Usar Contraseña',
            lockOut: 'Demasiados intentos fallidos',
          ),
        ],
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          sensitiveTransaction: sensitiveTransaction,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Error en autenticación Touch ID/Passcode: $e');
      return false;
    }
  }

  Future<bool> authenticateWithFaceIdOnly({
    required String reason,
    bool sensitiveTransaction = true,
  }) async {
    if (!Platform.isIOS) {
      debugPrint('Face ID solo está disponible en iOS');
      return false;
    }

    try {
      final availableBiometrics = await _auth.getAvailableBiometrics();
      if (!availableBiometrics.contains(BiometricType.face)) {
        debugPrint('Face ID no está disponible en este dispositivo');
        return false;
      }

      return await _auth.authenticate(
        localizedReason: reason,
        authMessages: const <AuthMessages>[
          IOSAuthMessages(
            cancelButton: 'Cancelar',
            goToSettingsButton: 'Configurar Face ID',
            goToSettingsDescription: 'Por favor configura Face ID en Ajustes',
            lockOut: 'Demasiados intentos fallidos',
          ),
        ],
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          sensitiveTransaction: sensitiveTransaction,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Error en autenticación Face ID: $e');
      return false;
    }
  }

  Future<bool> authenticateIos({
    required String reason,
    bool sensitiveTransaction = true,
    bool useErrorDialogs = true,
  }) async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      final hasFaceId = availableBiometrics.contains(BiometricType.face);

      if (hasFaceId) {
        final faceIdResult = await authenticateWithFaceIdOnly(
          reason: 'Autentícate con Face ID',
          sensitiveTransaction: sensitiveTransaction,
        );
        if (faceIdResult) return true;
      }
      return await authenticateWithTouchIdOrPasscode(
        reason: 'Autentícate con Touch ID o contraseña',
        sensitiveTransaction: sensitiveTransaction,
      );
    } on PlatformException catch (e) {
      debugPrint('iOS Authentication error: $e');
      return false;
    }
  }
}