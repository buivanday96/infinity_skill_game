# Chapter 9 - Skill System - Thiết kế hệ thống kỹ năng có thể mở rộng

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Skill là gì
- Active Skill và Passive Skill
- Skill Lifecycle
- Target Selection
- Cooldown
- Mana Cost
- Skill Effect
- Kiến trúc Skill System của dự án

Đây là chương quan trọng nhất sau Combat System.

Nếu Combat System quyết định **luật chiến đấu**, thì Skill System chính là nơi tạo nên sự khác biệt giữa các Hero.

Một Combat System tốt có thể dùng cho nhiều game.

Một Skill System tốt sẽ giúp game có hàng trăm kỹ năng mà vẫn dễ mở rộng.

---

# Skill là gì?

Skill là hành động mà một Entity có thể thực hiện.

Ví dụ.

Hero.

```
Heal

Shield

Buff

Meteor
```

Monster.

```
Bite

Poison

Charge
```

Boss.

```
Meteor Rain

Laser

Earthquake
```

Mặc dù hiệu ứng khác nhau.

Nhưng tất cả đều là:

```
Skill
```

---

# Skill Categories

Theo tài liệu thiết kế của dự án, Skill được chia thành các nhóm sau. :contentReference[oaicite:0]{index=0}

```
Heal

Party Heal

Shield

Buff

Debuff

Single Target Damage

AOE Damage

Passive

Ultimate
```

Đây sẽ là nền tảng để xây dựng toàn bộ hệ thống kỹ năng.

---

# Một Skill gồm những gì?

Một Skill không chỉ có Damage.

Ví dụ.

```
Healing Wave
```

Có thể có.

```
Name

Cooldown

Mana Cost

Range

Target Type

Animation

Effect

Sound

Description
```

Tất cả đều thuộc về Skill.

---

# SkillModel

Một Skill nên được biểu diễn bằng dữ liệu.

Ví dụ.

```dart
class SkillModel {

    String id;

    String name;

    double cooldown;

    double manaCost;

}
```

Đây chỉ là dữ liệu.

Không có Animation.

Không có Particle.

Không có Gameplay.

---

# Active Skill

Đây là loại Skill quen thuộc nhất.

Ví dụ.

```
Heal
```

Người chơi bấm.

↓

Hero dùng Skill.

↓

Cooldown.

↓

Sẵn sàng lần nữa.

---

Ví dụ.

```
Meteor

↓

Cast

↓

Damage

↓

Cooldown
```

---

# Passive Skill

Passive không cần người chơi sử dụng.

Ví dụ.

```
+20% Heal
```

Hoặc.

```
+15% Attack
```

Ngay khi nhận Passive.

Stat đã thay đổi.

Không cần bấm.

---

# Ultimate

Ultimate cũng là Active Skill.

Khác biệt là.

- Cooldown dài.
- Hiệu ứng mạnh.
- Animation đặc biệt.

Kiến trúc không cần khác.

---

# Skill Lifecycle

Theo tài liệu thiết kế. :contentReference[oaicite:1]{index=1}

```
Ready

↓

Cast

↓

Animation

↓

Effect

↓

Cooldown

↓

Ready
```

Đây là vòng đời của mọi Skill.

Bất kể.

- Heal
- Shield
- Meteor
- Poison

đều đi theo cùng một quy trình.

---

# Cast không đồng nghĩa với Effect

Một sai lầm phổ biến.

```
Cast

↓

Damage ngay
```

Thực tế.

```
Cast

↓

Animation

↓

Hit Frame

↓

Damage
```

Ví dụ.

Hero giơ kiếm.

```
0.0s

↓

Rút kiếm
```

```
0.2s

↓

Chém
```

```
0.3s

↓

Monster nhận Damage
```

Điều này giúp Animation và Gameplay đồng bộ.

---

# Mana Cost

Trước khi dùng Skill.

BattleSystem kiểm tra.

```
Current Mana

>=

Mana Cost ?
```

Nếu đủ.

```
Cast
```

Nếu không.

Skill thất bại.

---

Ví dụ.

```
Current Mana

30
```

```
Meteor

50 Mana
```

Không thể sử dụng.

---

# Cooldown

Sau khi dùng Skill.

```
Cooldown

=

5 giây
```

Mỗi frame.

```
Cooldown -= dt
```

Khi.

```
Cooldown <= 0
```

Skill trở lại trạng thái.

```
Ready
```

Không cần sử dụng Timer.

---

# Target Selection

Không phải Skill nào cũng chọn mục tiêu giống nhau.

Ví dụ.

Heal.

```
Lowest HP Hero
```

Fireball.

```
Nearest Monster
```

Buff.

```
Entire Party
```

Meteor.

```
Position
```

Do đó.

Target nên được tách riêng.

```
Skill

↓

Target Selector

↓

BattleSystem
```

---

# Target Type

Một số loại Target phổ biến.

```
Self
```

```
Single Ally
```

```
Entire Party
```

```
Nearest Enemy
```

```
Lowest HP Enemy
```

```
Highest Threat
```

```
Random Enemy
```

```
Area
```

Nhờ vậy.

Skill mới không cần viết lại Combat.

---

# Skill Effect

Sau khi chọn Target.

Skill sẽ sinh ra Effect.

Ví dụ.

```
Heal

↓

Restore HP
```

```
Shield

↓

Add Shield
```

```
Meteor

↓

Damage
```

```
Poison

↓

Add Debuff
```

Skill chỉ mô tả.

Effect mới thật sự thay đổi dữ liệu.

---

# Một Skill có thể có nhiều Effect

Ví dụ.

```
Holy Light
```

Có thể.

```
Heal

+

Remove Poison

+

Increase Defense
```

Không cần tạo ba Skill.

Chỉ cần một Skill chứa ba Effect.

---

# Skill không nên biết Animation

Một nguyên tắc rất quan trọng.

SkillModel.

Không nên chứa.

```dart
playAnimation();
```

Skill chỉ mô tả.

```
Animation Id

=

heal_animation
```

Component sẽ tự phát Animation.

---

# Skill không trực tiếp sửa HP

Sai.

```dart
skill.hp += 100;
```

Đúng.

```
Skill

↓

BattleSystem

↓

Apply Heal
```

BattleSystem là nơi duy nhất được thay đổi HP.

---

# Hero có nhiều Skill

Theo thiết kế dự án.

Healer có.

```
Heal

Shield

Buff
```

Tank.

```
Shield

Taunt
```

Mage.

```
Meteor

Fireball
```

Archer.

```
Arrow

Poison

Critical Shot
```

Tất cả chỉ là.

```
List<SkillModel>
```

Không cần kiến trúc riêng.

---

# Monster Skill

Monster cũng sử dụng cùng Skill System.

Ví dụ.

```
Poison Bite
```

```
Charge
```

```
Roar
```

Boss.

```
Meteor

Laser

Summon
```

BattleSystem không quan tâm.

Đó là Hero hay Monster.

Chỉ cần.

```
Caster

↓

Skill

↓

Target
```

---

# Skill System trong dự án

Kiến trúc hoàn chỉnh.

```text
Hero

↓

SkillSystem

↓

Target Selector

↓

BattleSystem

↓

Skill Effect

↓

Entity

↓

Component
```

Mỗi phần chỉ làm đúng một nhiệm vụ.

---

# Chuẩn bị cho Infinite Skill

Theo thiết kế gameplay.

Sau mỗi tầng.

Người chơi chọn.

```
1 trong 3 Skill
```

Ví dụ. :contentReference[oaicite:2]{index=2}

```
+20% Heal

+15% Archer Attack

Tank Shield

Meteor

Poison Arrow

Critical Heal

Chain Lightning

Life Steal

Auto Heal

Healing Aura
```

Các Skill này sẽ được thêm vào Hero.

Không cần sửa Combat System.

Đó là lý do Skill phải độc lập.

---

# Kiến trúc có thể mở rộng

Giả sử sau này.

Bạn muốn thêm.

```
Chain Lightning
```

Không cần sửa.

```
BattleSystem
```

Chỉ cần.

```
ChainLightningSkill

↓

List<Effect>

↓

Done
```

Hoặc.

```
Frozen Arrow
```

Chỉ cần thêm.

```
Damage

+

Slow
```

Toàn bộ Combat vẫn hoạt động.

---

# Sai lầm phổ biến

## Sai lầm 1

Mỗi Skill có một class riêng chứa toàn bộ gameplay.

Ví dụ.

```
Fireball

500 dòng
```

```
Heal

600 dòng
```

Sau vài chục Skill.

Project sẽ rất khó bảo trì.

---

## Sai lầm 2

Skill tự sửa HP.

BattleSystem mới là nơi thay đổi dữ liệu.

---

## Sai lầm 3

Cooldown dùng Timer.

Cooldown nên giảm bằng.

```
dt
```

trong Game Loop.

---

## Sai lầm 4

Hero và Monster dùng hai hệ thống Skill khác nhau.

Hãy để.

```
SkillSystem
```

phục vụ cho mọi Entity.

---

# Tổng kết

Skill System là lớp trừu tượng nằm giữa Hero và Combat.

Trong chương này chúng ta đã xây dựng một kiến trúc mà:

- Skill chỉ mô tả hành động.
- Target Selector chọn mục tiêu.
- BattleSystem thực thi hiệu ứng.
- Component phát Animation.
- Cooldown và Mana được quản lý tập trung.

Nhờ cách tổ chức này, việc thêm một Skill mới thường chỉ cần tạo dữ liệu và Effect mới mà không phải sửa Combat System.

Đây chính là nền tảng để xây dựng hàng trăm kỹ năng và hệ thống Infinite Skill trong các chương tiếp theo.

---

# Chương tiếp theo

Ở chương 10, chúng ta sẽ xây dựng **AI System**.

Bạn sẽ học:

- Finite State Machine (FSM).
- Monster AI.
- Boss Pattern.
- Target Selection.
- Threat System.
- Vì sao AI cũng nên được tách thành một System độc lập thay vì nằm trong MonsterComponent.