import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Fills all available space with stars that fly from left to right,
/// and spin.
class RewardsMeterStars extends StatefulWidget {
  const RewardsMeterStars({
    Key? key,
    this.starCount = 50,
    this.starMinRadius = 3,
    this.starMaxRadius = 10,
  }) : super(key: key);

  /// The number of flying stars at any given time.
  final int starCount;

  /// The outer-radius of the smallest star in the system.
  final double starMinRadius;

  /// The outer-radius of the largest star in the system.
  final double starMaxRadius;

  @override
  _RewardsMeterStarsState createState() => _RewardsMeterStarsState();
}

class _RewardsMeterStarsState extends State<RewardsMeterStars>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late StarParticleSystem _starSystem;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _starSystem = StarParticleSystem(
      starCount: widget.starCount,
      minRadius: widget.starMinRadius,
      maxRadius: widget.starMaxRadius,
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsedTime) {
    _starSystem.update(elapsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarSystemPainter(_starSystem),
      size: Size.infinite,
    );
  }
}

/// A particle system filled with [StarParticle]s, where the stars
/// are born near the left side, fly towards the right side, and
/// then die.
class StarParticleSystem with ChangeNotifier {
  StarParticleSystem({
    required this.starCount,
    required this.minRadius,
    required this.maxRadius,
  });

  /// The number of stars to maintain in the system.
  ///
  /// When one star dies, another star is born.
  final int starCount;

  /// The smallest possible outer-radius for a star.
  final double minRadius;

  /// The largest possible outer-radius for a star.
  final double maxRadius;

  /// All the stars in the system.
  final stars = <StarParticle>[];

  /// Tells this particle system how much space is available for
  /// the star particles, which is used to decide where to generate
  /// stars, and when a star moves off-screen.
  set canvasSize(Size canvasSize) => _canvasSize = canvasSize;
  late Size _canvasSize;

  Duration _lastTickTime = Duration.zero;
  bool _isInitialized = false;

  /// Initialize the particle system, which generates the first generation
  /// of star particles.
  ///
  /// Does nothing if the system is already initialized.
  void init() {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    _lastTickTime = Duration.zero;

    for (int i = 0; i < starCount; i += 1) {
      stars.add(_generateStar(_canvasSize));
    }
  }

  /// Updates all the particles in the system based on the change
  /// in time since the last update.
  void update(Duration elapsedTime) {
    final dt = elapsedTime - _lastTickTime;
    _lastTickTime = elapsedTime;

    if (!_isInitialized) {
      return;
    }

    // Traverse in reverse order so that we can remove dead stars
    // as we go.
    for (int i = stars.length - 1; i >= 0; i -= 1) {
      stars[i].tick(dt);
      if (stars[i].offset.dx - stars[i].radius > _canvasSize.width) {
        stars.removeAt(i);
      }
    }

    // Fill the system back up with the desired number of stars.
    for (int i = stars.length; i <= starCount; i += 1) {
      stars.add(_generateStar(_canvasSize));
    }

    notifyListeners();
  }

  StarParticle _generateStar(Size canvasSize) {
    final random = Random();
    return StarParticle(
      offset: Offset(-_canvasSize.width * random.nextDouble(),
          canvasSize.height * random.nextDouble()),
      velocity: Offset(
          lerpDouble(canvasSize.width / 10, canvasSize.width / 5,
              random.nextDouble())!,
          0),
      rotation: 2 * pi * random.nextDouble(),
      radialVelocity: lerpDouble((pi / 8), (pi / 4), random.nextDouble())!,
      radius: lerpDouble(minRadius, maxRadius, random.nextDouble())!,
      color: Color.lerp(starDark, starBright, random.nextDouble())!,
    );
  }
}

Color starDark = Colors.yellow[800]!;
Color starBright = Colors.yellow[300]!;
Color trackGold = Colors.yellow[200]!;

/// Particle that represents a star.
class StarParticle {
  StarParticle({
    required this.offset,
    required this.velocity,
    required this.rotation,
    required this.radialVelocity,
    required this.radius,
    required this.color,
  });

  /// The (x,y) position of the particle in the system.
  Offset offset;

  /// The velocity of the particle.
  final Offset velocity;

  /// The rotation of the particle, in radians.
  double rotation;

  /// The radial velocity of the particle, in radians per second.
  final double radialVelocity;

  /// The outer radius of the star.
  final double radius;

  /// The color of the star.
  final Color color;

  /// Updates the physical state of the star, moving the [offset] by
  /// [velocity], and rotating the [rotation] by [radialVelocity].
  void tick(Duration dt) {
    final dtInSeconds = dt.inMilliseconds / 1000;
    offset += velocity * dtInSeconds;
    rotation += radialVelocity * dtInSeconds;
  }
}

/// Paints a [StarParticleSystem].
class StarSystemPainter extends CustomPainter {
  StarSystemPainter(
    this.starSystem,
  ) : super(repaint: starSystem);

  /// The [StarParticleSystem] that this painter paints.
  final StarParticleSystem starSystem;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..clipRect(Offset.zero & size);

    starSystem.canvasSize = size;

    // Initialize the star system, if it's not already initialized
    starSystem.init();

    // Paint the background
    canvas.drawPaint(Paint()..color = trackGold);

    // Paint the stars
    final stars = starSystem.stars;
    for (final star in stars) {
      final starPath = StarPathTemplate.fivePoints(star.radius);

      canvas
        ..save()
        ..translate(star.offset.dx, star.offset.dy)
        ..rotate(star.rotation)
        ..drawPath(
          starPath.toPath(),
          Paint()..color = star.color,
        )
        ..restore();
    }

    // Release the clipping bounds.
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Repaint happens whenever the particle system reports a change.
    return false;
  }
}

/// Creates a [Path] to draw a start with the given [pointCount],
/// [outerRadius], and [innerRadius].
///
/// To draw a traditional 5-point star, use the [fivePoints] constructor.
class StarPathTemplate {
  /// Creates a [StarPathTemplate] that generates a traditional 5-point
  /// star with the given [outerRadius].
  StarPathTemplate.fivePoints(this.outerRadius)
      : pointCount = 5,
        innerRadius = outerRadius * 0.5;

  StarPathTemplate({
    required this.pointCount,
    required this.outerRadius,
    required this.innerRadius,
  });

  /// The number of corner points in the star.
  final int pointCount;

  /// The distance from the center of the star to a corner point.
  final double outerRadius;

  /// The distance from the center of the start to an inner point.
  final double innerRadius;

  /// Generates a [Path] that draws a star, as configured by [pointCount],
  /// [outerRadius], and [innerRadius].
  Path toPath() {
    const startAngle = -pi / 2;
    final angleIncrement = 2 * pi / (2 * pointCount);

    final starPath = Path()
      ..moveTo(
        outerRadius * cos(startAngle),
        outerRadius * sin(startAngle),
      );
    for (int i = 1; i < 2 * pointCount; i += 2) {
      starPath
        ..lineTo(
          innerRadius * cos(startAngle + (i * angleIncrement)),
          innerRadius * sin(startAngle + (i * angleIncrement)),
        )
        ..lineTo(
          outerRadius * cos(startAngle + ((i + 1) * angleIncrement)),
          outerRadius * sin(startAngle + ((i + 1) * angleIncrement)),
        );
    }
    starPath.close();

    return starPath;
  }
}
