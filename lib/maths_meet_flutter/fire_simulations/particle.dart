// A simple Particle class, renders the particle as an image

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_processing/flutter_processing.dart' as fp;

class Particle {
  late final PVector loc;
  final PImage img;
  late final PVector vel;
  late final PVector acc;
  late double lifespan;

  Particle(PVector loc, this.img) {
    this.loc = loc.copy();
    acc = PVector(0, 0);
    double vx = fp.Sketch().randomGaussian() * 0.3;
    double vy = fp.Sketch().randomGaussian() * 0.3 - 1.0;
    vel = PVector(vx, vy);
    lifespan = 100;
  }

  void run(Sketch sketch) {
    update();
    render(sketch);
  }

  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void applyForce(PVector f) {
    acc.add(f);
  }

  // Method to update position
  void update() {
    lifespan -= 2.5;
    if (lifespan < 0) {
      lifespan = 0;
      return;
    }
    vel.add(acc);
    loc.add(vel);
    acc.mult(0); // clear Acceleration
  }

  // Method to display
  void render(Sketch sketch) async {
    // imageMode(CENTER);
    // tint(255, lifespan);
    final alpha = (((lifespan) / 100) * 255).toInt();
    // sketch.tint(   Color.fromARGB(alpha, 255, 255, 255));

    sketch.image(
      image: img,
      alpha: alpha,
      origin: Offset(
        loc.x.toDouble(),
        loc.y.toDouble(),
      ),
    );

    // Drawing a circle instead
    // fill(255,lifespan);
    // noStroke();
    // ellipse(loc.x,loc.y,img.width,img.height);
  }

  // Is the particle still useful?
  bool isDead() {
    return lifespan < 0.0;
  }
}
