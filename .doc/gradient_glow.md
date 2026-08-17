# Implement Unity Gradient Evaluation for Flutter Flame

## Objective

Implement a **Unity-compatible Gradient** class for Flutter Flame that reproduces the behavior of Unity's `Gradient.Evaluate()`.

The implementation should support importing Unity Particle System gradients without manually rewriting them.

---

# Target Framework

* Flutter
* Flame
* Dart

---

# Requirements

The implementation must behave like Unity.

Unity stores:

* Color Keys
* Alpha Keys

independently.

The final color is produced by interpolating both separately and combining them.

---

# Data Model

## Color Key

```dart
class ColorKey {
  final double time;
  final Color color;
}
```

Time is normalized

```text
0.0 → 1.0
```

---

## Alpha Key

```dart
class AlphaKey {
  final double time;
  final double alpha;
}
```

Alpha

```text
0.0 → 1.0
```

---

## Gradient

```dart
class UnityGradient {

    final List<ColorKey> colorKeys;

    final List<AlphaKey> alphaKeys;

    Color evaluate(double t);

}
```

---

# Unity Import

Unity YAML stores time as

```text
0 → 65535
```

Convert using

```dart
time = unityTime / 65535.0;
```

---

# Example Unity Gradient

```yaml
Color Keys

key0
time = 4241

RGB
0
1
0.6242826

----------------

key1

time = 13300

RGB
0
0.8210938
1

----------------

key2

time = 21203

RGB
1
0.78442526
0
```

Alpha Keys

```yaml
atime0 = 386
alpha = 0.39215687

atime1 = 4626
alpha = 0.9305556

atime2 = 35659
alpha = 0
```

---

# Evaluation Algorithm

When

```dart
evaluate(t)
```

is called

the implementation must

## Step 1

Find the surrounding Color Keys

```text
ColorKey A

↓

ColorKey B
```

Interpolate RGB

```dart
Color.lerp()
```

---

## Step 2

Find the surrounding Alpha Keys

```text
AlphaKey A

↓

AlphaKey B
```

Interpolate alpha

```dart
lerpDouble()
```

---

## Step 3

Combine

```text
RGB

+

Alpha

↓

Final Color
```

---

# Boundary Rules

If

```text
t <= first key
```

Return first value.

If

```text
t >= last key
```

Return last value.

---

# Interpolation

Use linear interpolation.

Do NOT use easing.

Behavior must match Unity's Gradient.

---

# Performance

The implementation should

* avoid allocations
* avoid creating temporary lists
* work efficiently every frame
* be suitable for hundreds of particles

---

# API

Desired usage

```dart
final gradient = UnityGradient(
  colorKeys: [
    ColorKey(
      0.0647,
      const Color(0xFF00FF9F),
    ),

    ColorKey(
      0.2029,
      const Color(0xFF00D1FF),
    ),

    ColorKey(
      0.3235,
      const Color(0xFFFFC800),
    ),
  ],

  alphaKeys: [
    AlphaKey(
      0.0059,
      0.392,
    ),

    AlphaKey(
      0.0706,
      0.931,
    ),

    AlphaKey(
      0.544,
      0,
    ),
  ],
);
```

Retrieve color

```dart
final color = gradient.evaluate(t);
```

Where

```text
t

0.0 → 1.0
```

---

# Additional Utility

Also implement

```dart
UnityGradient.fromUnityYaml(...)
```

or

```dart
UnityGradient.fromJson(...)
```

that converts Unity Particle System gradient data into the runtime object.

The parser should:

* normalize Unity time (0–65535 → 0.0–1.0)
* convert RGB floats (0–1) to Flutter `Color`
* convert alpha values (0–1)
* ignore unused keys
* automatically sort keys by time if necessary

---

# Coding Style

* SOLID principles
* Immutable models
* Fully documented
* Null-safe
* Strong typing
* No magic numbers
* Production-ready

---

# Goal

The final implementation should reproduce Unity's `Gradient.Evaluate()` as closely as possible so Unity Particle System gradients can be imported and rendered in Flutter Flame with minimal or no manual adjustments.
