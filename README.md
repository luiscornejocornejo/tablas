# Tablas de Multiplicar — App para Primaria

App educativa en **Flutter** para enseñar las tablas de multiplicar del **1 al 12** a niños de primaria.

## Características

- **12 tablas interactivas**: elige un número y explora su tabla completa (×1 hasta ×12).
- **Modo práctica**: preguntas aleatorias con puntuación y racha de aciertos.
- **Práctica por tabla**: desde cada tabla puedes practicar solo ese número.
- **Vista general**: consulta las 12 tablas en una sola pantalla.
- **Diseño infantil**: colores vivos, tipografía Fredoka/Nunito y botones grandes.

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.8+

## Ejecutar

```bash
flutter pub get
flutter run
```

### Web

```bash
flutter run -d chrome
```

### Android

```bash
flutter run -d android
```

## Estructura

```
lib/
├── main.dart                 # Punto de entrada
├── theme/app_theme.dart      # Colores y tema
├── screens/
│   ├── home_screen.dart      # Menú principal
│   ├── table_screen.dart     # Tabla individual
│   ├── practice_screen.dart  # Modo práctica
│   └── all_tables_screen.dart# Todas las tablas
└── widgets/
    ├── table_card.dart       # Tarjeta de selección
    └── multiplication_row.dart # Fila de multiplicación
```

## Tests

```bash
flutter test
```
