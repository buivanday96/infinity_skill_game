# Battle Effects System Specification (Flutter Flame)

## Overview

Thiết kế một hệ thống Battle Effects có hiệu năng cao dành cho game Flutter Flame.

Mục tiêu:

- Không tạo/destroy Component liên tục.
- Có thể hiển thị hàng nghìn Damage Text mỗi phút.
- Dễ mở rộng cho:
  - Damage
  - Critical
  - Heal
  - Miss
  - Dodge
  - EXP
  - Gold
  - Shield
  - Buff/Debuff
- Battle logic hoàn toàn tách biệt với phần hiển thị hiệu ứng.
- Tuân theo kiến trúc Component của Flame.
- Dễ tái sử dụng cho các project khác.

---

# Architecture

```
BattleWorld
│
├── HeroManager
├── EnemyManager
├── ProjectileManager
├── BattleEffectManager
│      │
│      ├── DamageTextManager
│      │       │
│      │       └── DamageTextPool
│      │
│      ├── ParticleManager
│      ├── CameraShakeManager
│      ├── ScreenFlashManager
│      └── SoundEffectManager
│
└── UI
```

Battle logic KHÔNG được spawn DamageText trực tiếp.

Đúng:

```
Enemy
↓

BattleEvent

↓

BattleEffectManager

↓

DamageTextManager

↓

DamageTextPool

↓

DamageTextComponent
```

Sai:

```
Enemy

↓

world.add(DamageText())
```

---

# Folder Structure

```
battle/
    managers/
        battle_effect_manager.dart
        damage_text_manager.dart

    pool/
        damage_text_pool.dart

    components/
        damage_text_component.dart

    models/
        damage_text_data.dart
        battle_effect_event.dart

    enums/
        damage_type.dart

    effects/
        damage_text_animation.dart
```

---

# DamageType

```dart
enum DamageType {
  normal,
  critical,
  heal,
  poison,
  burn,
  miss,
  dodge,
  shield,
  mana,
  exp,
  gold,
}
```

---

# DamageTextData

```dart
class DamageTextData {
  final String text;

  final DamageType type;

  final Vector2 worldPosition;

  final double delay;

  final bool randomOffset;

  const DamageTextData({
    required this.text,
    required this.type,
    required this.worldPosition,
    this.delay = 0,
    this.randomOffset = true,
  });
}
```

Không truyền Color hoặc Font.

Style phải được quyết định bởi DamageType.

---

# DamageTextComponent

Một component chỉ có nhiệm vụ hiển thị.

Không biết Battle Logic.

Không biết Hero.

Không biết Enemy.

Responsibilities:

- render text
- animation
- opacity
- scale
- remove callback

Public API

```dart
show(DamageTextData data);

hide();

reset();
```

---

# DamageTextPool

## Purpose

Pool tái sử dụng DamageTextComponent.

Không new Component liên tục.

---

## Public API

```dart
DamageTextComponent obtain();

void release(DamageTextComponent component);
```

---

## Internal

```
List<DamageTextComponent> _available

Set<DamageTextComponent> _using
```

---

Nếu pool hết:

```
create new

↓

add vào using
```

Khi animation kết thúc:

```
release()

↓

remove effect

↓

clear text

↓

opacity = 1

↓

visible = false

↓

đưa về available
```

---

# DamageTextManager

Manager chịu trách nhiệm spawn DamageText.

Không render.

Không animation.

Không biết Battle Logic.

Chỉ quản lý lifecycle.

---

Public API

```dart
showDamage(DamageTextData data);

showCritical(...)

showHeal(...)

showGold(...)

showExp(...)

clear();

dispose();
```

---

Implementation

```
showDamage()

↓

pool.obtain()

↓

component.show()

↓

world.add(component)
```

---

# BattleEffectManager

Đây là manager trung tâm.

Battle Logic chỉ giao tiếp với manager này.

---

Public API

```dart
showDamage(...);

showHeal(...);

showMiss(...);

showGold(...);

showExp(...);

playHitEffect(...);

cameraShake(...);

playSound(...);
```

Ví dụ:

```dart
battleEffectManager.showDamage(
    amount: 120,
    target: enemy,
);
```

BattleEffectManager sẽ quyết định:

```
Damage

↓

DamageTextManager

↓

Particle

↓

Camera

↓

Sound
```

---

# Damage Animation

Normal

```
Spawn

↓

Move Up

↓

Fade

↓

Destroy
```

Critical

```
Spawn

↓

Scale 0.6

↓

Scale 1.4

↓

Move Up

↓

Shake

↓

Fade
```

Heal

```
Spawn

↓

Green

↓

Float Up

↓

Fade
```

Gold

```
Spawn

↓

Move to UI Gold Icon

↓

Disappear
```

EXP

```
Spawn

↓

Curve Animation

↓

UI EXP Bar
```

---

# Style Mapping

Không hardcode.

Tạo một class:

```
DamageTextStyleResolver
```

Ví dụ

```
DamageType.normal

↓

white
size 18
```

```
DamageType.critical

↓

yellow

size 30
bold
```

```
DamageType.heal

↓

green
```

```
DamageType.gold

↓

orange
```

---

# Random Offset

Để tránh chồng chữ.

Ví dụ

```
Enemy

       123

   95

          250

      88
```

Offset khoảng:

```
x

-10~10

y

-5~5
```

---

# Queue

Nếu cùng lúc có 50 damage:

Không spawn cùng frame.

Cho delay ngẫu nhiên.

Ví dụ

```
0ms

↓

15ms

↓

30ms

↓

45ms

↓

60ms
```

Animation đẹp hơn.

---

# Object Pool Rules

Pool KHÔNG BAO GIỜ remove component.

Pool chỉ:

```
Hide

↓

Reuse
```

Không:

```
Destroy

↓

Create

↓

Destroy

↓

Create
```

---

# Performance Goals

Có thể hiển thị:

- 200 enemies
- 500 damage text cùng lúc
- 60 FPS

Không tạo garbage lớn.

---

# Extensibility

Sau này có thể thêm:

- Combo Counter
- Floating Icon
- Status Effect
- Buff
- Debuff
- Critical Explosion
- Combo Text
- Level Up
- Quest Progress
- Achievement
- Item Drop

Mà không sửa Battle Logic.

---

# Event Flow

```
Enemy.takeDamage()

↓

DamageCalculator

↓

BattleResult

↓

BattleEffectManager

├── DamageTextManager
├── ParticleManager
├── CameraShakeManager
├── SoundManager
└── UIManager
```

---

# Design Principles

- Single Responsibility Principle
- Dependency Injection
- Object Pool Pattern
- Manager Pattern
- Event Driven
- Data Driven
- Open/Closed Principle
- Zero Battle/UI Coupling
- Reusable giữa nhiều game
- Dễ unit test
- Dễ mở rộng animation
- Tối ưu cho mobile với hàng trăm hiệu ứng đồng thời