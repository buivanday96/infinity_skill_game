# Chapter 34 - Game Event & Message Bus System - Xây dựng hệ thống Event Bus chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Event Bus
- Event Dispatcher
- Publish / Subscribe
- Domain Event
- Global Event
- Event Queue
- Delayed Event
- Typed Event
- Event Debugger

Đây là một trong những chương quan trọng nhất của toàn bộ series.

Nếu không có Event Bus.

Các System sẽ phụ thuộc lẫn nhau.

Sau vài tháng.

Project sẽ trở thành.

```
Spaghetti Code
```

---

# Event là gì?

Rất nhiều người nghĩ.

Event là.

```
Callback
```

Hay.

```
Function
```

Thực tế.

Event chỉ là.

```
Một thông báo

Đã có việc xảy ra
```

Ví dụ.

```
Monster Killed
```

↓

Đây là Event.

---

# Event Bus là gì?

Event Bus.

Là nơi.

```
Publish

↓

Dispatch

↓

Subscribe
```

Mọi System.

Giao tiếp.

Thông qua.

Event Bus.

---

# Tại sao cần Event Bus?

Không có Event Bus.

```text
Combat

↓

Quest

↓

Audio

↓

VFX

↓

Achievement

↓

Analytics
```

Combat.

Biết.

Mọi System.

Sai.

---

# Với Event Bus

Combat.

Chỉ làm.

```text
Combat

↓

MonsterKilledEvent
```

Quest.

Tự lắng nghe.

Audio.

Tự lắng nghe.

VFX.

Tự lắng nghe.

Achievement.

Tự lắng nghe.

Analytics.

Tự lắng nghe.

---

# Publish / Subscribe

Đây là mô hình.

Quan trọng nhất.

```text
Publisher

↓

Event Bus

↓

Subscriber
```

Publisher.

Không biết.

Ai đang nghe.

---

# Publisher

Ví dụ.

Combat.

↓

```
publish(
MonsterKilledEvent
)
```

Combat.

Không biết.

Quest tồn tại.

---

# Subscriber

QuestSystem.

↓

```
subscribe<
MonsterKilledEvent>()
```

↓

Update Progress.

---

# Event Flow

```text
Gameplay

↓

Publish Event

↓

Event Bus

↓

Subscribers

↓

Gameplay Update
```

---

# Typed Event

Không dùng.

```
String
```

Ví dụ.

Sai.

```
"monster_killed"
```

Đúng.

```
MonsterKilledEvent
```

Typed Event.

An toàn hơn.

---

# Domain Event

Ví dụ.

```
PlayerLevelUpEvent
```

```
QuestCompletedEvent
```

```
BossKilledEvent
```

Đây là.

Gameplay Event.

---

# UI Event

Ví dụ.

```
OpenInventoryEvent
```

↓

UI.

---

# Audio Event

Ví dụ.

```
AttackSoundEvent
```

↓

AudioSystem.

---

# VFX Event

Ví dụ.

```
ExplosionEffectEvent
```

↓

VFXSystem.

---

# Global Event

Một số Event.

Toàn Game.

Ví dụ.

```
GamePausedEvent
```

```
LanguageChangedEvent
```

```
ThemeChangedEvent
```

---

# Local Event

Một số Event.

Chỉ.

Trong.

Một Scene.

Không cần.

Global.

---

# Event Queue

Không phải.

Event nào.

Cũng xử lý.

Ngay.

Ví dụ.

```
Queue

↓

Dispatch
```

Ở cuối.

Frame.

---

# Delayed Event

Ví dụ.

```
Explosion

↓

1 giây

↓

Damage
```

↓

Delayed Event.

---

# Scheduled Event

Ví dụ.

```
Boss Spawn

30 giây
```

↓

Event Scheduler.

---

# Event Priority

Ví dụ.

```
GameOver

Priority

100
```

```
Footstep

10
```

Event Bus.

Có thể.

Ưu tiên.

---

# Event Order

Ví dụ.

```
MonsterKilledEvent
```

↓

```
Quest Update
```

↓

```
Achievement
```

↓

```
UI
```

↓

```
Analytics
```

Thứ tự.

Có thể.

Quan trọng.

---

# Sticky Event

Một số Event.

Luôn.

Tồn tại.

Ví dụ.

```
LanguageChanged
```

System mới.

Đăng ký.

↓

Nhận ngay.

State hiện tại.

---

# One Shot Event

Ví dụ.

```
Quest Completed
```

↓

Chỉ.

Một lần.

---

# Event Payload

Ví dụ.

```
MonsterKilledEvent

{
 monsterId,
 killerId,
 exp
}
```

Payload.

Chỉ chứa.

Dữ liệu.

Không chứa.

Logic.

---

# Event Immutability

Sau khi.

Publish.

↓

Không sửa.

Event.

Event.

Nên là.

Immutable.

---

# Event Dispatcher

Dispatcher.

Nhận.

Event.

↓

Gửi.

Đến.

Subscriber.

---

# Event Filter

Ví dụ.

Quest.

Chỉ quan tâm.

```
Slime
```

Monster khác.

↓

Ignore.

---

# Event Chain

Ví dụ.

```text
MonsterKilled

↓

QuestCompleted

↓

RewardGranted

↓

LevelUp

↓

SkillUnlocked
```

Đây là.

Chuỗi Event.

---

# Circular Event

Sai.

```text
A

↓

B

↓

C

↓

A
```

Event.

Không được.

Lặp vô hạn.

---

# Event Storm

Ví dụ.

```
1000 Monster

↓

1000 Event
```

Event Bus.

Cần.

Queue.

Hoặc.

Batch.

---

# Batch Event

Ví dụ.

```
Collected Coin

100 lần
```

↓

```
CoinCollectedBatchEvent
```

Hiệu quả hơn.

---

# Event Replay

Developer.

Có thể.

Replay.

Event.

Để Debug.

Gameplay.

---

# Event Logger

Developer Mode.

Lưu.

```
MonsterKilled
```

↓

```
QuestUpdated
```

↓

```
RewardGranted
```

Giúp.

Debug.

---

# Analytics

Analytics.

Không gọi.

Gameplay.

Analytics.

Chỉ.

Subscribe.

Event.

---

# Multiplayer

Network.

Không gọi.

Combat.

Network.

Chỉ.

Subscribe.

Event.

↓

Sync.

---

# Save

SaveSystem.

Có thể.

Subscribe.

```
QuestCompleted
```

↓

Auto Save.

---

# UI

UI.

Không đọc.

Combat.

↓

```
PlayerDamagedEvent
```

↓

Update HP.

---

# Audio

Audio.

Không đọc.

Skill.

↓

```
SkillCastEvent
```

↓

Play Sound.

---

# VFX

VFX.

Không đọc.

Combat.

↓

```
CriticalHitEvent
```

↓

Spawn Effect.

---

# AI

AI.

Có thể.

Subscribe.

```
AllyKilledEvent
```

↓

Run Away.

---

# Debug

Developer Mode.

Hiển thị.

```
Current Event
```

```
Subscribers
```

```
Dispatch Time
```

```
Queue Size
```

```
Delayed Events
```

---

# Performance

Không tạo.

Event.

Mỗi Frame.

Nếu.

Không cần.

Một số.

Gameplay.

Có thể.

Gọi trực tiếp.

---

# Khi nào KHÔNG nên dùng Event?

Đây là điều.

Rất nhiều người.

Hiểu sai.

Không phải.

Mọi thứ.

Đều dùng.

Event.

Ví dụ.

Sai.

```text
Movement

↓

MoveEvent

↓

Transform
```

Movement.

Có thể.

Gọi trực tiếp.

Transform.

Event.

Nên dùng.

Cho.

```
Gameplay xảy ra
```

Không phải.

```
Function Call
```

---

# Event Naming

Nên dùng.

Tên.

Ở thì.

Quá khứ.

Ví dụ.

```
PlayerLeveledUpEvent
```

```
MonsterKilledEvent
```

```
QuestCompletedEvent
```

Không dùng.

```
KillMonsterEvent
```

Vì.

Đó là.

Command.

Không phải.

Event.

---

# Command và Event

Đừng nhầm.

Hai khái niệm.

Command.

```text
Làm việc gì đó
```

Ví dụ.

```
CastSkillCommand
```

↓

Yêu cầu.

Thực hiện.

Event.

```text
Việc đó.

Đã xảy ra.
```

Ví dụ.

```
SkillCastEvent
```

Đây là.

Hai thứ.

Hoàn toàn khác nhau.

---

# Kiến trúc hoàn chỉnh

```text
Gameplay

↓

Publish

↓

Event Bus

↓

Dispatcher

↓

Subscribers

↓

Quest

↓

Audio

↓

VFX

↓

Analytics

↓

Save

↓

UI
```

Không System nào.

Biết.

System khác.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ EventBus

✅ Publish

✅ Subscribe

✅ Typed Event

✅ Event Queue

✅ Delayed Event

✅ Event Logger

✅ Event Debugger

✅ Domain Event

✅ Global Event

---

# Sai lầm phổ biến

## Sai lầm 1

Combat.

Gọi.

Quest.

Trực tiếp.

Hãy.

Publish.

Event.

---

## Sai lầm 2

Dùng.

String.

Cho Event.

Luôn dùng.

Typed Event.

---

## Sai lầm 3

Mọi Function.

Đều dùng.

Event.

Event.

Không thay thế.

Function Call.

---

## Sai lầm 4

Event.

Có thể sửa.

Sau khi Publish.

Event.

Nên.

Immutable.

---

## Sai lầm 5

Không có.

Logger.

Khi Debug.

Bạn sẽ.

Không biết.

Gameplay.

Đã xảy ra.

Điều gì.

---

# Tổng kết

Event Bus là "hệ thần kinh" của toàn bộ game.

Sau chương này:

- **EventBus** trở thành trung tâm giao tiếp giữa các System.
- **Publish / Subscribe** giúp các System hoàn toàn tách biệt khỏi nhau.
- **Typed Event** giúp mã nguồn an toàn và dễ bảo trì.
- **Event Queue**, **Delayed Event** và **Priority** giúp xử lý Event hiệu quả hơn.
- **Event Logger** và **Event Replay** là công cụ cực kỳ mạnh để Debug Gameplay.
- **Quest**, **Audio**, **VFX**, **UI**, **Analytics**, **Save** và **Network** đều có thể hoạt động độc lập nhưng vẫn phối hợp chặt chẽ thông qua Event.

Đây là nền tảng kiến trúc được sử dụng trong rất nhiều game engine và dự án AAA vì khả năng mở rộng, bảo trì và kiểm thử vượt trội.

---

# Chương tiếp theo

Ở **Chương 35**, chúng ta sẽ xây dựng **Game State & Scene Management System**.

Bạn sẽ học cách xây dựng:

- Game State Machine.
- Scene Management.
- Scene Loading.
- Scene Transition.
- Pause System.
- Loading Screen.
- Bootstrap Scene.
- Persistent Systems.
- Scene Lifecycle.
- Scene Event Pipeline.

Sau chương này, game sẽ có kiến trúc quản lý Scene và vòng đời của game một cách chuyên nghiệp, hỗ trợ chuyển màn chơi, loading bất đồng bộ và quản lý các System toàn cục một cách rõ ràng.