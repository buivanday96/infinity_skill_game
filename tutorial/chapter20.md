# Chapter 20 - Component Framework - Kết nối Gameplay với Flame

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- BaseGameComponent
- HeroComponent
- MonsterComponent
- ComponentFactory
- ComponentRegistry
- Entity ↔ Component Binding
- State Synchronization
- Animation Synchronization
- Spawn & Destroy Pipeline

Đây là chương đánh dấu thời điểm game bắt đầu "sống".

Nếu chương trước chúng ta tạo ra Entity.

Thì chương này sẽ giúp Entity xuất hiện trên màn hình.

---

# Gameplay và Render là hai thế giới khác nhau

Đây là kiến trúc quan trọng nhất.

```text
Gameplay

↓

Entity

↓

Binding

↓

Flame Component

↓

Screen
```

Entity không biết Flame.

Flame cũng không biết Gameplay.

---

# Component là gì?

Trong series này.

Có hai loại Component.

## Data Component

```
HealthComponent
```

```
StatComponent
```

```
TransformComponent
```

Chỉ chứa dữ liệu.

---

## Render Component

```
HeroComponent
```

```
MonsterComponent
```

```
ProjectileComponent
```

Đây là Flame Component.

Chỉ dùng để hiển thị.

---

# BaseGameComponent

Mọi Render Component đều kế thừa.

```
BaseGameComponent
```

Ví dụ.

```
HeroComponent
```

```
MonsterComponent
```

```
ProjectileComponent
```

Toàn bộ dùng chung Lifecycle.

---

# BaseGameComponent làm gì?

Nó chịu trách nhiệm.

- Render
- Animation
- Hiệu ứng
- Đồng bộ với Entity

Không xử lý Gameplay.

---

# Component không chứa HP

Sai.

```dart
HeroComponent.hp--;
```

Đúng.

```text
BattleSystem

↓

HeroEntity.hp--

↓

HeroComponent

↓

Update UI
```

Component chỉ đọc dữ liệu.

---

# Entity Binding

Mỗi Component.

Chỉ gắn với.

```
Một Entity
```

Ví dụ.

```text
HeroEntity

↓

HeroComponent
```

Nếu Entity bị Destroy.

Component cũng biến mất.

---

# Binding Flow

```text
Entity

↓

ComponentFactory

↓

GameComponent

↓

World

↓

Render
```

Đây là Flow cố định.

---

# Component Factory

Không nên.

```dart
HeroComponent()

MonsterComponent()
```

Khắp project.

Hãy dùng.

```
ComponentFactory
```

Ví dụ.

```
Create Hero

↓

HeroComponent
```

---

# Component Registry

Ngoài Entity Registry.

Chúng ta còn có.

```
Component Registry
```

Quản lý.

```
HeroComponent
```

```
MonsterComponent
```

```
ProjectileComponent
```

Để dễ tìm kiếm.

---

# Synchronization

Mỗi Frame.

```text
Entity

↓

Sync

↓

Component

↓

Render
```

Gameplay luôn đi trước.

Render theo sau.

---

# Position Sync

Ví dụ.

```
HeroEntity

Position

(100,200)
```

↓

```
HeroComponent

Position

(100,200)
```

Component không tự Move.

---

# Rotation Sync

Tương tự.

```
Entity Rotation

↓

Component Rotation
```

Gameplay quyết định.

Render hiển thị.

---

# Scale Sync

Ví dụ.

```
Hero Buff

↓

Scale =1.5
```

Component nhận.

```
Scale

1.5
```

Không tự tính.

---

# Animation Sync

Một sai lầm phổ biến.

```dart
HeroComponent.playAttack()
```

BattleSystem.

Không nên.

Đúng.

```
Hero State

↓

Attack

↓

Component

↓

Play Attack Animation
```

Animation dựa trên State.

---

# State Synchronization

Entity.

```
Idle
```

↓

Component.

```
Idle Animation
```

Entity.

```
Run
```

↓

```
Run Animation
```

Entity.

```
Dead
```

↓

```
Dead Animation
```

Không gọi Animation trực tiếp.

---

# Sprite không biết Gameplay

Sprite chỉ biết.

```
Frame

Animation

Texture
```

Không biết.

```
HP

Skill

EXP
```

---

# Flip Animation

Ví dụ.

Hero đi trái.

Gameplay.

```
Direction

Left
```

↓

Component.

```
FlipX=true
```

Đây chỉ là Render.

---

# Shadow

Hero có.

```
ShadowComponent
```

Gameplay không biết.

Shadow.

Không có HP.

Không có AI.

---

# HP Bar

HP Bar cũng là Component.

```
HeroEntity

↓

Health

↓

HP Bar Component
```

BattleSystem không Update HP Bar.

---

# Damage Text

BattleSystem.

↓

```
DamageEvent
```

↓

Component.

↓

```
Floating Text
```

Gameplay không Spawn Text.

---

# Effect Component

Ví dụ.

```
Critical Hit
```

↓

```
Critical Effect
```

↓

```
Destroy
```

Đây là Component tạm thời.

---

# Projectile Component

Projectile.

```
Entity

↓

ProjectileComponent
```

ProjectileComponent.

Không tính Damage.

BattleSystem tính Damage.

---

# Camera Visibility

Nếu Component.

Ngoài Camera.

```
Skip Render
```

Gameplay vẫn hoạt động.

---

# Layer

Component được thêm vào.

```text
Background

↓

Monster

↓

Hero

↓

Effect

↓

UI
```

Không Add lung tung.

---

# Spawn Flow

Khi Spawn Hero.

```text
EntityFactory

↓

HeroEntity

↓

ComponentFactory

↓

HeroComponent

↓

World

↓

Render
```

Mọi thứ tự động.

---

# Destroy Flow

Monster chết.

```text
BattleSystem

↓

MonsterDeadEvent

↓

Entity Destroy

↓

Component Remove

↓

Animation Finish

↓

Release
```

Không Remove ngay lập tức.

Có thể chờ Animation chết.

---

# Component Lifecycle

Mỗi Component.

```text
Create

↓

Load Sprite

↓

Added

↓

Update

↓

Render

↓

Removed

↓

Dispose
```

Toàn bộ Component đều giống nhau.

---

# Không tạo Component trong Battle

Sai.

```dart
BattleSystem

↓

HeroComponent()
```

Battle không biết Flame.

Battle chỉ tạo.

```
HeroEntity
```

Factory tự xử lý Component.

---

# Entity và Component luôn tách biệt

Kiến trúc.

```text
HeroEntity

↓

Binding

↓

HeroComponent
```

Không kế thừa nhau.

Không import lẫn nhau.

---

# Component Pool

Hiệu ứng.

```
Explosion
```

↓

Pool.

↓

Reuse.

Không tạo mới.

---

# Debug Component

Developer Mode.

Có thể bật.

```
Bounding Box
```

```
Entity ID
```

```
Current State
```

```
FPS
```

Giúp Debug rất dễ.

---

# Kiến trúc hoàn chỉnh

Sau chương này.

```text
Entity

↓

Component Factory

↓

Game Component

↓

Camera

↓

Render Layer

↓

Screen
```

Gameplay.

Không biết.

Render.

Render.

Không biết.

Gameplay.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ BaseGameComponent

✅ HeroComponent

✅ MonsterComponent

✅ ComponentFactory

✅ ComponentRegistry

✅ Entity Binding

✅ Animation Sync

✅ Position Sync

✅ Destroy Pipeline

---

# Sai lầm phổ biến

## Sai lầm 1

BattleSystem gọi Animation.

Battle chỉ đổi State.

---

## Sai lầm 2

Component chứa Gameplay.

Component chỉ Render.

---

## Sai lầm 3

Entity kế thừa SpriteComponent.

Hai tầng hoàn toàn độc lập.

---

## Sai lầm 4

Không đồng bộ State.

Animation sẽ sai.

---

## Sai lầm 5

Destroy Component ngay.

Nên chờ.

```
Death Animation
```

Kết thúc.

---

# Tổng kết

Sau chương này, chúng ta đã xây dựng được cầu nối giữa Gameplay và Flame.

Kiến trúc hoàn chỉnh là:

- **Entity** chứa dữ liệu Gameplay.
- **System** xử lý Logic.
- **ComponentFactory** tạo Render Component.
- **BaseGameComponent** quản lý hiển thị.
- **Animation** được đồng bộ từ State.
- **Position**, **Rotation** và **Scale** được đồng bộ từ Entity.
- **Component** không chứa Gameplay.

Đây là một kiến trúc rất phổ biến trong các game thương mại vì nó giúp Gameplay độc lập hoàn toàn với Engine và Render.

---

# Chương tiếp theo

Ở **Chương 21**, chúng ta sẽ xây dựng **Movement System**.

Đây sẽ là Gameplay đầu tiên của game.

Bạn sẽ học cách xây dựng:

- Transform System.
- Velocity.
- Acceleration.
- Direction.
- Character Controller.
- Path Following.
- Collision Movement.
- Camera Follow.

Sau chương này, Hero sẽ có thể di chuyển thật sự trên bản đồ.