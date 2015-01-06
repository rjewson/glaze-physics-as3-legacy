package {
	import engine.Game;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Richard.Jewson
	 */
	public class Main extends Sprite {
		
		public var game:Game;
		
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event : Event) : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			game = new Game();
			addChild(game);
			game.initalizeGame();
		}
	}
}
