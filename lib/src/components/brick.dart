import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Brick extends BodyComponent with ContactCallbacks {
  final Vector2 _position;
  final Vector2 _size;
  final Color _color;

  bool shouldRemove = false;

  Brick(this._position, this._size, this._color);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: _size.x,
        height: _size.y,
      ),
      Paint()..color = _color,
    );
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(_size.x / 2, _size.y / 2);
    final fixtureDef = FixtureDef(shape, friction: 0.3, restitution: 1);
    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic
      ..fixedRotation = true
      ..gravityOverride = Vector2.zero();
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
