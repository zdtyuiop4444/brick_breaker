import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Bat extends BodyComponent with ContactCallbacks {
  final Vector2 _batSize;
  final Vector2 _batPosition;
  final Radius _cornerRadius;

  Bat(this._batSize, this._cornerRadius, this._batPosition);

  bool isMoveLeft = false;
  bool isMoveRight = false;
  bool isMoveUp = false;
  bool isMoveDown = false;
  bool isTurnLeft = false;
  bool isTurnRight = false;

  final _paint = Paint()
    ..color = const Color(0xff1e6091)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Offset(-_batSize.x / 2, -_batSize.y / 2) & _batSize.toSize(),
          _cornerRadius),
      _paint,
    );
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(_batSize.x / 2, _batSize.y / 2);
    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.9
      ..friction = 0.3;
    final bodyDef = BodyDef()
      ..userData = this
      ..position = _batPosition
      ..type = BodyType.dynamic
      ..fixedRotation = false
      ..gravityOverride = Vector2.zero();
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
