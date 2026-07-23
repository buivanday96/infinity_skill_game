# Chapter 22 - Collision System - Xây dựng hệ thống va chạm chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Collision System
- Collision Layer
- Collision Mask
- Collider
- Trigger
- Hitbox
- Hurtbox
- Collision Detection
- Collision Resolution
- Raycast
- Spatial Partition

Đây là một trong những Gameplay System quan trọng nhất.

Nếu không có Collision.

Game sẽ không có:

- Tường
- Đánh nhau
- Bullet
- Loot
- Trigger
- NPC
- Portal

Hầu hết Gameplay đều dựa trên Collision.

---

# Collision là gì?

Collision là quá trình xác định.

```
Hai vật thể

↓

Có chạm nhau không?
```

Ví dụ.

```
Hero

↓

Monster
```

Hay.

```
Bullet

↓

Wall
```

Hoặc.

```
Player

↓

Chest
```

---

# Collision không phải Physics

Đây là điều rất nhiều người nhầm.

Collision chỉ trả lời.

```
Có va chạm?

Có

Không
```

Physics mới quyết định.

```
Bật lại

Trượt

Rơi

Nảy
```

Trong game RPG.

Đa số chỉ cần.

```
Collision

+

Movement
```

Không cần Physics Engine.

---

# Collision System

Collision là Gameplay.

Do.

```
CollisionSystem
```

quản lý.

Không nằm trong.

```
HeroComponent
```

Không nằm trong.

```
MonsterComponent
```

---

# Collision Flow

Một Frame.

```text
Movement

↓

Collision Detection

↓

Collision Response

↓

Update Position

↓

Render
```

Đây là Flow chuẩn.

---

# Collider

Mỗi Entity có thể có.

```
Collider
```

Ví dụ.

```
Hero
```

↓

```
Circle Collider
```

Hoặc.

```
Rectangle Collider
```

Collider chỉ là.

```
Vùng va chạm
```

Không phải Sprite.

---

# Collider không phải Sprite

Ví dụ.

Hero.

```
Sprite

64x64
```

Collider.

```
32x40
```

Điều này rất bình thường.

Không nên dùng.

```
Sprite Size
```

làm Collider.

---

# Các loại Collider

Thông dụng nhất.

```
Rectangle
```

```
Circle
```

```
Capsule
```

```
Polygon
```

Trong series này.

Chúng ta ưu tiên.

```
Rectangle

+

Circle
```

---

# Collision Layer

Không phải Entity nào cũng va chạm nhau.

Ví dụ.

```
Hero
```

↓

```
Player Layer
```

```
Monster
```

↓

```
Enemy Layer
```

```
Wall
```

↓

```
Obstacle Layer
```

---

# Collision Mask

Layer.

Cho biết.

```
Tôi là ai
```

Mask.

Cho biết.

```
Tôi va chạm với ai
```

Ví dụ.

Hero.

```
Layer

Player
```

Mask.

```
Enemy

Wall

Loot
```

Không va chạm.

```
Player
```

---

# Layer Matrix

Ví dụ.

```text
Player

↓

Enemy ✔

↓

Wall ✔

↓

Player ✘

↓

Projectile ✔
```

CollisionSystem.

Chỉ kiểm tra.

Các Layer phù hợp.

---

# Broad Phase

Nếu game có.

```
1000 Entity
```

Không nên.

```
1000 x 1000
```

Collision.

Quá chậm.

Đầu tiên.

Lọc.

```
Nearby Objects
```

Đây gọi là.

```
Broad Phase
```

---

# Narrow Phase

Sau khi lọc.

Mới kiểm tra chính xác.

```
Rectangle

↓

Rectangle
```

Hay.

```
Circle

↓

Circle
```

Điều này gọi là.

```
Narrow Phase
```

---

# Spatial Partition

Để Broad Phase nhanh hơn.

World sẽ chia thành.

```text
Grid

+----+----+----+

|    | M  |    |

+----+----+----+

| P  |    |    |

+----+----+----+
```

Hero.

Chỉ kiểm tra.

Ô lân cận.

Không phải toàn bộ Map.

---

# Trigger

Không phải Collision nào.

Cũng chặn đường.

Ví dụ.

```
Portal
```

Hero đi qua.

↓

```
Next Level
```

Hoặc.

```
Chest
```

↓

```
Open UI
```

Đây gọi là.

```
Trigger
```

---

# Solid Collider

Ví dụ.

```
Wall
```

↓

```
Cannot Pass
```

Khác với Trigger.

Solid sẽ chặn Movement.

---

# Hitbox

Hitbox.

Là vùng gây sát thương.

Ví dụ.

```
Sword Swing
```

↓

```
Hitbox
```

Monster nằm trong.

↓

```
Take Damage
```

---

# Hurtbox

Hurtbox.

Là vùng nhận sát thương.

Ví dụ.

```
Monster Body
```

↓

```
Hurtbox
```

Nếu.

```
Hitbox

↓

Hurtbox
```

↓

```
Damage
```

---

# Vì sao tách Hitbox và Hurtbox?

Ví dụ.

Hero.

```
Sword
```

↓

Hitbox.

```
Body
```

↓

Hurtbox.

Hai vùng khác nhau.

Đây là cách mọi game Action hoạt động.

---

# Collision Event

Collision không xử lý Gameplay.

Nó chỉ phát.

```
CollisionEvent
```

Ví dụ.

```
Hero

↓

Chest
```

↓

```
ChestCollisionEvent
```

System khác xử lý.

---

# Collision Resolution

Nếu Hero.

Va vào.

```
Wall
```

Movement sẽ.

```
Slide
```

Hoặc.

```
Stop
```

Collision chỉ báo.

```
Có va chạm
```

Movement quyết định.

---

# Continuous Collision

Bullet rất nhanh.

Nếu chỉ kiểm tra.

```
Frame hiện tại
```

Có thể.

```
Xuyên tường
```

Do đó.

Projectile.

Nên dùng.

```
Continuous Collision
```

---

# Raycast

Raycast.

Là một đường kiểm tra.

Ví dụ.

```
Hero

────────▶
```

Dùng cho.

```
Vision

Laser

Shoot

Mouse Click
```

Không phải Collider.

---

# Line of Sight

AI.

Muốn biết.

```
Có nhìn thấy Hero?
```

↓

Raycast.

Nếu.

```
Wall
```

ở giữa.

↓

Không thấy.

---

# Area Detection

Ví dụ.

Skill.

```
Explosion
```

↓

```
Circle Radius
```

↓

Tìm tất cả Monster.

Đây không phải Collision.

Mà là.

```
Overlap Query
```

---

# Collision State

Một Entity có thể.

```
Enter
```

```
Stay
```

```
Exit
```

Ví dụ.

Hero bước vào Portal.

↓

Enter.

Đứng trong.

↓

Stay.

Đi ra.

↓

Exit.

---

# Projectile Collision

Flow.

```text
Projectile

↓

Collision

↓

Monster

↓

Damage

↓

Destroy Projectile
```

Projectile.

Không tự tính Damage.

---

# Loot Collision

Hero.

↓

```
Coin
```

↓

```
PickupEvent
```

↓

Inventory.

Collision chỉ phát Event.

---

# Collision Debug

Developer Mode.

Hiển thị.

```
Collider
```

```
Hitbox
```

```
Hurtbox
```

```
Layer
```

```
Mask
```

Giúp Debug cực kỳ dễ.

---

# Performance

Một nguyên tắc.

Không Collision.

```
1000

×

1000
```

Entity.

Luôn dùng.

```
Broad Phase

↓

Narrow Phase
```

---

# Kiến trúc hoàn chỉnh

```text
Movement

↓

CollisionSystem

↓

Broad Phase

↓

Narrow Phase

↓

Collision Event

↓

Gameplay System
```

Collision.

Không biết Battle.

Battle.

Không biết Collider.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ CollisionSystem

✅ Collider

✅ Rectangle Collider

✅ Circle Collider

✅ Collision Layer

✅ Collision Mask

✅ Trigger

✅ Hitbox

✅ Hurtbox

✅ Raycast

---

# Sai lầm phổ biến

## Sai lầm 1

Sprite chính là Collider.

Không đúng.

Collider thường nhỏ hơn Sprite.

---

## Sai lầm 2

Collision xử lý Damage.

Collision chỉ phát.

```
CollisionEvent
```

BattleSystem xử lý Damage.

---

## Sai lầm 3

Mọi Entity đều Collision với nhau.

Hãy dùng.

```
Layer

+

Mask
```

---

## Sai lầm 4

Không có Broad Phase.

Game sẽ chậm khi số lượng Entity tăng.

---

## Sai lầm 5

Không phân biệt Trigger và Solid.

Portal không nên chặn Player.

Wall thì phải.

---

# Tổng kết

Collision là nền tảng của gần như mọi Gameplay trong game.

Sau chương này:

- **CollisionSystem** chịu trách nhiệm phát hiện va chạm.
- **Collider** mô tả vùng va chạm của Entity.
- **Layer** và **Mask** giúp giảm số lượng kiểm tra không cần thiết.
- **Hitbox** và **Hurtbox** tách biệt vùng gây sát thương và vùng nhận sát thương.
- **Trigger** dùng cho Portal, Loot và các sự kiện.
- **Raycast** phục vụ AI, Skill và Targeting.
- **Broad Phase + Narrow Phase** đảm bảo Collision vẫn hoạt động hiệu quả khi game có hàng nghìn Entity.

Đây là nền tảng để chúng ta xây dựng hệ thống chiến đấu ở các chương tiếp theo.

---

# Chương tiếp theo

Ở **Chương 23**, chúng ta sẽ xây dựng **Combat System**.

Đây là Gameplay System quan trọng nhất của toàn bộ game.

Bạn sẽ học cách xây dựng:

- Attack Flow.
- Damage Pipeline.
- Critical Hit.
- Defense.
- Damage Modifier.
- Attack Cooldown.
- Combo.
- Invincibility Frame (I-Frame).
- Death Pipeline.

Sau chương này, Hero và Monster sẽ có thể chiến đấu với nhau hoàn chỉnh.