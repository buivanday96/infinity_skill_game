# Unity-like Particle System Specification for Flutter Flame

## Objective

Implement a reusable particle system for **Flutter Flame** that reproduces the behavior of a Unity Particle System with the following configuration.

The implementation must be modular, extensible, and suitable for use in a 2D auto-battle game.

---

# Target Framework

* Flutter
* Flame
* Dart

---

# Architecture

The particle system should be composed of independent modules.

```text
ParticleSystem
 ├── Emitter
 ├── Particle
 ├── EmissionModule
 ├── VelocityModule
 ├── SizeOverLifetimeModule
 ├── ColorOverLifetimeModule
 ├── RotationModule
 ├── RendererModule
 └── LifetimeModule
```

Every module should be replaceable without modifying the others.

---

# Particle Settings

## Emission

### Rate Over Time

```
3 particles / second
```

Spawn particles continuously.

Do NOT spawn all particles at once.

---

# Velocity

Use Linear Velocity.

```
X = 0
Y = 1.31
```

The particle should move upward.

Velocity should remain constant during its lifetime.

---

# Lifetime

Each particle should have:

```
lifetime = configurable
```

Normalized lifetime:

```dart
t = age / lifetime
```

Where

```
0 = spawned
1 = dead
```

Every module should use this normalized value.

---

# Size Over Lifetime

Support Unity-like animation curve.

The system must NOT hardcode linear scaling.

Instead expose:

```dart
abstract class SizeCurve {
  double evaluate(double t);
}
```

Example implementation:

```
Spawn
↓

Grow

↓

Shrink

↓

Disappear
```

Example curve

```
Scale

0
↓

0.5

↓

0
```

Scale must always be clamped between

```
Min = 0
Max = 0.5
```

---

# Color Over Lifetime

Support Unity Gradient.

The implementation should interpolate colors over normalized lifetime.

Expose something similar to:

```dart
class GradientStop {
  final double time;
  final Color color;
}
```

Example

```
0.0 -> Yellow

0.5 -> Orange

1.0 -> Transparent
```

Color interpolation should be smooth.

---

# Rotation

Allow Roll

Each particle should have

```
Initial Rotation = Random

Angular Velocity = Random
```

Example

```dart
angle += angularVelocity * dt;
```

Particles should rotate independently.

---

# Billboard

The renderer should always face the screen.

Since Flame is a 2D engine this simply means:

* Sprite always rendered normally.
* No perspective rotation.
* Rotation only comes from Allow Roll.

---

# Renderer

Blend Mode

Unity Shader

```
Mobile/Particles/Additive
```

Equivalent Flame implementation

```dart
Paint()
  ..blendMode = BlendMode.plus;
```

This should produce additive glowing particles.

---

# Texture

Support

```
PNG

Sprite

Sprite Sheet
```

Texture should be configurable.

---

# Particle Update

Each update

```dart
age += dt;

t = age / lifetime;

position += velocity * dt;

scale = sizeCurve.evaluate(t);

color = gradient.evaluate(t);

angle += angularVelocity * dt;
```

Particle dies when

```dart
age >= lifetime
```

---

# Emission Update

Use accumulator.

Pseudo

```dart
accumulator += dt * emissionRate;

while (accumulator >= 1) {

    spawnParticle();

    accumulator--;

}
```

This guarantees

```
3 particles / second
```

independent of FPS.

---

# Performance Requirements

The implementation should

* avoid allocations every frame
* reuse particle objects (object pooling)
* support hundreds of particles simultaneously
* minimize garbage collection
* separate simulation from rendering

---

# API Example

Desired API

```dart
ParticleEmitter(
    emissionRate: 3,

    velocity: ConstantVelocity(
        Vector2(0, 1.31),
    ),

    sizeCurve: UnityCurve(
        min: 0,
        max: 0.5,
    ),

    colorGradient: Gradient(
        [
            GradientStop(0, Colors.yellow),
            GradientStop(0.5, Colors.orange),
            GradientStop(1, Colors.transparent),
        ],
    ),

    blendMode: BlendMode.plus,

    allowRoll: true,
);
```

---

# Coding Style

* SOLID principles
* Clean Architecture
* Reusable modules
* Strong typing
* No magic numbers
* Fully documented
* Easily extensible for future Unity modules

---

# Future Modules (Do Not Implement Yet)

Design the architecture so these can be added later without refactoring.

* Color by Speed
* Velocity over Lifetime
* Force over Lifetime
* Noise
* Limit Velocity
* Texture Sheet Animation
* Trails
* Collision
* Lights
* Sub Emitters
* External Forces
* Custom Data
* Shape Module
* Burst Emission

The architecture should closely resemble Unity's Particle System module design while remaining idiomatic for Flutter Flame.
