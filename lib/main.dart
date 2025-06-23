import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: TowerDefenseGame()));
}

class TowerDefenseGame extends FlameGame {
  late Tower tower;
  late Enemy enemy;

  @override
  Future<void> onLoad() async {
    tower = Tower()
      ..position = Vector2(100, 200);
    add(tower);

    enemy = Enemy()
      ..position = Vector2(400, 200);
    add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (enemy.isAlive && tower.canShoot(enemy)) {
      tower.shoot(enemy);
    }
  }
}

class Tower extends PositionComponent {
  double range = 200;
  double fireCooldown = 1.0;
  double _cooldownTimer = 0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset.zero, 20, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _cooldownTimer -= dt;
  }

  bool canShoot(Enemy enemy) {
    return _cooldownTimer <= 0 &&
        (enemy.position - position).length < range &&
        enemy.isAlive;
  }

  void shoot(Enemy enemy) {
    enemy.takeDamage(1);
    _cooldownTimer = fireCooldown;
  }
}

class Enemy extends PositionComponent {
  int health = 5;
  bool get isAlive => health > 0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = isAlive ? Colors.red : Colors.grey;
    canvas.drawRect(Rect.fromLTWH(-10, -10, 20, 20), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isAlive) {
      position.x -= 20 * dt;
    }
  }

  void takeDamage(int amount) {
    health -= amount;
  }
}
