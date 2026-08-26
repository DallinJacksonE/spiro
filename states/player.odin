package states

import rl "vendor:raylib"

PLAYER_MAX_HEALTH :: i32(100)
PLAYER_JUMP_SECONDS :: f32(0.55)
PLAYER_SHOOT_FLASH_SECONDS :: f32(0.16)

Player_Animation :: enum {
	Idle,
	Walking,
	Running,
	Crouching,
	Jumping,
	Shooting,
	Deploying_Shield,
	Using_Drone,
	Dead,
}

Player_Posture :: enum {
	Standing,
	Crouching,
	Airborne,
}

Weapon_Type :: enum {
	Shovel,
	Sidearm,
	Rifle,
	Launcher,
}

Weapon_State :: struct {
	kind:     Weapon_Type,
	ammo:     i32,
	capacity: i32,
}

Player_Inventory :: struct {
	weapons:       [Weapon_Type]Weapon_State,
	current_weapon: Weapon_Type,
	shield_covers: i32,
}

Player :: struct {
	health:          i32,
	animation:       Player_Animation,
	posture:         Player_Posture,
	inventory:       Player_Inventory,
	shield_deployed: bool,
	jump_elapsed:    f32,
	shoot_elapsed:   f32,
}

player_init :: proc() -> Player {
	return Player {
		health = PLAYER_MAX_HEALTH,
		animation = .Idle,
		posture = .Standing,
		inventory = player_inventory_init(),
		shield_deployed = false,
		jump_elapsed = 0,
		shoot_elapsed = 0,
	}
}

player_inventory_init :: proc() -> Player_Inventory {
	inventory: Player_Inventory
	inventory.weapons[.Shovel] = Weapon_State{kind = .Shovel, ammo = 0, capacity = 0}
	inventory.weapons[.Sidearm] = Weapon_State{kind = .Sidearm, ammo = 36, capacity = 36}
	inventory.weapons[.Rifle] = Weapon_State{kind = .Rifle, ammo = 90, capacity = 90}
	inventory.weapons[.Launcher] = Weapon_State{kind = .Launcher, ammo = 3, capacity = 3}
	inventory.current_weapon = .Sidearm
	inventory.shield_covers = 1
	return inventory
}

update_player_timers :: proc(player: ^Player, dt: f32) {
	if player.posture == .Airborne {
		player.jump_elapsed += dt
		if player.jump_elapsed >= PLAYER_JUMP_SECONDS {
			player.posture = .Standing
			player.jump_elapsed = 0
		}
	}

	if player.shoot_elapsed > 0 {
		player.shoot_elapsed -= dt
		if player.shoot_elapsed < 0 {
			player.shoot_elapsed = 0
		}
	}
}

player_is_alive :: proc(player: ^Player) -> bool {
	return player.health > 0
}

player_can_move :: proc(player: ^Player) -> bool {
	return player_is_alive(player) && player.posture != .Airborne
}

player_can_jump :: proc(player: ^Player) -> bool {
	return player_is_alive(player) && player.posture == .Standing
}

player_can_shoot :: proc(player: ^Player) -> bool {
	weapon := player.inventory.weapons[player.inventory.current_weapon]
	if weapon.kind == .Shovel {
		return player_is_alive(player) && player.shoot_elapsed <= 0
	}

	return player_is_alive(player) && player.shoot_elapsed <= 0 && weapon.ammo > 0
}

start_player_crouch :: proc(player: ^Player) {
	if !player_is_alive(player) || player.posture == .Airborne {
		return
	}
	player.posture = .Crouching
	player.animation = .Crouching
}

stop_player_crouch :: proc(player: ^Player) {
	if player.posture == .Crouching {
		player.posture = .Standing
		player.animation = .Idle
	}
}

start_player_jump :: proc(player: ^Player) -> bool {
	if !player_can_jump(player) {
		return false
	}
	player.posture = .Airborne
	player.animation = .Jumping
	player.jump_elapsed = 0
	return true
}

set_player_move_animation :: proc(player: ^Player, moving, running: bool) {
	if !player_is_alive(player) {
		player.animation = .Dead
		return
	}
	if player.posture == .Airborne {
		player.animation = .Jumping
		return
	}
	if player.posture == .Crouching {
		player.animation = .Crouching
		return
	}
	if moving {
		player.animation = running ? .Running : .Walking
		return
	}
	if player.shoot_elapsed > 0 {
		player.animation = .Shooting
		return
	}
	if player.shield_deployed {
		player.animation = .Deploying_Shield
		return
	}
	player.animation = .Idle
}

deploy_player_shield_cover :: proc(player: ^Player) -> bool {
	if !player_is_alive(player) || player.shield_deployed || player.inventory.shield_covers <= 0 {
		return false
	}
	player.inventory.shield_covers -= 1
	player.shield_deployed = true
	player.animation = .Deploying_Shield
	return true
}

deactivate_player_shield_cover :: proc(player: ^Player) {
	player.shield_deployed = false
}

cycle_player_weapon :: proc(player: ^Player, weapon: Weapon_Type) {
	player.inventory.current_weapon = weapon
}

shoot_player_weapon :: proc(player: ^Player) -> bool {
	if !player_can_shoot(player) {
		return false
	}
	if player.inventory.current_weapon != .Shovel {
		player.inventory.weapons[player.inventory.current_weapon].ammo -= 1
	}
	player.shoot_elapsed = PLAYER_SHOOT_FLASH_SECONDS
	player.animation = .Shooting
	return true
}

player_take_damage :: proc(player: ^Player, amount: i32) {
	if amount <= 0 || !player_is_alive(player) {
		return
	}
	player.health -= amount
	if player.health <= 0 {
		player.health = 0
		player.animation = .Dead
	}
}

player_weapon_name :: proc(weapon: Weapon_Type) -> cstring {
	switch weapon {
	case .Shovel:
		return "Shovel"
	case .Sidearm:
		return "Sidearm"
	case .Rifle:
		return "Rifle"
	case .Launcher:
		return "Launcher"
	}
	return "Unknown"
}

player_animation_name :: proc(animation: Player_Animation) -> cstring {
	switch animation {
	case .Idle:
		return "Idle"
	case .Walking:
		return "Walking"
	case .Running:
		return "Running"
	case .Crouching:
		return "Crouching"
	case .Jumping:
		return "Jumping"
	case .Shooting:
		return "Shooting"
	case .Deploying_Shield:
		return "Deploying Shield"
	case .Using_Drone:
		return "Using Drone"
	case .Dead:
		return "Dead"
	}
	return "Unknown"
}

player_draw_color :: proc(player: ^Player) -> rl.Color {
	switch player.animation {
	case .Crouching:
		return rl.DARKGREEN
	case .Running:
		return rl.YELLOW
	case .Jumping:
		return rl.SKYBLUE
	case .Shooting:
		return rl.ORANGE
	case .Deploying_Shield:
		return rl.BLUE
	case .Using_Drone:
		return rl.PURPLE
	case .Dead:
		return rl.MAROON
	case .Idle, .Walking:
		return rl.RAYWHITE
	}
	return rl.RAYWHITE
}
