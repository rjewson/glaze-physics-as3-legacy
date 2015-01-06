package engine.world {
	import org.rje.glaze.engine.collision.shapes.GeometricShape;

	import flash.display.Graphics;

	/**
	 * @author Richard.Jewson
	 */
	public class World {

		public var worldData : WorldData;

		public function World(worldData : WorldData) {

			this.worldData = worldData;
		}

		public function renderAll(g : Graphics) : void {
			for each (var shape : GeometricShape in worldData.allStaticShapes) {
				shape.draw(g);		
			}
		}
	}
}
