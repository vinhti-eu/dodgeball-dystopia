# Command base class
class Command:
	func execute(player: Node) -> void:
		pass
		
	func executeMove(player: Node, direction:Vector2) -> void:
		pass	
	
class MoveCommand extends Command:
	func executeMove(player:Node, direction: Vector2) -> void:
		player.set_direction(direction)


class LeftCommand extends Command:
	func execute(player: Node) -> void:
		player.set_direction(Vector2(-1, 0))

class RightCommand extends Command:
	func execute(player: Node) -> void:
		player.set_direction(Vector2(1, 0))

class UpCommand extends Command:
	func execute(player: Node) -> void:
		player.set_direction(Vector2(0, -1))

class DownCommand extends Command:
	func execute(player: Node) -> void:
		player.set_direction(Vector2(0, 1))
