# Chapter 19 - Entity Framework - Xây dựng hệ thống Entity cho Game

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- BaseEntity
- HeroEntity
- MonsterEntity
- EntityId
- EntityRegistry
- EntityFactory
- Component Container
- Entity Lifecycle
- Spawn & Destroy Flow

Đây là chương đầu tiên chúng ta tạo ra những đối tượng thật sự trong game.

Sau chương này.

Hero và Monster sẽ chính thức xuất hiện.

---

# Entity là gì?

Trong game.

Mọi vật thể đều có thể được xem là Entity.

Ví dụ.

```
Hero
```

```
Monster
```

```
NPC
```

```
Chest
```

```
Projectile
```

```
Pet
```

```
Boss
```

```
Treasure
```

Toàn bộ đều là Entity.

---

# Entity KHÔNG phải Component

Một sai lầm rất phổ biến.

```
HeroComponent
```

Chính là Hero.

Không.

Trong kiến trúc của chúng ta.

```
HeroEntity

↓

HeroComponent
```

Entity là Gameplay.

Component là Render.

---

# Entity nằm ở đâu?

Kiến trúc.

```text
Game

↓

World

↓

Entity

↓

Components

↓

Render
```

World quản lý Entity.

Entity quản lý dữ liệu.

Component hiển thị.

---

# Entity chỉ chứa dữ liệu?

Không hoàn toàn.

Entity có thể chứa.

```
Identity
```

```
Component Container
```

```
State
```

Nhưng.

Không chứa Gameplay.

Gameplay nằm trong.

```
Systems
```

---

# BaseEntity

Mọi Entity đều kế thừa.

```
BaseEntity
```

Ví dụ.

```
HeroEntity
```

```
MonsterEntity
```

```
ChestEntity
```

```
BossEntity
```

Không tạo mỗi Entity theo cách riêng.

---

# Entity ID

Mỗi Entity phải có.

```
EntityId
```

Ví dụ.

```
hero_001
```

```
monster_120
```

Hoặc.

```
UUID
```

Không nên.

```
Hero1

Hero2

Hero3
```

---

# Vì sao cần Entity ID?

Ví dụ.

Quest.

```
Kill Monster
```

↓

```
Monster ID
```

Save.

↓

```
Entity ID
```

Network.

↓

```
Entity ID
```

Replay.

↓

```
Entity ID
```

Entity ID được dùng ở rất nhiều nơi.

---

# HeroEntity

Hero chỉ là.

```
Entity

+

Hero Components
```

Ví dụ.

```
Stat
```

```
Health
```

```
Skill
```

```
Inventory
```

Không có Animation.

Không có Sprite.

---

# MonsterEntity

Tương tự.

```
Entity

↓

Health

↓

Stat

↓

AI

↓

Drop
```

Gameplay xử lý Monster.

Render không nằm ở đây.

---

# Entity Components

Đừng nhầm với.

```
Flame Component
```

Ở đây.

Component nghĩa là.

```
Data Component
```

Ví dụ.

```
HealthComponent
```

```
StatComponent
```

```
TransformComponent
```

Đây chỉ là dữ liệu.

---

# Health Component

Ví dụ.

```
HP

100
```

```
Max HP

150
```

Không có.

```
Draw HP Bar
```

---

# Stat Component

Ví dụ.

```
Attack
```

```
Defense
```

```
Speed
```

```
Critical Rate
```

BattleSystem sẽ đọc.

Không sửa trực tiếp.

---

# Transform Component

Transform chứa.

```
Position
```

```
Rotation
```

```
Scale
```

Gameplay làm việc với Transform.

Component Render chỉ hiển thị.

---

# State Component

Một Entity luôn có State.

Ví dụ.

```
Idle
```

```
Moving
```

```
Attack
```

```
Dead
```

BattleSystem sẽ thay đổi State.

---

# Entity Registry

World sẽ không lưu.

```
List<Component>
```

World lưu.

```
Entity Registry
```

Ví dụ.

```text
Registry

↓

Hero

↓

Monster

↓

Projectile

↓

Chest
```

Registry biết toàn bộ Entity.

---

# Vì sao cần Registry?

Ví dụ.

BattleSystem cần.

```
Find Monster
```

AI cần.

```
Nearest Hero
```

Quest cần.

```
Monster Count
```

Registry sẽ cung cấp.

Không cần duyệt toàn bộ World.

---

# Entity Factory

Không nên.

```dart
HeroEntity()

MonsterEntity()
```

Khắp project.

Chúng ta tạo.

```
EntityFactory
```

Ví dụ.

```
Create Hero
```

↓

```
HeroEntity
```

```
Create Monster
```

↓

```
MonsterEntity
```

Factory giúp.

Khởi tạo thống nhất.

---

# Spawn Flow

Khi Spawn.

```text
EntityFactory

↓

HeroEntity

↓

Registry

↓

World

↓

Component

↓

Render
```

Toàn bộ đều tự động.

---

# Destroy Flow

Khi Monster chết.

```text
BattleSystem

↓

MonsterDeadEvent

↓

Registry Remove

↓

Remove Component

↓

Release Pool
```

Không xóa trực tiếp.

---

# Entity Lifecycle

Một Entity sẽ trải qua.

```text
Create

↓

Spawn

↓

Active

↓

Dead

↓

Destroy

↓

Release
```

Đây là Lifecycle chuẩn.

---

# Alive và Active

Hai khái niệm khác nhau.

```
Alive
```

Là.

```
Chưa chết
```

```
Active
```

Là.

```
Được Update
```

Ví dụ.

Monster ngủ.

```
Alive

✔

Active

✘
```

---

# Enable / Disable

Không nên Destroy.

Nếu chỉ muốn tạm ẩn.

```
Entity

↓

Disable
```

Sau này.

```
Enable
```

Điều này nhanh hơn.

---

# Entity Tags

Một Entity có thể có.

```
Hero
```

```
Boss
```

```
Flying
```

```
Elite
```

System sẽ lọc.

Theo Tag.

---

# Entity Groups

Ví dụ.

```
Monster
```

↓

```
Slime
```

↓

```
Boss
```

↓

```
Projectile
```

Registry có thể trả về.

Theo Group.

---

# Query Entity

BattleSystem.

```
Find

↓

All Monster
```

AI.

```
Find

↓

Nearest Hero
```

Quest.

```
Find

↓

Dead Monster
```

Registry chịu trách nhiệm Query.

---

# Entity không biết System

Sai.

```
HeroEntity

↓

BattleSystem
```

Entity không biết.

System nào đang tồn tại.

Đây là nguyên tắc rất quan trọng.

---

# Gameplay Flow

Ví dụ.

```text
BattleSystem

↓

Hero HP -=20

↓

Health Component

↓

MonsterDeadEvent

↓

Registry

↓

Destroy
```

Entity không tự chết.

Battle quyết định.

---

# Save Entity

Save.

```
Entity

↓

Model

↓

JSON
```

Không Serialize.

```
Render Component
```

---

# Entity và Flame Component

Hai thứ khác nhau.

```text
HeroEntity

↓

Gameplay Data

↓

HeroComponent

↓

Sprite

↓

Screen
```

Đây là kiến trúc xuyên suốt series.

---

# Entity Pool

Projectile.

```
Spawn

↓

Destroy

↓

Spawn

↓

Destroy
```

Không tạo mới.

Hãy kết hợp.

```
Entity Pool
```

↓

```
Reuse
```

---

# Kiến trúc Entity

Sau chương này.

```text
World

↓

Entity Registry

↓

Entities

↓

Data Components

↓

Systems

↓

Render Components
```

Gameplay hoàn toàn tách khỏi Render.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ BaseEntity

✅ HeroEntity

✅ MonsterEntity

✅ EntityId

✅ EntityFactory

✅ EntityRegistry

✅ HealthComponent

✅ StatComponent

✅ TransformComponent

✅ StateComponent

---

# Sai lầm phổ biến

## Sai lầm 1

Gameplay nằm trong Entity.

Gameplay phải nằm trong System.

---

## Sai lầm 2

Entity kế thừa Flame Component.

Hai khái niệm này độc lập.

---

## Sai lầm 3

Không có Entity ID.

Sau này Save và Network sẽ rất khó.

---

## Sai lầm 4

Tạo Entity bằng `new` khắp nơi.

Hãy sử dụng EntityFactory.

---

## Sai lầm 5

World tự quản lý từng Hero và Monster.

Hãy để EntityRegistry làm việc đó.

---

# Tổng kết

Đây là chương đánh dấu sự xuất hiện của những "thực thể" đầu tiên trong game.

Từ bây giờ, mọi đối tượng trong Gameplay đều sẽ là **Entity**.

Kiến trúc của chúng ta sẽ là:

- **Entity** chứa dữ liệu.
- **System** xử lý Gameplay.
- **Component (Flame)** chịu trách nhiệm Render.
- **EntityRegistry** quản lý toàn bộ Entity.
- **EntityFactory** tạo Entity.
- **EntityId** định danh duy nhất.

Việc tách Entity khỏi Flame Component giúp Gameplay hoàn toàn độc lập với Engine, dễ kiểm thử, dễ mở rộng và sẵn sàng cho Multiplayer hoặc Replay trong tương lai.

---

# Chương tiếp theo

Ở **Chương 20**, chúng ta sẽ xây dựng **Component Framework**.

Đây là cầu nối giữa Gameplay và Flame.

Bạn sẽ học cách xây dựng:

- BaseGameComponent.
- HeroComponent.
- MonsterComponent.
- ComponentFactory.
- Entity ↔ Component Binding.
- Animation Sync.
- State Sync.
- Auto Spawn và Auto Destroy.

Sau chương này, HeroEntity và MonsterEntity sẽ chính thức xuất hiện trên màn hình.