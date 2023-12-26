import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'bat.dart';
import 'brick.dart';

class Ball extends BodyComponent with ContactCallbacks {
  final double _radius;
  final Vector2 _position;

  Ball(this._radius, this._position);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
        Offset.zero,
        _radius,
        paint = Paint()
          ..color = const Color(0xff1e6091)
          ..style = PaintingStyle.fill);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is Bat) {
      body.applyLinearImpulse(Vector2(other.body.linearVelocity.x * body.mass,
          (60 + other.body.linearVelocity.y) * body.mass));
    }
  }

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    super.postSolve(other, contact, impulse);
    if (other is Brick && impulse.normalImpulses.first > 0.5) {
      other.shouldRemove = true;
    }
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = _radius;
    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.9
      ..friction = 0.5;
    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.dynamic
      ..bullet = true;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
