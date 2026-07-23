# Chapter 12 - Event System - Kết nối toàn bộ Game bằng Event

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Event System là gì
- Publish / Subscribe
- Event Bus
- Vì sao System không nên gọi trực tiếp nhau
- Battle Event
- UI Event
- Audio Event
- Achievement Event
- Kiến trúc Event System của dự án

Đây là một trong những chương quan trọng nhất về kiến trúc.

Sau chương này, chúng ta sẽ loại bỏ phần lớn sự phụ thuộc (Coupling) giữa các System.

Game sẽ trở nên dễ mở rộng hơn rất nhiều.

---

# Event là gì?

Một Event đơn giản chỉ là:

> Một điều gì đó vừa xảy ra.

Ví dụ.

```
Hero chết
```

Đó là một Event.

```
Monster chết
```

Cũng là một Event.

```
Level Up
```

Là một Event.

```
Boss xuất hiện
```

Cũng là Event.

---

# Nếu không có Event

Giả sử.

Monster chết.

BattleSystem sẽ phải gọi.

```
BattleSystem

↓

UISystem

↓

AudioSystem

↓

QuestSystem

↓

AchievementSystem

↓

DungeonSystem

↓

Analytics
```

BattleSystem biết quá nhiều thứ.

Đây là kiến trúc rất khó bảo trì.

---

# Event Bus

Thay vì gọi trực tiếp.

BattleSystem chỉ phát Event.

```
BattleSystem

↓

MonsterDeadEvent

↓

Event Bus
```

Các System khác sẽ tự lắng nghe.

```
UI

↓

Update

Audio

↓

Play Sound

Quest

↓

Update Progress

Dungeon

↓

Victory Check

Analytics

↓

Log Event
```

BattleSystem không cần biết ai đang nghe.

---

# Publish / Subscribe

Event hoạt động theo hai bước.

## Publish

Một System phát Event.

```
Monster chết

↓

Publish
```

---

## Subscribe

System khác đăng ký.

```
MonsterDeadEvent

↓

Update Quest
```

Đây gọi là.

```
Publish / Subscribe
```

Đây là mô hình được sử dụng trong rất nhiều Game Engine.

---

# Một ví dụ đơn giản

Monster chết.

```
BattleSystem

↓

MonsterDeadEvent
```

UI.

```
Hiển thị

+50 EXP
```

Audio.

```
Play

monster_die.wav
```

Achievement.

```
Kill Count +1
```

Analytics.

```
Monster Killed
```

BattleSystem không gọi bất kỳ System nào.

---

# Event không chứa Logic

Sai.

```text
MonsterDeadEvent

↓

Update Gold

↓

Update EXP

↓

Play Audio
```

Event không làm gì cả.

Nó chỉ mang thông tin.

Ví dụ.

```
MonsterDeadEvent

Monster ID

Reward

Position
```

Các System sẽ tự xử lý.

---

# Event nên bất biến (Immutable)

Ví dụ.

```dart
class MonsterDeadEvent {

    final String monsterId;

    final Vector2 position;

    final int rewardGold;

}
```

Sau khi tạo.

Không ai được sửa Event.

Điều này giúp Debug dễ hơn.

---

# Battle Event

Một số Battle Event phổ biến.

```
BattleStartEvent
```

```
BattleEndEvent
```

```
HeroAttackEvent
```

```
MonsterAttackEvent
```

```
DamageEvent
```

```
HealEvent
```

```
ShieldEvent
```

```
CriticalHitEvent
```

```
HeroDeadEvent
```

```
MonsterDeadEvent
```

Combat chỉ phát Event.

---

# UI Event

UI cũng có Event.

Ví dụ.

```
Button Click
```

↓

```
Use Skill
```

Hoặc.

```
Pause Click
```

↓

```
Pause Game
```

UI không gọi Battle trực tiếp.

---

# Audio Event

Âm thanh cũng không nên được gọi trực tiếp.

Sai.

```dart
audio.play("hit.wav");
```

Trong BattleSystem.

Đúng.

```
DamageEvent

↓

AudioSystem

↓

Play Hit
```

Sau này.

Nếu thay Audio Engine.

BattleSystem không cần sửa.

---

# Particle Event

Ví dụ.

```
Critical Hit
```

↓

```
CriticalHitEvent
```

↓

```
ParticleSystem
```

↓

```
Explosion
```

BattleSystem không cần biết Particle.

---

# Floating Text Event

Ví dụ.

```
Damage

250
```

BattleSystem.

↓

```
DamageEvent
```

UI.

↓

```
Floating Text

-250
```

Hoặc.

```
Heal

+180
```

Đây cũng là Event.

---

# Achievement Event

Achievement không nên nằm trong Combat.

Ví dụ.

```
Kill

100 Monster
```

BattleSystem chỉ phát.

```
MonsterDeadEvent
```

AchievementSystem.

↓

```
Kill Count +1
```

Nếu đạt.

```
Achievement Unlock
```

Không cần sửa Combat.

---

# Quest Event

Quest cũng tương tự.

Ví dụ.

```
Kill

20 Goblin
```

BattleSystem.

↓

```
MonsterDeadEvent
```

QuestSystem.

↓

```
Goblin +1
```

Hoàn toàn độc lập.

---

# Analytics Event

Analytics không nên nằm trong Gameplay.

Ví dụ.

```
Player chọn Skill
```

↓

```
SkillSelectedEvent
```

Analytics.

↓

```
Firebase

GameAnalytics

Mixpanel
```

Gameplay không cần import Analytics SDK.

---

# Save Event

Ví dụ.

```
Floor Complete
```

↓

```
FloorCompletedEvent
```

SaveSystem.

↓

```
Auto Save
```

BattleSystem hoàn toàn không biết Save.

---

# Event Chain

Một Event có thể sinh Event khác.

Ví dụ.

```
MonsterDeadEvent

↓

RewardSystem

↓

GoldReceivedEvent

↓

UISystem

↓

+100 Gold
```

Hoặc.

```
LevelUpEvent

↓

SkillSelectionEvent

↓

Show Upgrade Screen
```

Mỗi Event chỉ làm một việc.

---

# Event Queue

Một lưu ý quan trọng.

Đừng xử lý Event ngay khi phát.

Thay vào đó.

```
Publish

↓

Queue

↓

Process
```

Điều này giúp tránh.

```
Battle

↓

Monster chết

↓

Spawn Monster

↓

Monster chết

↓

Spawn Monster
```

lồng nhau vô hạn.

---

# Kiến trúc Event System

Sau chương này.

```
BattleSystem

↓

Publish Event

↓

Event Bus

↓

UISystem

↓

AudioSystem

↓

ParticleSystem

↓

QuestSystem

↓

AchievementSystem

↓

DungeonSystem

↓

SaveSystem

↓

Analytics
```

Tất cả đều độc lập.

---

# Event Bus trong dự án

Trong series này.

Chúng ta sẽ chỉ có.

```
GameEventBus
```

Toàn bộ System đều dùng chung.

Ví dụ.

```
BattleSystem

↓

GameEventBus
```

```
DungeonSystem

↓

GameEventBus
```

```
UISystem

↓

GameEventBus
```

Không cần nhiều Event Bus khác nhau.

---

# Event không thay thế Function

Một sai lầm phổ biến.

Dùng Event cho mọi thứ.

Ví dụ.

```
Move Hero
```

↓

```
MoveHeroEvent
```

Không nên.

Nếu chỉ có một System sử dụng.

Hãy gọi Function.

Event chỉ nên dùng khi.

**Có nhiều System cần biết một sự kiện vừa xảy ra.**

---

# Khi nào nên dùng Event?

Nên.

```
Monster chết
```

```
Battle thắng
```

```
Hero Level Up
```

```
Skill được chọn
```

```
Achievement Unlock
```

---

Không nên.

```
Calculate Damage
```

```
Move Character
```

```
Find Target
```

Đây là Logic nội bộ.

---

# Sai lầm phổ biến

## Sai lầm 1

BattleSystem gọi trực tiếp UI.

```text
Battle

↓

UI

↓

Audio

↓

Quest

↓

Analytics
```

Coupling rất cao.

---

## Sai lầm 2

Một Event xử lý Gameplay.

Event chỉ mang dữ liệu.

Không chứa Logic.

---

## Sai lầm 3

Có quá nhiều Event Bus.

Ví dụ.

```
BattleBus

QuestBus

AudioBus

UIBus
```

Thông thường.

Một GameEventBus là đủ.

---

## Sai lầm 4

Dùng Event cho mọi Function.

Không phải thứ gì cũng nên là Event.

Hãy chỉ dùng khi nhiều System cần phản ứng với cùng một sự kiện.

---

# Tổng kết

Event System là "chất keo" kết nối toàn bộ game.

Thay vì để các System gọi trực tiếp lẫn nhau, mọi sự kiện sẽ được phát thông qua **GameEventBus**.

Kiến trúc cuối cùng sẽ như sau.

```text
BattleSystem

↓

GameEventBus

↓

UISystem

↓

AudioSystem

↓

ParticleSystem

↓

QuestSystem

↓

AchievementSystem

↓

DungeonSystem

↓

SaveSystem

↓

Analytics
```

Nhờ mô hình **Publish / Subscribe**, các System gần như không biết đến sự tồn tại của nhau.

Điều này giúp:

- Thêm tính năng mới mà không sửa BattleSystem.
- Dễ kiểm thử từng System.
- Giảm Coupling.
- Tăng khả năng mở rộng khi game ngày càng lớn.

Đây là một trong những kỹ thuật quan trọng nhất trong các game thương mại.

---

# Chương tiếp theo

Ở chương 13, chúng ta sẽ xây dựng **Save & Load System**.

Bạn sẽ học:

- Những gì cần lưu.
- Những gì không nên lưu.
- Save theo Snapshot.
- Auto Save.
- Continue Game.
- Serialization.
- Cách lưu một Infinite Dungeon chỉ với vài KB dữ liệu.