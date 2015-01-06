package engine {
	import engine.entities.GameRigidBody;
	import engine.util.Input;
	import engine.world.World;
	import engine.world.WorldData;

	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.space.BruteForceSpace;
	import org.rje.glaze.engine.space.Space;

	/**
	 * @author Richard.Jewson
	 */
	public class Engine {
		public var space : Space;
		public var world : World;
		public var camera : Camera;
		private var input : Input;

		private var worldData : WorldData;
		private var options : GameOptions;

		public function Engine(worldData : WorldData, input : Input, options : GameOptions ) {
			this.worldData = worldData;
			this.input = input;
			this.options = options;
			initalize();
		}

		public function initalize() : void {
			space = new BruteForceSpace(options.fps, options.pps);
			
			space.defaultStaticBody.addShape(new Polygon(Polygon.createRectangle(600,30), new Vector2D(300,400), null));
			
			//space.iterations = Space.LOW_ITERATIONS;
			world = new World(worldData);
			camera = new Camera(world, options.cameraDimensions);
			space.addRigidBody(world.worldData.worldBody);
			for each (var body : GameRigidBody in world.worldData.allGameDynamicBodies) {
				space.addRigidBody(body);
			}
			camera.staticUpdate();
			
			space.masslessForce.copy(options.gravity) ;  //setTo(0, 300);
		}

		public function step() : void {
			space.step();
			
			camera.update(space);
		}
	}
}
