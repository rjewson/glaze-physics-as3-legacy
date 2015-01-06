package game.entities {
	import test.GameControls;
	import engine.entities.GameRigidBody;
	import engine.util.Input;

	import game.force.Jetpack;

	import org.rje.glaze.engine.collision.shapes.Circle;
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.Arbiter;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.dynamics.constraints.DampedRotarySpring;
	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.space.Space;

	/**
	 * @author Richard.Jewson
	 */
	public class Character extends GameRigidBody {

		public var control : Jetpack;
		public var rotarySpring : DampedRotarySpring;
		public var material : Material;

		public var walkingSensor : Polygon;

		private var _input : Input;
		private var walkable : Boolean;
		private var reloadCounter : int;

		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;

		public function Character() {
			super(DYNAMIC_BODY);
		}

		override public function initalize() : void {
			super.initalize();
			
			setMaxVelocity(300);
			group = 1;
			
			material = new Material(0.3, 0.5, 1);
			addShape(new Polygon(Polygon.createRectangle(20, 70), new Vector2D(0, -35), material));
			addShape(new Circle(10, new Vector2D(0, 0), material));
			walkingSensor = new Polygon(Polygon.createRectangle(10, 10), new Vector2D(0, 10), null);
			walkingSensor.isSensor = true;
			walkingSensor.collisionCallback = checkWalking;
			addShape(walkingSensor);
			p.setTo(100, 100);
			
			reloadCounter = 0;
		}

		override public function registerSpace(space : Space) : void {
			super.registerSpace(space);
			rotarySpring = new DampedRotarySpring(this, space.defaultStaticBody, 0, 1000000, 70000);
			space.addConstraint(rotarySpring);
		}

		public function checkWalking(s1 : GeometricShape,s2 : GeometricShape, arbiter : Arbiter) : void {
			if (s2 && s2.body.isStatic) {
				walkable = true;
			} 
		}
		
		override public function onStep(dt : int) : void {
			super.onStep(dt);
			processInput();
			if (right && walkable==false) {
				rotarySpring.restAngle = Math.PI / 4;
			} else if (left && walkable==false) {
				rotarySpring.restAngle = -Math.PI / 4;
			} else {
				rotarySpring.restAngle = 0;
			}
			walkable = false;
			reloadCounter -= dt;
		}

		private function processInput() : void {
			up		=	control.up 		= _input.pressed(GameControls.UP);
			down	=	control.down 	= _input.pressed(GameControls.DOWN);
			left	=	control.left 	= _input.pressed(GameControls.LEFT);
			right	=	control.right 	= _input.pressed(GameControls.RIGHT);
			
			if ( (reloadCounter<0) && _input.pressed(200)) fire();
		}

		private function fire() : void {
			reloadCounter = 300;
			trace('fire');
			var firePos:Vector2D = p.clone();
			firePos.x+=10;
			firePos.y-=50;
			//firePos.x += 100;
			//firePos.y /= 3;
			
			var projVelocity:Vector2D = _input.mousePosition.minus(firePos).normalize().multEquals(500);

			var projectileBody:GameRigidBody = new GameRigidBody();
			projectileBody.setMaxVelocity(500);
			projectileBody.p.copy(firePos);
			projectileBody.v.copy(projVelocity);
			//projectileBody.w = 2;
			//projectileBody.group = 0;
			//var material:Material = new Material(0.2, 0.6, 2);
			var material:Material = new Material(0.0, .8, 1);
			var shape:GeometricShape = new Polygon(Polygon.createRectangle(10, 10), Vector2D.zeroVect, material);
			projectileBody.addShape(shape);
			
			space.addRigidBody(projectileBody);
		}
		
		public function set input(input : Input) : void {
			if (control) RemoveForceGenerator(control);
			this._input = input;
			control = new Jetpack();
			AddForceGenerator(control);
		}
	}
}
