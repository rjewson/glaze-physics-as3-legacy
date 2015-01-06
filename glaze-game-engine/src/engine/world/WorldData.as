package engine.world {
	import game.entities.Character;

	import engine.entities.GameRigidBody;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;

	/**
	 * @author Richard.Jewson
	 */
	public class WorldData {
		
		public var allStaticShapes:Vector.<GeometricShape>;
		public var worldBody:RigidBody;
		
		public var playerCharacter:Character;

		public var allGameDynamicBodies:Vector.<GameRigidBody>;

		public function WorldData() {
			initalize();
		}

		public function initalize() : void {
			allStaticShapes = new Vector.<GeometricShape>();
			worldBody = new RigidBody(RigidBody.STATIC_BODY);
			allGameDynamicBodies = new Vector.<GameRigidBody>();
			setupWorldData();
			processWorldData();
		}

		virtual public function setupWorldData() : void {
		}

		virtual public function processWorldData() : void {
			allGameDynamicBodies.push(playerCharacter);
			for each (var shape : GeometricShape in allStaticShapes) {
				worldBody.addShape(shape);			
			}
		}
		//Vector.<Vector.<GeometricShape>>;
	}
}
