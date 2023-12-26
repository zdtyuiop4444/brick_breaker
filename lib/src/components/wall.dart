import 'package:flame_forge2d/flame_forge2d.dart';

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;
  final double _friction;

  Wall(this._start, this._end, this._friction);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: _friction, restitution: 0.5);
    final bodyDef = BodyDef(
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
