# Chapter 6 - Entity System - Xây dựng mọi đối tượng trong Game

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Entity là gì
- Entity khác Component như thế nào
- Hero và Monster nên được biểu diễn ra sao
- Tại sao phải tách Data khỏi UI
- Entity Lifecycle
- Kiến trúc Entity của dự án

Đây là chương đầu tiên chúng ta bắt đầu xây dựng gameplay thực sự.

Nếu Component là "hình ảnh" của một nhân vật thì Entity chính là "linh hồn" của nhân vật đó.

---

# Entity là gì?

Hãy tưởng tượng bạn có một Hero.

Người chơi nhìn thấy:

- Sprite
- Animation
- Thanh máu

Đó chỉ là phần hiển thị.

Nhưng Hero còn có rất nhiều dữ liệu khác.

Ví dụ:

- HP
- Mana
- Attack
- Defense
- Buff
- Skill
- Cooldown
- Equipment

Những dữ liệu này không nên nằm trong Component.

Chúng thuộc về Entity.

Có thể hình dung.

```
Hero

├── Data
├── Logic
└── Render
```

Trong đó.

```
Data

↓

Entity
```

```
Render

↓

Component
```

---

# Entity trong dự án

Theo thiết kế ban đầu của game, chúng ta sẽ có các Entity chính sau. :contentReference[oaicite:0]{index=0}

```
Hero

Monster

Boss
```

Hero gồm:

- Tank
- Archer
- Mage
- Healer

Monster gồm:

- Normal
- Elite
- Boss

Đây đều là các Entity trong game.

---

# Hero không phải HeroComponent

Một sai lầm rất phổ biến.

```
HeroComponent

{

HP

Attack

Defense

Skill

AI

Inventory

}
```

Mọi thứ đều nhét vào Component.

Sau vài tháng.

File sẽ dài hàng nghìn dòng.

---

Trong series này.

Chúng ta sẽ tách thành.

```
HeroModel

↓

HeroComponent
```

HeroModel lưu dữ liệu.

HeroComponent hiển thị.

---

# HeroModel

Ví dụ.

```dart
class HeroModel {

  String id;

  String name;

  int level;

  double hp;

  double maxHp;

  double mana;

  double attack;

  double defense;

}
```

Đây chỉ là dữ liệu.

Không có Sprite.

Không có Animation.

Không có Flame.

---

# HeroComponent

Ngược lại.

```dart
class HeroComponent extends SpriteAnimationComponent {

}
```

HeroComponent chỉ chịu trách nhiệm.

- Hiển thị Hero
- Chạy Animation
- Nhận vị trí
- Hiệu ứng

Không biết Hero mạnh bao nhiêu.

Không biết Damage là bao nhiêu.

---

# BattleSystem

BattleSystem sẽ là nơi kết nối hai phần.

```
HeroModel

↓

BattleSystem

↓

HeroComponent
```

Ví dụ.

```
Hero nhận 50 Damage.
```

BattleSystem.

```
HP

200

↓

150
```

Sau đó.

HeroComponent chỉ đọc.

```
150 HP
```

để cập nhật thanh máu.

---

# Entity Lifecycle

Một Hero sẽ trải qua các bước sau.

```
Create Hero

↓

Spawn

↓

Battle

↓

Receive Damage

↓

Heal

↓

Buff

↓

Death

↓

Remove
```

Điều này áp dụng cho cả Monster.

---

# Hero Spawn

Khi bắt đầu tầng mới.

```
Generate Floor

↓

Spawn Hero

↓

Spawn Monster

↓

Battle
```

Game sẽ tạo HeroModel trước.

Sau đó.

Tạo HeroComponent.

Cuối cùng thêm HeroComponent vào World.

---

# Hero Death

Khi HP bằng 0.

```
HeroModel

↓

HP = 0
```

BattleSystem thông báo.

```
HeroComponent

↓

Play Death Animation
```

Animation kết thúc.

```
removeFromParent()
```

Hero biến mất khỏi màn hình.

---

# Monster cũng giống Hero

Monster cũng sẽ có.

```
MonsterModel
```

Ví dụ.

```dart
class MonsterModel {

  double hp;

  double attack;

  double defense;

}
```

MonsterComponent.

```dart
class MonsterComponent extends SpriteAnimationComponent {

}
```

Kiến trúc hoàn toàn giống Hero.

---

# Boss cũng là Monster

Một điều rất hay.

Boss không cần một kiến trúc riêng.

```
Monster

↓

Boss
```

Boss chỉ là Monster có thêm.

- Nhiều HP
- Pattern
- Skill
- Giai đoạn chiến đấu

Điều này giúp code tái sử dụng rất nhiều.

---

# Entity và Stats

Theo tài liệu thiết kế, Hero sẽ có các chỉ số sau. :contentReference[oaicite:1]{index=1}

```
HP

Max HP

Mana

Attack

Magic Attack

Defense

Magic Defense

Attack Speed

Critical Rate

Critical Damage

Heal Power

Shield Power

Cooldown Reduction

Threat

Range

Move Speed

Accuracy

Evasion
```

Monster sẽ có.

```
HP

Attack

Defense

Magic Defense

Attack Speed

Move Speed

Skill Cooldown

Threat Type

Reward EXP

Reward Gold
```

Hiện tại chúng ta chỉ cần biết.

Đây là dữ liệu của Entity.

Chúng ta sẽ xây dựng Stat System ở chương sau.

---

# Entity và Skill

Một Hero có thể có nhiều Skill.

```
Hero

├── Heal

├── Shield

├── Buff

└── Ultimate
```

Điều này không có nghĩa HeroComponent chứa Skill.

Thay vào đó.

```
HeroModel

↓

List<SkillModel>
```

BattleSystem sẽ quyết định.

Skill nào được sử dụng.

---

# Entity và Buff

Buff cũng là dữ liệu.

Ví dụ.

```
+20% Attack

30 giây
```

Hoặc.

```
Poison

5 Damage / giây
```

HeroModel sẽ lưu.

```
List<Buff>
```

BattleSystem sẽ cập nhật mỗi frame.

---

# Entity ID

Mỗi Entity nên có một ID duy nhất.

Ví dụ.

```
Hero_001

Hero_002

Monster_005

Boss_001
```

Nhờ vậy.

BattleSystem có thể tìm đúng đối tượng.

Thay vì giữ reference phức tạp.

---

# Entity không phụ thuộc Flame

Một mục tiêu quan trọng.

```
HeroModel
```

không nên import.

```dart
import 'package:flame/...';
```

Điều này giúp.

- Test dễ hơn.
- Có thể chạy Battle Simulator.
- Có thể chạy Server Logic.
- Có thể Save/Load.

Ngay cả khi không có Flame.

---

# Kiến trúc Entity hoàn chỉnh

Sau chương này.

Kiến trúc sẽ như sau.

```
HeroModel

↓

BattleSystem

↓

HeroComponent

↓

World

↓

Camera

↓

Player
```

Component không sửa dữ liệu.

System không vẽ.

Model không biết Flame.

Ba phần hoàn toàn tách biệt.

---

# Sai lầm phổ biến

## Sai lầm 1

Đặt HP trong HeroComponent.

Sai.

HP thuộc về HeroModel.

---

## Sai lầm 2

Cho Component tự tính Damage.

Ví dụ.

```dart
attack()
```

Không nên.

BattleSystem sẽ xử lý.

---

## Sai lầm 3

Monster và Hero có hai kiến trúc khác nhau.

Hãy giữ chúng giống nhau.

```
Model

↓

Component

↓

System
```

Chỉ khác dữ liệu.

---

## Sai lầm 4

Entity phụ thuộc Flame.

Điều này khiến.

- Khó test.
- Khó Save.
- Khó Multiplayer.

Entity nên thuần Dart.

---

# Tổng kết

Trong chương này chúng ta đã xây dựng nền tảng cho toàn bộ gameplay.

Các điểm quan trọng cần nhớ:

- **Entity** là dữ liệu của một đối tượng trong game.
- **Component** chỉ chịu trách nhiệm hiển thị.
- **System** xử lý gameplay và cập nhật dữ liệu.
- Hero, Monster và Boss đều tuân theo cùng một kiến trúc.
- Entity nên độc lập với Flame để dễ mở rộng và kiểm thử.

Đây là một trong những quyết định kiến trúc quan trọng nhất của dự án, giúp việc thêm Hero, Monster hoặc Skill mới sau này chỉ cần mở rộng Model và System mà hầu như không phải sửa Component.

---

# Chương tiếp theo

Ở chương 7, chúng ta sẽ xây dựng **Stat System**.

Bạn sẽ học:

- Thiết kế hệ thống chỉ số linh hoạt.
- Phân biệt Base Stat và Final Stat.
- Cách Buff, Debuff và Equipment thay đổi chỉ số.
- Vì sao không nên lưu trực tiếp `attack += 20` trong Entity.
- Chuẩn bị nền tảng cho Combat System và Infinite Skill sau này.