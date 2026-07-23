# Chapter 32 - Audio System - Xây dựng hệ thống âm thanh chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Audio System
- Audio Manager
- Audio Channel
- Background Music (BGM)
- Sound Effect (SFX)
- Audio Event
- Audio Pool
- Volume Mixer
- Dynamic Music
- Audio Serialization

Âm thanh là một trong những yếu tố quan trọng nhất tạo nên cảm giác của Gameplay.

Một Combat tốt.

Nhưng không có âm thanh.

Sẽ rất nhạt nhẽo.

---

# Audio là gì?

Rất nhiều người nghĩ.

Audio chỉ là.

```
play("attack.wav")
```

Thực tế.

Audio là.

```
Gameplay

↓

Audio Event

↓

Audio System
```

Gameplay.

Không tự phát.

Âm thanh.

---

# Audio System

Toàn bộ.

Âm thanh.

Được quản lý.

Bởi.

```
AudioSystem
```

Không nằm trong.

```
Hero
```

Không nằm trong.

```
Combat
```

Không nằm trong.

```
Animation
```

---

# Audio Flow

```text
Gameplay

↓

Audio Event

↓

AudioSystem

↓

Audio Channel

↓

Speaker
```

---

# Audio Manager

AudioManager.

Quản lý.

```
Load
```

```
Play
```

```
Stop
```

```
Pause
```

```
Resume
```

```
Volume
```

---

# Audio Asset

Audio.

Không Hard Code.

Ví dụ.

```
attack_01
```

```
footstep_grass
```

```
bgm_forest
```

Được quản lý.

Bằng.

```
Audio Definition
```

---

# Audio ID

Mỗi Audio.

Có.

```
Audio ID
```

Ví dụ.

```
hero_attack
```

```
boss_roar
```

```
ui_click
```

Không dùng.

Tên File.

Làm ID.

---

# Audio Channel

Không phải.

Âm thanh nào.

Cũng phát.

Trên cùng.

Một Channel.

Ví dụ.

```
Music
```

```
SFX
```

```
Voice
```

```
Ambient
```

```
UI
```

---

# Background Music (BGM)

BGM.

Là.

Âm nhạc.

Chạy nền.

Ví dụ.

```
Village
```

↓

```
Peaceful Music
```

---

# Sound Effect (SFX)

Ví dụ.

```
Attack
```

```
Explosion
```

```
Button Click
```

```
Potion
```

Đều là.

SFX.

---

# Ambient Sound

Ví dụ.

```
Wind
```

```
Rain
```

```
River
```

```
Bird
```

Tạo cảm giác.

Thế giới.

Sống động.

---

# Voice

Voice.

Bao gồm.

```
NPC
```

```
Hero
```

```
Boss
```

Voice.

Thuộc.

Channel riêng.

---

# UI Audio

Ví dụ.

```
Click
```

```
Popup
```

```
Notification
```

Không nên.

Chung.

Channel.

Với Combat.

---

# Audio Event

Gameplay.

Không gọi.

```
Audio.play()
```

Gameplay.

Chỉ phát.

```
AttackEvent
```

↓

AudioSystem.

↓

Attack Sound.

---

# Combat Audio

Ví dụ.

```
AttackEvent
```

↓

```
Sword Slash
```

---

# Skill Audio

Ví dụ.

```
FireballCastEvent
```

↓

```
Fireball.wav
```

Skill.

Không phát.

Âm thanh.

---

# Animation Audio

Animation.

Có thể phát.

```
Footstep Event
```

↓

AudioSystem.

↓

Footstep.

---

# Footstep

Không phải.

Animation nào.

Cũng giống nhau.

Ví dụ.

```
Grass
```

↓

```
grass_step.wav
```

```
Stone
```

↓

```
stone_step.wav
```

Surface.

Quyết định.

Âm thanh.

---

# Audio Pool

Không tạo.

Audio Player.

Liên tục.

Ví dụ.

```
Explosion

×

50
```

↓

Reuse.

Audio Player.

---

# Simultaneous Sound

Có thể.

```
10 Arrow
```

↓

```
10 Arrow Sound
```

AudioSystem.

Quản lý.

Pool.

---

# Max Voice

Ví dụ.

```
Explosion

100 lần
```

Không cần.

Phát.

100 Sound.

Giới hạn.

Ví dụ.

```
Max

8
```

---

# Audio Priority

Ví dụ.

```
Boss Roar

Priority

100
```

```
Footstep

20
```

Nếu quá nhiều.

Audio.

↓

Âm thanh.

Quan trọng.

Được ưu tiên.

---

# Volume Mixer

Mỗi Channel.

Có Volume riêng.

Ví dụ.

```
Music

70%
```

```
SFX

100%
```

```
Voice

80%
```

```
UI

60%
```

---

# Fade In

Ví dụ.

BGM.

↓

```
Fade In

2 giây
```

Âm thanh.

Mượt hơn.

---

# Fade Out

Ví dụ.

Rời Map.

↓

```
Fade Out
```

↓

BGM.

Dừng.

---

# Cross Fade

Ví dụ.

```text
Village Music

↓

Cross Fade

↓

Battle Music
```

Không bị.

Ngắt.

---

# Dynamic Music

Khi.

Boss xuất hiện.

↓

```
Battle Music
```

Boss chết.

↓

```
Peace Music
```

Audio.

Thay đổi.

Theo Gameplay.

---

# Layer Music

Ví dụ.

```
Base Music
```

+

```
Combat Layer
```

+

```
Boss Layer
```

Gameplay.

Chỉ bật.

Layer.

---

# 2D Audio

UI.

Button.

Notification.

↓

2D Audio.

Không phụ thuộc.

Camera.

---

# Positional Audio

Một số Game.

Có.

```
Left

↓

Left Speaker
```

```
Right

↓

Right Speaker
```

Âm thanh.

Theo.

Vị trí.

---

# Distance Attenuation

Monster.

Xa.

↓

Volume.

Nhỏ.

Monster.

Gần.

↓

Volume.

Lớn.

---

# Audio Loop

Ví dụ.

```
Rain
```

↓

Loop.

Cho đến khi.

Weather.

Kết thúc.

---

# One Shot Audio

Ví dụ.

```
Explosion
```

↓

Play.

Một lần.

---

# Audio Cache

Không Load.

File.

Mỗi lần.

Play.

AudioSystem.

Cache.

Sau lần đầu.

---

# Async Loading

BGM.

Có thể.

Load.

Background.

Không Block.

Gameplay.

---

# Pause

Pause Game.

↓

Pause.

Music.

↓

Pause.

SFX.

Hoặc.

Giữ nguyên.

Tùy Game.

---

# Mute

Player.

Có thể.

```
Mute Music
```

Nhưng.

Vẫn nghe.

SFX.

---

# Settings

Player.

Có thể.

Điều chỉnh.

```
Master
```

```
Music
```

```
SFX
```

```
Voice
```

Riêng biệt.

---

# Serialization

Save.

```
Volume
```

```
Mute
```

```
Current Music
```

Không lưu.

Audio Player.

---

# Debug

Developer Mode.

Hiển thị.

```
Current BGM
```

```
Playing SFX
```

```
Voice Count
```

```
Audio Pool
```

```
Volume
```

```
Channels
```

---

# Performance

Không tạo.

Player mới.

Cho.

Mỗi Audio.

Luôn.

Reuse.

Pool.

---

# Kiến trúc hoàn chỉnh

```text
Gameplay

↓

Audio Event

↓

AudioSystem

↓

Audio Manager

↓

Audio Channel

↓

Audio Player

↓

Speaker
```

Audio.

Không biết.

Combat.

Không biết.

Animation.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ AudioSystem

✅ Audio Manager

✅ Audio Channel

✅ BGM

✅ SFX

✅ Audio Event

✅ Audio Pool

✅ Volume Mixer

✅ Dynamic Music

✅ Serialization

---

# Sai lầm phổ biến

## Sai lầm 1

Combat.

Tự Play Sound.

Combat.

Chỉ phát.

```
AttackEvent
```

---

## Sai lầm 2

Hard Code.

Tên File.

Khắp Project.

Hãy dùng.

```
Audio ID
```

---

## Sai lầm 3

Chỉ có.

Một Volume.

Nên có.

```
Master
```

```
Music
```

```
SFX
```

```
Voice
```

Riêng.

---

## Sai lầm 4

Load.

Audio.

Mỗi lần.

Play.

Hãy.

Cache.

Sau lần đầu.

---

## Sai lầm 5

Không giới hạn.

Số lượng.

Audio.

Đồng thời.

Điều này.

Có thể gây.

Giật.

Hoặc.

Vỡ tiếng.

---

# Tổng kết

Audio System giúp Gameplay trở nên sống động và mang lại phản hồi tức thì cho người chơi.

Sau chương này:

- **AudioSystem** là nơi duy nhất quản lý toàn bộ âm thanh trong game.
- **Audio Event** giúp Gameplay tách biệt hoàn toàn với việc phát âm thanh.
- **Audio Channel** cho phép điều chỉnh riêng Music, SFX, Voice và UI.
- **Audio Pool** giúp tái sử dụng Audio Player để tăng hiệu năng.
- **Dynamic Music** và **Cross Fade** mang lại trải nghiệm âm thanh liền mạch.
- **Volume Mixer** và **Serialization** giúp người chơi tùy chỉnh và lưu lại thiết lập âm thanh.

Kiến trúc này phù hợp từ những game indie đơn giản cho đến các game RPG hoặc Action có hàng trăm hiệu ứng âm thanh phát đồng thời.

---

# Chương tiếp theo

Ở **Chương 33**, chúng ta sẽ xây dựng **Visual Effect (VFX) System**.

Bạn sẽ học cách xây dựng:

- VFX System.
- Effect Manager.
- Particle System.
- Object Pool.
- Screen Shake.
- Camera Flash.
- Hit Effect.
- Explosion.
- Trail Effect.
- Effect Event Pipeline.

Sau chương này, mọi hiệu ứng hình ảnh như cháy, nổ, máu, tia lửa, phép thuật và Camera Shake sẽ được quản lý bằng một hệ thống VFX chuyên nghiệp, tách biệt hoàn toàn khỏi Combat và Animation.