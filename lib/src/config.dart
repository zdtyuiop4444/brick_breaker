import 'package:flutter/material.dart'; // Add this import

const brickColors = [
  // Add this const
  Color(0xfff94144),
  Color(0xfff3722c),
  Color(0xfff8961e),
  Color(0xfff9844a),
  Color(0xfff9c74f),
  Color(0xff90be6d),
  Color(0xff43aa8b),
  Color(0xff4d908e),
  Color(0xff277da1),
  Color(0xff577590),
];

const gameWidth = 54.0;
const gameHeight = 85.0;
const ballRadius = gameWidth * 0.02;
const batWidth = gameWidth * 0.3;
const batHeight = gameHeight * 0.03;
const batSpeed = 30.0;
const brickGutter = gameWidth * 0.015; // Add from here...
final brickWidth =
    (gameWidth - (brickGutter * (brickColors.length + 1))) / brickColors.length;
const brickHeight = gameHeight * 0.03;
const difficultyModifier = 1.03;
