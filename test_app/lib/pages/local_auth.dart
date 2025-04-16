import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_app/service/local_auth.dart';
import 'package:test_app/widgets/scaffold.dart';


class LocalAuthScreen extends StatefulWidget {
  const LocalAuthScreen({super.key});

  @override
  State<LocalAuthScreen> createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isLoading = false;

 Future<void> _authenticate() async {
  setState(() => _isLoading = true);
  
  final bool result;
  
  if (Platform.isIOS) {
    result = await _authService.authenticateIos(
      reason: 'Mira tu dispositivo para autenticarte con Face ID',
    );
  } else if (Platform.isAndroid) {
    result = await _authService.authenticateAndroid(
      reason: 'Coloca tu dedo en el sensor de huella',
    );
  } else {
    result = false;
    setState(() => _isLoading = false);
  }
  
  setState(() {
    _isAuthenticated = result;
    _isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Autenticación Biométrica',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fingerprint,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              _isAuthenticated ? '¡Autenticado!' : 'No autenticado',
              style: TextStyle(
                fontSize: 24,
                color: _isAuthenticated ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Autenticar con Biometría'),
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() => _isAuthenticated = false);
              },
              child: const Text('Reiniciar estado'),
            ),
          ],
        ),
      ),
    );
  }
}