package engine {
	import engine.util.Input;

	import game.entities.Character;
	import org.rje.glaze.engine.dynamics.Arbiter;
	import test.TestWorldData;

	import org.rje.glaze.engine.math.Vector2D;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class Game extends Sprite {

		public var debug : Boolean = false;
		public var debugSprite : Sprite;

		public var frameCount : int;

		public var count : int;

		public var gameEngine : Engine;
		public var input:Input;
		
		public var character : Character;

		public function Game() : void {
		}

		public function initalizeGame() : void {
			debugSprite = new Sprite();
			addChild(debugSprite);
			
			//Setup event listeners
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var gameOptions:GameOptions = new GameOptions();
			gameOptions.fps = 30;
			gameOptions.pps = 30;
			gameOptions.gravity = new Vector2D(0,250);
			gameOptions.cameraDimensions = new Vector2D(600,600);
			
			input = new Input(stage);
			
			gameEngine = new Engine(new TestWorldData(),input, gameOptions);
			addChild(gameEngine.camera);
			
			character = gameEngine.world.worldData.playerCharacter;
			character.input = input;
		}

		public function onEnterFrame(event : Event) : void {
			debugSprite.graphics.clear();
			frameCount++;
			input.update();
			gameEngine.step();
			
			//if (input.released(200)==true)trace('mouse up');
			//if (input.released(65)==true)trace('a up');
		}

	}
}