package engine {
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.space.Space;

	import engine.entities.GameRigidBody;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;

	import engine.world.World;

	import org.rje.glaze.engine.math.Vector2D;

	import flash.display.Sprite;

	/**
	 * @author Richard.Jewson
	 */
	public class Camera extends Sprite {

		private var world : World;
		private var size : Vector2D;

		private var background:Sprite;
		private var foreground:Sprite;

		public function Camera(world : World, size : Vector2D) {
			this.world = world;
			this.size = size;
			
			background = new Sprite();
			addChild(background);
			foreground = new Sprite();
			addChild(foreground);
		}

		public function staticUpdate() : void {
			background.graphics.clear();
			world.renderAll(background.graphics);
		}

		public function update(space:Space) : void {
			foreground.graphics.clear();
			var body:RigidBody = space.staticBodies;
			while (body) {
				body.draw(foreground.graphics);
				body = body.next;
			}
			body = space.activeBodies;
			while (body) {
				body.draw(foreground.graphics);
				body = body.next;
			}
			return;
			for each (var body : RigidBody in space.staticBodies) {
				for each (var shape : GeometricShape in body.memberShapes) {
					shape.draw(foreground.graphics);
				}
			}
		}
	}
}
