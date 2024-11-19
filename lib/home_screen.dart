import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener las dimensiones de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlue[100], // Fondo celeste
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // 5% de la anchura de la pantalla
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen con altura proporcional
              Image.asset(
                'assets/images/Logo.png',
                height: screenHeight * 0.15, // 15% de la altura de la pantalla
                fit: BoxFit.contain, // Ajusta la imagen proporcionalmente
              ),
              SizedBox(height: screenHeight * 0.03), // Espacio entre elementos
              Text(
                'Nombre de la App',
                style: TextStyle(
                  fontSize: screenWidth * 0.07, // 7% de la anchura de la pantalla
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Espacio entre elementos
              Text(
                'Carrera: Ingeniería en Software',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'Materia: Programación Móvil',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'Grupo: B',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'Nombre del alumno: Andrés Guízar Gómez',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              Text(
                'Matrícula: 213360',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              SizedBox(height: screenHeight * 0.03), // Espacio antes del enlace
              GestureDetector(
                onTap: () {
                  // Enlace al repositorio
                },
                child: Text(
                  'Repositorio GitHub',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Espacio antes del botón
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: Text(
                  'Chat de Voz',
                  style: TextStyle(fontSize: screenWidth * 0.05),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.2, // Ancho del botón proporcional
                    vertical: screenHeight * 0.02, // Altura del botón proporcional
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
