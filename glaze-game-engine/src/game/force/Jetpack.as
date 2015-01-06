package game.force {
	import test.GameControls;
	import engine.util.Input;

	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.dynamics.forces.Force;

	/**
	 * @author Richard.Jewson
	 */
	public class Jetpack extends Force {
		
		private var accumulatedForce:Vector2D;
		private var r:Vector2D;

		public var unitForce : Number;
		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;

		public function Jetpack() {
			accumulatedForce = new Vector2D();
			r = new Vector2D();
			unitForce = 150000;
		}

		override public function eval(body : RigidBody) : void {
			
			accumulatedForce.x = accumulatedForce.y = 0;
			
			if (up) 	accumulatedForce.y -= unitForce;
			if (down) 	accumulatedForce.y += unitForce;
			if (left) 	accumulatedForce.x -= unitForce;
			if (right) 	accumulatedForce.x += unitForce;

			body.ApplyForces(accumulatedForce, r);
		}
	}
}
