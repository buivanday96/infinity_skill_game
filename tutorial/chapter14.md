# Chapter 14 - Asset Management System - Quản lý Asset cho game lớn

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Asset Management là gì
- Cách tổ chức Asset trong dự án
- Sprite Atlas
- Animation Asset
- Audio Asset
- Font Asset
- Lazy Loading
- Asset Cache
- Resource Manager
- Kiến trúc Asset System của dự án

Đây là chương mà rất nhiều lập trình viên Flutter thường bỏ qua.

Khi game chỉ có vài Sprite, mọi thứ đều đơn giản.

Nhưng khi game có:

- 300 Hero
- 800 Monster
- 2000 Skill Effect
- 500 UI Icon
- 100 Background
- 500 Audio

Nếu không có Asset System tốt, project sẽ nhanh chóng trở thành "địa ngục".

---

# Asset là gì?

Asset là mọi tài nguyên mà game sử dụng.

Ví dụ.

```
Sprite
```

```
Animation
```

```
Audio
```

```
Video
```

```
Shader
```

```
Map
```

```
JSON
```

```
Localization
```

```
Font
```

```
Particle
```

Toàn bộ đều là Asset.

---

# Asset không chỉ là hình ảnh

Nhiều người nghĩ.

Asset chỉ là.

```
PNG
```

Thực tế.

Game còn sử dụng.

```
MP3

OGG

JSON

Aseprite

Atlas

Spine

Lottie

Tile Map
```

Asset Management phải quản lý tất cả.

---

# Cấu trúc thư mục

Một dự án lớn nên tổ chức.

```
assets/

    images/

    audio/

    fonts/

    animations/

    shaders/

    particles/

    maps/

    icons/

    ui/

    localization/
```

Không nên.

```
assets/

    hero.png

    hero2.png

    goblin.png

    bg.png

    sound.mp3
```

Sau vài tháng.

Bạn sẽ không tìm được gì.

---

# Chia theo Feature

Thay vì.

```
images/

    hero

    monster

    ui
```

Chúng ta nên chia.

```
assets/

    battle/

    dungeon/

    ui/

    skill/

    monster/

    hero/

    audio/
```

Hoặc.

```
hero/

    knight/

    mage/

    healer/

    archer/
```

Điều này dễ mở rộng hơn.

---

# Đặt tên Asset

Một quy tắc quan trọng.

Đừng đặt.

```
image1.png
```

```
hero_new.png
```

```
monster_final.png
```

Sau vài tháng.

Không ai biết file nào dùng.

Thay vào đó.

```
hero_knight_idle.png
```

```
hero_knight_attack.png
```

```
monster_slime_walk.png
```

```
boss_dragon_fire.png
```

Tên Asset nên mô tả nội dung.

---

# Sprite Atlas

Một sai lầm phổ biến.

```
hero_idle_1.png

hero_idle_2.png

hero_idle_3.png

...

hero_idle_20.png
```

Game phải mở.

20 file.

Thay vào đó.

Dùng.

```
hero_idle.png

+

Atlas
```

Một ảnh lớn chứa toàn bộ Frame.

Ví dụ.

```
+--------------------------------+

1 2 3 4 5 6 7 8 9

+--------------------------------+
```

Game chỉ tải một lần.

---

# Vì sao Atlas nhanh hơn?

Nếu Animation có.

```
20 Frame
```

Không dùng Atlas.

```
20 lần đọc file
```

Dùng Atlas.

```
1 lần đọc
```

GPU cũng Render nhanh hơn.

---

# Sprite Sheet

Flame hỗ trợ rất tốt.

```
SpriteSheet

↓

SpriteAnimation
```

Ví dụ.

```
Idle

Walk

Attack

Dead
```

Đều lấy từ cùng một Sprite Sheet.

---

# Aseprite

Trong series này.

Chúng ta ưu tiên.

```
Aseprite
```

vì.

- Dễ vẽ Pixel Art.
- Export Sprite Sheet.
- Export JSON.
- Quản lý Animation.

Flame hỗ trợ đọc Aseprite rất tốt.

Nếu không có JSON.

Chúng ta vẫn có thể đọc Sprite Sheet theo Frame như đã trình bày ở các chương trước.

---

# Animation Asset

Không nên.

```
Attack

↓

10 file PNG

↓

Code
```

Thay vào đó.

```
Attack.anim

↓

Sprite Sheet

↓

Play
```

Animation nên là dữ liệu.

Không Hard Code.

---

# UI Asset

UI nên tách riêng.

```
ui/

    button/

    panel/

    icon/

    badge/

    dialog/
```

Không đặt chung với Hero.

---

# Icon

Ví dụ.

```
heal.png
```

```
shield.png
```

```
fire.png
```

```
poison.png
```

Skill Icon nên tách riêng.

---

# Audio

Một game lớn sẽ có.

```
BGM
```

```
SFX
```

```
Voice
```

Ví dụ.

```
audio/

    bgm/

    sfx/

    voice/
```

Trong.

```
SFX
```

Tiếp tục chia.

```
battle/

ui/

skill/

monster/
```

---

# Font

Không nên.

```
Roboto

Arial

Verdana

...
```

Chỉ nên sử dụng.

1-2 Font chính.

Ví dụ.

```
UIFont
```

```
TitleFont
```

Giúp game đồng nhất hơn.

---

# Localization

Ngôn ngữ cũng là Asset.

Ví dụ.

```
vi.json
```

```
en.json
```

```
ja.json
```

Không Hard Code.

```dart
"Attack"
```

Trong UI.

---

# Asset Manifest

Một Resource Manager nên biết.

```
Hero Sprite

↓

hero_knight_idle.png
```

Thay vì.

```dart
Sprite.load(
"assets/images/hero/hero_knight_idle.png"
)
```

Khắp project.

Nên dùng.

```text
Asset.heroKnightIdle
```

Điều này giúp đổi Asset dễ dàng.

---

# Resource Manager

Toàn bộ Asset nên đi qua.

```
AssetManager
```

Ví dụ.

```
Hero

↓

AssetManager

↓

Sprite
```

Không Component nào tự đọc Asset.

---

# Asset Cache

Một Sprite.

Không nên Load.

```
100 lần
```

Ví dụ.

100 Goblin.

Không nên.

```
100 lần Sprite.load()
```

Chỉ cần.

```
Load

1 lần

↓

Cache

↓

Reuse
```

Điều này giảm RAM và CPU rất nhiều.

---

# Lazy Loading

Không nên.

```
Load

5000 Asset

↓

Splash Screen

30 giây
```

Thay vào đó.

```
Load Menu
```

↓

```
Load Battle
```

↓

```
Load Dungeon
```

↓

```
Load Boss
```

Chỉ khi cần.

---

# Preload

Ngược lại.

Một số Asset nên tải trước.

Ví dụ.

```
Hero
```

```
UI
```

```
Button
```

```
Common Effect
```

Đây là Asset luôn xuất hiện.

---

# Streaming Asset

Một số Asset rất lớn.

Ví dụ.

```
Video

100MB
```

Không nên Load toàn bộ.

Nên.

```
Stream
```

Khi cần.

---

# Asset Reference

Gameplay không nên biết.

```
hero_knight_idle.png
```

Gameplay chỉ biết.

```
Hero Type

↓

Knight
```

AssetManager quyết định.

Sprite nào sẽ được sử dụng.

---

# Asset Bundle

Một kỹ thuật phổ biến.

```
Base Asset
```

```
DLC Asset
```

```
Season Asset
```

Game chỉ tải Bundle cần thiết.

Điều này rất hữu ích khi game phát triển lâu dài.

---

# Memory Management

Một sai lầm phổ biến.

Load.

```
Boss

500MB
```

Đánh xong.

Vẫn giữ trong RAM.

Đúng.

```
Load

↓

Battle

↓

Release
```

AssetManager nên biết.

Asset nào còn sử dụng.

---

# Kiến trúc Asset System

Sau chương này.

```
AssetManager

↓

Cache

↓

Sprite

↓

Audio

↓

Animation

↓

Font

↓

Localization
```

Gameplay.

↓

```
Request Asset
```

AssetManager.

↓

```
Return Cached Resource
```

Không System nào đọc file trực tiếp.

---

# Asset Pipeline

Toàn bộ quy trình.

```
Artist

↓

Aseprite

↓

Export

↓

Sprite Sheet

↓

AssetManager

↓

Game
```

Hoặc.

```
Sound Designer

↓

Audio

↓

AssetManager

↓

AudioSystem
```

Gameplay không phụ thuộc Asset.

---

# Chuẩn bị cho Modding

Nếu Asset được quản lý tốt.

Sau này.

Có thể thay.

```
Knight Skin
```

↓

```
Knight Christmas Skin
```

Mà không cần sửa Gameplay.

Đây là nền tảng cho.

- Skin
- Theme
- Seasonal Event
- DLC

---

# Sai lầm phổ biến

## Sai lầm 1

Hard Code đường dẫn Asset.

Ví dụ.

```dart
Sprite.load(
"assets/images/hero/knight.png"
)
```

Nên đi qua.

```
AssetManager
```

---

## Sai lầm 2

Load cùng một Sprite nhiều lần.

Hãy sử dụng Cache.

---

## Sai lầm 3

Đặt tất cả Asset trong một thư mục.

Sau vài nghìn file.

Rất khó quản lý.

---

## Sai lầm 4

Load toàn bộ Asset khi mở game.

Điều này làm Splash Screen rất lâu.

Hãy kết hợp.

```
Preload

+

Lazy Loading
```

---

## Sai lầm 5

Gameplay phụ thuộc Asset.

Gameplay chỉ nên biết.

```
Hero

Monster

Skill
```

Không nên biết.

```
PNG

MP3

JSON
```

---

# Tổng kết

Asset Management không chỉ là quản lý hình ảnh.

Đó là hệ thống chịu trách nhiệm quản lý toàn bộ tài nguyên của game.

Trong dự án này:

- **AssetManager** là điểm truy cập duy nhất tới Asset.
- **Sprite Atlas** giúp giảm số lần đọc file và tăng hiệu năng.
- **Asset Cache** tránh Load trùng lặp.
- **Lazy Loading** giúp game khởi động nhanh.
- **Preload** dành cho Asset quan trọng.
- Gameplay hoàn toàn không phụ thuộc vào đường dẫn Asset.

Đây là nền tảng để game có thể mở rộng lên hàng chục nghìn Asset mà vẫn dễ bảo trì và đạt hiệu năng tốt.

---

# Chương tiếp theo

Ở chương 15, chúng ta sẽ xây dựng **Rendering & Performance System**.

Bạn sẽ học:

- Flame Render Pipeline.
- Render Layer.
- Z Index.
- Culling.
- Object Pooling.
- Fixed Update.
- Tối ưu CPU và GPU.
- Cách để game có thể hiển thị hàng nghìn Entity mà vẫn giữ 60 FPS.