# Command base class
class Command:
	func execute(player: Node) -> void:
		pass
		
	func executeMove(player: Node, direction:Vector2) -> void:
		pass	
	
class MoveCommand extends Command:
	func executeMove(player:Node, direction: Vector2) -> void:
		player.set_direction(direction)

class ACommand extends Command:
	func execute(player:Node) -> void:
		print('command jump test')
		player.aCommand()

class BCommand extends Command:
	func execute(player:Node) -> void:
		player.bCommand()

class BCommandRelease extends Command:
	func execute(player:Node) -> void:
		player.bCommandRelease()

class CCommand extends Command:
	func execute(player:Node)-> void:
		player.cCommand()
