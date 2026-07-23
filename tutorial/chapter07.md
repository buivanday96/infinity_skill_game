# Chapter 7 - Stat System - Thiết kế hệ thống chỉ số có thể mở rộng

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Stat là gì
- Vì sao không nên lưu Attack, HP đơn giản trong Hero
- Base Stat và Final Stat khác nhau như thế nào
- Buff ảnh hưởng đến Stat ra sao
- Equipment thay đổi Stat như thế nào
- Infinite Skill sẽ cộng Stat ở đâu
- Kiến trúc Stat System cho game RPG

Đây là chương cực kỳ quan trọng.

Một Stat System được thiết kế tốt có thể dùng cho toàn bộ game.

Một Stat System thiết kế kém sẽ khiến Combat, Skill, Buff và Equipment trở nên cực kỳ khó mở rộng.

---

# Stat là gì?

Stat (Statistic) là toàn bộ các chỉ số của một Entity.

Ví dụ.

Hero có:

- HP
- Attack
- Defense
- Mana
- Critical Rate
- Move Speed

Monster cũng có Stat.

Boss cũng có Stat.

Stat quyết định sức mạnh của Entity.

Theo thiết kế của dự án, Hero và Monster sẽ có các nhóm chỉ số như sau. :contentReference[oaicite:0]{index=0}

Hero:

- HP
- Max HP
- Mana
- Attack
- Magic Attack
- Defense
- Magic Defense
- Attack Speed
- Critical Rate
- Critical Damage
- Heal Power
- Shield Power
- Cooldown Reduction
- Threat
- Range
- Move Speed
- Accuracy
- Evasion

Monster:

- HP
- Attack
- Defense
- Magic Defense
- Attack Speed
- Move Speed
- Skill Cooldown
- Threat Type
- Reward EXP
- Reward Gold

---

# Cách thiết kế sai

Rất nhiều game bắt đầu như thế này.

```dart
class HeroModel {

    double attack = 100;

    double defense = 20;

    double hp = 500;

}
```

Sau đó.

Có Buff.

```dart
attack += 20;
```

Có Equipment.

```dart
attack += 35;
```

Có Passive.

```dart
attack += 50;
```

Có Aura.

```dart
attack += 15;
```

Một lúc sau.

Không ai biết.

```
Attack = 220
```

đến từ đâu.

---

# Base Stat

Chúng ta sẽ chia Stat thành nhiều tầng.

Đầu tiên.

```
Base Stat
```

Ví dụ.

```
Attack

=

100
```

Đây là chỉ số gốc.

Không bao giờ thay đổi trong lúc chiến đấu.

Ví dụ.

```
Hero Level 1

Attack

=

100
```

Đây gọi là Base Attack.

---

# Bonus Stat

Sau đó.

Equipment cộng.

```
Sword

+20 Attack
```

Passive cộng.

```
+15 Attack
```

Skill cộng.

```
+30 Attack
```

Ta gọi đây là:

```
Bonus Stat
```

---

# Final Stat

Sau cùng.

BattleSystem sẽ tính.

```
Base

100

+

Bonus

65

=

165
```

Đây là:

```
Final Attack
```

Combat chỉ dùng Final Stat.

---

# Tại sao phải chia nhiều tầng?

Ví dụ.

Bạn có.

```
Attack

100
```

Skill.

```
+20%
```

Equipment.

```
+50
```

Aura.

```
+15%
```

Nếu chỉ lưu.

```
Attack = ?
```

Bạn sẽ rất khó tính.

Nhưng nếu chia tầng.

```
Base

↓

Flat Bonus

↓

Percentage Bonus

↓

Final
```

Mọi thứ sẽ rõ ràng hơn rất nhiều.

---

# Công thức tính

Ví dụ.

```
Base Attack

100
```

Equipment.

```
+40
```

Passive.

```
+20
```

Buff.

```
+30%
```

Ta sẽ có.

```
Flat

=

100 + 40 + 20

=

160
```

Sau đó.

```
Final

=

160 × 1.3

=

208
```

BattleSystem chỉ cần lấy.

```
208
```

để tính Damage.

---

# Một Stat không chỉ có một giá trị

Ví dụ.

```
Attack
```

Thực tế.

```
Attack

├── Base

├── Flat Bonus

├── Percent Bonus

└── Final
```

Đây là lý do chúng ta không nên lưu.

```dart
double attack;
```

---

# HP cũng là Stat

HP thường bị thiết kế sai.

Sai.

```
HP

500
```

Đúng.

```
Current HP

320
```

```
Max HP

500
```

Hai giá trị này hoàn toàn khác nhau.

---

Ví dụ.

Hero bị đánh.

```
Current HP

500

↓

350
```

Max HP không đổi.

---

# Mana cũng giống HP

```
Current Mana

40
```

```
Max Mana

100
```

Khi dùng Skill.

```
Current Mana

↓

20
```

Không bao giờ sửa.

```
Max Mana
```

---

# Attack Speed

Một sai lầm phổ biến.

Lưu.

```
Cooldown
```

Thay vì.

```
Attack Speed
```

Ví dụ.

```
Attack Speed

=

2 Attack / Second
```

BattleSystem sẽ tự tính.

```
Cooldown

=

0.5 giây
```

Điều này giúp Buff Attack Speed dễ hơn.

---

# Critical Rate

Ví dụ.

```
20%
```

BattleSystem.

```
Random

↓

Critical?
```

Nếu đúng.

Damage.

```
×

Critical Damage
```

---

# Critical Damage

Ví dụ.

```
150%
```

Damage.

```
100

↓

150
```

Nếu Hero có Buff.

```
+50%
```

Critical Damage.

```
200%
```

---

# Heal Power

Trong game của chúng ta.

Healer sẽ có.

```
Heal Power
```

Ví dụ.

Skill.

```
Heal

200
```

Hero.

```
Heal Power

+30%
```

Kết quả.

```
260
```

Điều này giúp cùng một Skill nhưng mạnh hơn khi Hero được nâng cấp.

---

# Shield Power

Hoạt động giống Heal.

```
Shield

100
```

Hero.

```
Shield Power

50%
```

Kết quả.

```
150
```

---

# Cooldown Reduction

Ví dụ.

Skill.

```
10 giây
```

Hero.

```
Cooldown Reduction

20%
```

BattleSystem.

```
Final

=

8 giây
```

---

# Accuracy và Evasion

Combat sau này.

```
Accuracy

↓

Hit?
```

Nếu trượt.

```
Miss
```

Monster có.

```
Evasion
```

Càng cao.

Càng khó bị đánh trúng.

---

# Threat

Theo thiết kế ban đầu.

Tank có Threat cao hơn Hero khác. :contentReference[oaicite:1]{index=1}

Monster AI sẽ ưu tiên tấn công Hero có Threat lớn.

Điều này giúp Tank thực hiện đúng vai trò.

---

# Stat System trong dự án

Kiến trúc.

```
HeroModel

↓

StatSystem

↓

BattleSystem

↓

Damage
```

BattleSystem không tự tính.

```
Attack
```

Nó sẽ hỏi.

```
StatSystem
```

Ví dụ.

```text
Hero

↓

Final Attack?

↓

208
```

Sau đó.

Damage mới được tính.

---

# Infinite Skill tác động ở đâu?

Theo thiết kế game.

Sau mỗi tầng.

Người chơi chọn một Skill.

Ví dụ. :contentReference[oaicite:2]{index=2}

```
+20% Heal

+15% Archer Attack

Critical Heal

Healing Aura
```

Những Skill này KHÔNG sửa trực tiếp.

```
Attack = 200
```

Thay vào đó.

Chúng thêm Bonus.

```
Bonus Attack

+15%
```

Stat System sẽ tự tính lại Final Stat.

Nhờ vậy.

Nếu sau này mất Buff.

Chỉ cần bỏ Bonus.

Final Stat sẽ tự cập nhật.

---

# Sai lầm phổ biến

## Sai lầm 1

Chỉ lưu một biến.

```dart
attack
```

Không biết giá trị đến từ đâu.

---

## Sai lầm 2

Buff sửa trực tiếp.

```dart
attack += 50;
```

Khi Buff hết.

Không biết phải trừ bao nhiêu.

---

## Sai lầm 3

Equipment sửa Base Stat.

Base Stat nên đại diện cho sức mạnh gốc.

Equipment chỉ thêm Bonus.

---

## Sai lầm 4

Combat tự tính toàn bộ Stat.

BattleSystem chỉ nên hỏi.

```
Final Attack?
```

Stat System mới là nơi chịu trách nhiệm tính toán.

---

# Tổng kết

Stat System là nền móng của toàn bộ gameplay.

Trong dự án này.

Mỗi Stat sẽ được chia thành nhiều tầng:

```
Base

↓

Flat Bonus

↓

Percent Bonus

↓

Final
```

BattleSystem luôn sử dụng **Final Stat**.

Buff, Equipment, Passive và Infinite Skill chỉ thay đổi Bonus.

Nhờ đó chúng ta có thể thêm hàng trăm Skill mới mà không cần sửa Combat System.

Đây cũng là nền tảng để xây dựng hệ thống Buff, Equipment và Infinite Skill ở các chương sau.

---

# Chương tiếp theo

Ở chương 8, chúng ta sẽ xây dựng **Combat System**.

Đây là nơi mọi thứ kết hợp lại:

- Hero tấn công Monster.
- Monster phản công.
- Tính Damage.
- Shield hấp thụ sát thương.
- Heal hồi máu.
- Critical, Miss và Death.

Sau chương này, chúng ta sẽ có một trận chiến hoàn chỉnh chạy hoàn toàn tự động.