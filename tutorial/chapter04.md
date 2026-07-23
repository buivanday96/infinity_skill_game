# Chapter 4 - Component System - Mọi thứ trong Flame đều là Component

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Component là gì
- Vì sao Flame sử dụng Component
- Lifecycle của Component
- Cây Component (Component Tree)
- Parent và Child
- Khi nào nên tạo Component
- Khi nào KHÔNG nên tạo Component
- Kiến trúc Component chúng ta sẽ dùng trong toàn bộ series

Đây là chương quan trọng thứ hai sau Game Loop.

Nếu hiểu Component System, bạn sẽ có thể xây dựng một game có hàng trăm hoặc hàng nghìn object mà vẫn dễ quản lý.

---

# Component là gì?

Trong Flutter chúng ta có:

```text
Widget
```

Trong Flame chúng ta có:

```text
Component
```

Mọi thứ trong game đều có thể là một Component.

Ví dụ:

- Hero
- Monster
- Projectile
- Background
- Camera
- Health Bar
- Floating Text
- Skill Button
- Particle
- Effect

Nếu một đối tượng cần xuất hiện trong game, rất có thể nó sẽ là một Component.

---

# Component không phải Widget

Đây là điều khiến rất nhiều Flutter Developer nhầm lẫn.

Trong Flutter:

```text
Widget

↓

build()

↓

Widget mới

↓

build()

↓

Widget mới
```

Widget liên tục được rebuild.

---

Trong Flame.

```text
Component

↓

Update

↓

Update

↓

Update

↓

Render

↓

Render

↓

Remove
```

Component được tạo một lần.

Sau đó tồn tại trong game cho đến khi bị xoá.

Đây là lý do Flame có thể quản lý hàng nghìn object hiệu quả.

---

# Một Hero là một Component

Ví dụ.

```dart
class HeroComponent extends PositionComponent {

}
```

Hero này sẽ tồn tại trong game.

Nó có:

- Position
- Size
- Angle
- Scale

và được Game Loop cập nhật liên tục.

---

# Component Tree

Flame quản lý Component theo dạng cây.

Ví dụ.

```text
DungeonGame

│

├── WorldComponent

│      │

│      ├── HeroComponent

│      ├── HeroComponent

│      ├── MonsterComponent

│      ├── MonsterComponent

│      └── ProjectileComponent

│

├── UIComponent

│      │

│      ├── SkillButton

│      ├── HealthBar

│      └── FloatingText

│

└── EffectComponent
```

Đây gọi là:

```
Component Tree
```

Game chỉ cần update node gốc.

Các node con sẽ tự động được cập nhật.

---

# Parent và Child

Ví dụ.

```dart
world.add(hero);
```

Khi đó.

```text
World

↓

Hero
```

Hero trở thành child của World.

Nếu Hero có Weapon.

```dart
hero.add(weapon);
```

Ta sẽ có.

```text
World

↓

Hero

↓

Weapon
```

Nếu Hero di chuyển.

Weapon cũng sẽ di chuyển theo.

Điều này cực kỳ hữu ích.

---

# Lifecycle của Component

Một Component sẽ trải qua các bước sau.

```text
Create

↓

onLoad()

↓

onMount()

↓

update()

↓

render()

↓

update()

↓

render()

↓

remove()

↓

onRemove()
```

Đây gọi là Lifecycle.

---

# onLoad()

Được gọi một lần.

Thường dùng để:

- Load Sprite
- Load Animation
- Load Audio
- Khởi tạo dữ liệu

Ví dụ.

```dart
@override
Future<void> onLoad() async {

    sprite = await Sprite.load("hero.png");

}
```

Không nên đặt gameplay ở đây.

---

# onMount()

Được gọi khi Component được thêm vào Game.

Ví dụ.

```dart
game.add(hero);
```

Sau khi Hero thật sự xuất hiện.

```
onMount()
```

sẽ được gọi.

Thường dùng để:

- Đăng ký Event
- Lấy reference
- Khởi tạo Camera

---

# update()

Được gọi mỗi frame.

Ví dụ.

```dart
@override
void update(double dt) {

    super.update(dt);

}
```

Đây là nơi:

- Animation
- Movement
- Effect

được cập nhật.

Lưu ý.

Trong series này.

Gameplay sẽ KHÔNG nằm ở đây.

---

# render()

Nếu tự viết Component.

Bạn có thể tự vẽ.

```dart
@override
void render(Canvas canvas) {

}
```

Tuy nhiên.

Đa số trường hợp.

Bạn sẽ dùng:

```
SpriteComponent

SpriteAnimationComponent
```

nên không cần override render.

---

# remove()

Khi quái chết.

```dart
removeFromParent();
```

Monster sẽ biến mất khỏi Component Tree.

Không cần tự giải phóng.

Flame sẽ xử lý.

---

# Component chỉ nên hiển thị

Một sai lầm rất phổ biến.

```dart
HeroComponent

{

Attack()

Heal()

Buff()

Quest()

Save()

Network()

}
```

Component trở thành nơi chứa mọi thứ.

Sau vài tháng.

File sẽ rất lớn.

---

Trong series này.

Component chỉ chịu trách nhiệm:

- Sprite
- Animation
- Position
- Effect
- Input

Gameplay sẽ được xử lý ở nơi khác.

---

# Component và System

Đây là kiến trúc chúng ta sẽ sử dụng.

```text
BattleSystem

↓

Damage

↓

HeroModel

↓

HeroComponent
```

Ví dụ.

BattleSystem tính toán.

```
Hero còn

120 HP
```

Sau đó.

HeroComponent chỉ hiển thị.

```
Health Bar

=

120
```

Component không tự tính Damage.

Điều này giúp game dễ bảo trì hơn rất nhiều.

---

# Model - System - Component

Trong series này.

Chúng ta sẽ tách thành ba lớp.

```text
Data

↓

System

↓

Component
```

Ví dụ.

```
HeroModel
```

chứa.

```text
HP

Mana

Attack

Defense
```

---

BattleSystem.

```text
Attack

Heal

Buff

Damage
```

---

HeroComponent.

```text
Sprite

Animation

Position

Health Bar
```

Ba phần này hoàn toàn độc lập.

Đây là kiến trúc mà nhiều game engine hiện đại sử dụng.

---

# Component có thể chứa Component

Ví dụ.

```text
Hero

├── Sprite

├── Shadow

├── Health Bar

├── Buff Icons

└── Weapon
```

Tất cả đều là Component.

Khi Hero di chuyển.

Mọi thứ sẽ di chuyển theo.

Không cần tự tính toán vị trí.

---

# Khi nào nên tạo Component?

Một quy tắc đơn giản.

Nếu object cần:

- Hiển thị
- Có vị trí
- Có animation
- Có effect
- Có thể thêm vào Game

=> Hãy tạo Component.

Ví dụ.

- Hero
- Monster
- Bullet
- Explosion
- Damage Number

---

# Khi nào KHÔNG nên tạo Component?

Một số đối tượng không cần xuất hiện trên màn hình.

Ví dụ.

```text
BattleSystem

DamageCalculator

SkillRepository

SaveService

RandomGenerator

RewardGenerator
```

Đây không phải Component.

Đây là các Service hoặc System.

---

# Component trong dự án của chúng ta

Theo tài liệu thiết kế của dự án, các Component chính sẽ gồm: :contentReference[oaicite:0]{index=0}

```text
DungeonGame

WorldComponent

BattleComponent

HeroComponent

MonsterComponent

HealthBarComponent

FloatingTextComponent

SkillButtonComponent

EffectComponent

BackgroundComponent

CameraComponent
```

Điểm quan trọng là:

> **Every component should be lightweight.**

và

> **Do not place combat logic inside components.** :contentReference[oaicite:1]{index=1}

Đây sẽ là nguyên tắc xuyên suốt toàn bộ series.

---

# Sai lầm phổ biến

## Sai lầm 1

Đặt toàn bộ gameplay trong Component.

```dart
HeroComponent

↓

Attack

Heal

Buff

Quest

Inventory

Save
```

Đây là cách khiến project rất nhanh trở nên khó bảo trì.

---

## Sai lầm 2

Một Component làm quá nhiều việc.

Ví dụ.

```
MonsterComponent

↓

AI

↓

Animation

↓

Inventory

↓

Quest

↓

Dialogue
```

Hãy chia nhỏ thành nhiều System.

---

## Sai lầm 3

Xoá Component bằng cách đặt `null`.

Đúng.

```dart
removeFromParent();
```

Flame sẽ tự xử lý vòng đời của Component.

---

## Sai lầm 4

Tạo Component chỉ để lưu dữ liệu.

Ví dụ.

```text
SkillDatabaseComponent
```

Không nên.

Đây nên là Repository hoặc Service.

---

# Tổng kết

Component là nền tảng của Flame.

Mọi đối tượng hiển thị trên màn hình đều được biểu diễn bằng Component.

Trong series này, chúng ta sẽ tuân thủ ba nguyên tắc:

- **Model** lưu dữ liệu.
- **System** xử lý gameplay.
- **Component** hiển thị và tương tác.

Việc tách biệt ba phần này sẽ giúp game dễ mở rộng, dễ kiểm thử và tránh việc các Component trở thành những "God Object" chứa toàn bộ logic của trò chơi.

---

# Chương tiếp theo

Ở chương 5, chúng ta sẽ xây dựng **World và Camera System**.

Bạn sẽ hiểu:

- World trong Flame là gì?
- Camera hoạt động như thế nào?
- Vì sao UI không nên nằm trong World?
- Cách tổ chức Map, Hero và Monster trong cùng một không gian game.