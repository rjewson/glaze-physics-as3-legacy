package engine.entities {
	import engine.Engine;
	import org.rje.glaze.engine.dynamics.RigidBody;

	/**
	 * @author Richard.Jewson
	 */
	public class GameRigidBody extends RigidBody {
		
		public function GameRigidBody(type:int = DYNAMIC_BODY, m:Number = -1 , i:Number = -1) {
			super(type, m, i);
			initalize();
		}
		
		public function initalize() : void {
		}
		
	}
}
