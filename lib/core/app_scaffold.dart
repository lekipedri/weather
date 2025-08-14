import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // biar AppBar transparan
      appBar: AppBar(
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(color: Colors.white),
              )
            : null,
        actions: actions,
        backgroundColor: Colors.transparent, // transparan
        elevation: 0, // hilangkan bayangan
      ),
      floatingActionButton: floatingActionButton,
      backgroundColor: Colors.transparent, // scaffold transparan
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bgimage.png"), // Ganti dengan gambar kamu
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: body,
        ),
      ),
    );
  }
}
