// A class to describe a group of Particles
// An List is used to manage the list of Particles

import 'package:flutter_animations/maths_meet_flutter/fire_simulations/particle.dart';
import 'package:flutter_processing/flutter_processing.dart';

class ParticleSystem {
  late List<Particle> particles; // An List for all the particles
  late final PVector origin; // An origin point for where particles are birthed
  PImage img;

  ParticleSystem(int num, PVector origin, this.img) {
    this.origin = origin.copy();
    particles = <Particle>[]; // Initialize the List
    for (int i = 0; i < num; i++) {
      particles.add(Particle(origin, img)); // Add "num" amount of particles to the List
    }
  }

  void run(Sketch sketch) {
    // for (var i = 0; i < particles.length; i++) {
    //   Particle p = particles[i];
    //   if (p.isDead()) {
    //     particles.removeAt(i);
    //   } else {
    //     p.run(sketch);
    //   }
    // }
    for (int i = particles.length - 1; i >= 0; i--) {
      Particle p = particles[i];
      p.run(sketch);
      if (p.isDead()) {
        particles.removeAt(i);
      }
    }
  }

  // Method to add a force vector to all particles currently in the system
  void applyForce(PVector dir) {
    // Enhanced loop!!!
    for (Particle p in particles) {
      p.applyForce(dir);
    }
  }

  void addParticle() {
    particles.add(Particle(origin, img));
  }
}
