import 'package:flutter/material.dart';

import 'package:spritewidget/spritewidget.dart';
import 'package:digital_clock/handler/cloud_layer.dart';

// Rain layer. Uses three layers of particle systems, to create a parallax rain effect.
class Rain extends Node {
  final SpriteSheet sprites;

  Rain(this.sprites) {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = new ParticleSystem(sprites['raindrop.png'],
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 1000.0 / distance,
        speedVar: 100.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.2 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 1.5 * distance,
        lifeVar: 1.0 * distance);
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 10.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(new MotionTween<double>((a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(new MotionTween<double>((a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}

// Snow. Uses 9 particle systems to create a parallax effect of snow at different distances.
class Snow extends Node {
  final SpriteSheet sprites;

  Snow(this.sprites) {
    _addParticles(sprites['flake-0.png'], 1.0);
    _addParticles(sprites['flake-1.png'], 1.0);
    _addParticles(sprites['flake-2.png'], 1.0);

    _addParticles(sprites['flake-3.png'], 1.5);
    _addParticles(sprites['flake-4.png'], 1.5);
    _addParticles(sprites['flake-5.png'], 1.5);

    _addParticles(sprites['flake-6.png'], 2.0);
    _addParticles(sprites['flake-7.png'], 2.0);
    _addParticles(sprites['flake-8.png'], 2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = new ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 150.0 / distance,
        speedVar: 50.0 / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 20.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 2.0,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance);
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(new MotionTween<double>((a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(new MotionTween<double>((a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}

class Cloud extends Node {
  List<CloudLayer> _clouds = <CloudLayer>[];

  final ImageMap images;

  Cloud(this.images) {
//     Then three layers of clouds, that will be scrolled in parallax.
    _clouds.add(CloudLayer(
        image: images['assets/images/clouds-0.png'],
        rotated: false,
        dark: false,
        loopTime: 20.0,
        onlyTop: true));
    _clouds[0].active = false;
    addChild(_clouds[0]);

    _clouds.add(CloudLayer(
        image: images['assets/images/clouds-1.png'],
        rotated: true,
        dark: true,
        loopTime: 40.0,
        onlyTop: true));
    _clouds[0].active = false;
    addChild(_clouds[1]);

    _clouds.add(CloudLayer(
        image: images['assets/images/clouds-1.png'],
        rotated: false,
        dark: false,
        loopTime: 60.0,
        onlyTop: true));
    _clouds[0].active = false;
    addChild(_clouds[2]);
  }

  set active(bool active) {
    motions.stopAll();
    for (CloudLayer cloud in _clouds) {
      cloud.active = active;
    }
  }
}

class Wind extends Node {
  final SpriteSheet sprites;

  Wind(this.sprites) {
    _addRainParticles(1.0);
    _addRainParticles(1.5);
    _addRainParticles(2);
    _addRainParticles(1);
    _addRainParticles(1.5);
    _addRainParticles(2);
    _addRainParticles(1.0);
    _addRainParticles(1.5);
    _addRainParticles(2);

    _addSnowParticles(sprites['flake-0.png'], 1);
    _addSnowParticles(sprites['flake-1.png'], 1);
    _addSnowParticles(sprites['flake-2.png'], 1);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addRainParticles(double distance) {
    ParticleSystem particles = new ParticleSystem(sprites['raindrop.png'],
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 10000.0 / distance,
        speedVar: 1000.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.2 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 1.5 * distance,
        lifeVar: 1.0 * distance);
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 10.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  void _addSnowParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = new ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 500.0 / distance,
        speedVar: 300.0 / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 20.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 2.0,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance);
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(new MotionTween<double>((a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(new MotionTween<double>((a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}
