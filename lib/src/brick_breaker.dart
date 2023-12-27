import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';

class BrickBreaker extends Forge2DGame with KeyboardEvents, DragCallbacks {
  double get width => size.x;
  double get height => size.y;
  Bat bat = Bat(Vector2(batWidth, batHeight), const Radius.circular(ballRadius),
      Vector2(gameWidth / 2, gameHeight * 3 / 4));

  MouseJoint? mouseJoint;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2(gameWidth / 2, gameHeight / 2);
    camera.viewfinder.zoom = height / gameHeight > width / gameWidth
        ? width / gameWidth
        : height / gameHeight;
    world.gravity = Vector2(0, 98);

    world.add(PlayArea());
    world.add(Wall(Vector2.zero(), Vector2(gameWidth, 0), 0.3));
    world.add(Wall(Vector2.zero(), Vector2(0, gameHeight), 0.3));
    world.add(Wall(Vector2(gameWidth, 0), Vector2(gameWidth, gameHeight), 0.3));
    world
        .add(Wall(Vector2(0, gameHeight), Vector2(gameWidth, gameHeight), 0.3));
    world.add(Ball(ballRadius, Vector2(gameWidth / 2, gameHeight / 4)));
    world.add(bat);
    await world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            Vector2(brickWidth, brickHeight),
            brickColors[i],
          ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bat.isTurnLeft || bat.isTurnRight) {
      bat.body.setFixedRotation(false);
      if (bat.isTurnLeft && bat.body.angularVelocity <= 0) {
        bat.body.applyAngularImpulse(-batSpeed / 180 * bat.body.inertia);
      }
      if (bat.isTurnRight && bat.body.angularVelocity >= 0) {
        bat.body.applyAngularImpulse(batSpeed / 180 * bat.body.inertia);
      }
    } else {
      bat.body.angularVelocity = 0;
      bat.body.setFixedRotation(true);
    }
    if (bat.isMoveLeft || bat.isMoveRight) {
      if (bat.isMoveLeft && bat.body.linearVelocity.x >= -batSpeed) {
        bat.body
            .applyLinearImpulse(Vector2(-batSpeed * bat.body.mass * 1.5, 0));
      }
      if (bat.isMoveRight && bat.body.linearVelocity.x <= batSpeed) {
        bat.body.applyLinearImpulse(Vector2(batSpeed * bat.body.mass * 1.5, 0));
      }
    } else {
      bat.body.applyLinearImpulse(
          Vector2(-bat.body.linearVelocity.x * bat.body.mass, 0));
    }
    if (bat.isMoveUp || bat.isMoveDown) {
      if (bat.isMoveUp && bat.body.linearVelocity.y >= -batSpeed) {
        bat.body.applyLinearImpulse(Vector2(0, -batSpeed * bat.body.mass));
      }
      if (bat.isMoveDown && bat.body.linearVelocity.y <= batSpeed) {
        bat.body.applyLinearImpulse(Vector2(0, batSpeed * bat.body.mass));
      }
    } else {
      bat.body.applyLinearImpulse(
          Vector2(0, -bat.body.linearVelocity.y * bat.body.mass));
    }
    for (final brick in world.children.query<Brick>()) {
      if (brick.shouldRemove) {
        world.remove(brick);
      }
    }
  }

  @override
  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        world.children.query<Bat>().first.isMoveLeft = event is RawKeyDownEvent;
        break;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        world.children.query<Bat>().first.isMoveRight =
            event is RawKeyDownEvent;
        break;
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        world.children.query<Bat>().first.isMoveUp = event is RawKeyDownEvent;
        break;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        world.children.query<Bat>().first.isMoveDown = event is RawKeyDownEvent;
        break;
      case LogicalKeyboardKey.keyQ:
        world.children.query<Bat>().first.isTurnLeft = event is RawKeyDownEvent;
        break;
      case LogicalKeyboardKey.keyE:
        world.children.query<Bat>().first.isTurnRight =
            event is RawKeyDownEvent;
        break;
      default:
    }
    return KeyEventResult.handled;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final mouseJointDef = MouseJointDef()
      ..maxForce = 3000 * bat.body.mass * 10
      ..dampingRatio = 0.1
      ..frequencyHz = 5
      ..target.setFrom(bat.body.position)
      ..collideConnected = false
      ..bodyA = world.children.query<Wall>().first.body
      ..bodyB = bat.body;

    if (mouseJoint == null) {
      mouseJoint = MouseJoint(mouseJointDef);
      world.createJoint(mouseJoint!);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    mouseJoint?.setTarget((event.localEndPosition - Vector2(width / 2, 0)) /
            camera.viewfinder.zoom +
        Vector2(gameWidth / 2, 0));
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    world.destroyJoint(mouseJoint!);
    mouseJoint = null;
  }
}
