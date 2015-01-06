package test {
	import org.rje.glaze.engine.dynamics.Material;

	import game.entities.Character;
	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.collision.shapes.Polygon;

	import engine.world.WorldData;

	/**
	 * @author Richard.Jewson
	 */
	public class TestWorldData extends WorldData {

		override public function setupWorldData() : void {
			playerCharacter = new Character();

			allStaticShapes.push( new Polygon(Polygon.createRectangle(500, 20), new Vector2D(300, 500) , null ) );
			allStaticShapes.push( new Polygon(Polygon.createRectangle(10, 100), new Vector2D(400, 450) , null ) );
		}
		
	}
}
