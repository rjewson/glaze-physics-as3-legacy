package engine.util {
	import flash.events.MouseEvent;
	import org.rje.glaze.engine.math.Vector2D;

	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	/**
	 * @author Richard.Jewson
	 */
	public class Input {
		
		public var keyMap:Vector.<int>;
		
		public var mousePosition:Vector2D;
		//public var mousePreviousPosition:Vector2D;
		
		private var frameRef : int;
		
		private var stage : Stage;

		public function Input(stage:Stage) {
			this.stage = stage;
			keyMap = new Vector.<int>(256,false);
			mousePosition = new Vector2D();
			//mousePreviousPosition = new Vector2D();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}


		public function update() : void {
			frameRef++;
			mousePosition.x = stage.mouseX;
			mousePosition.y = stage.mouseY;
		}
		
		private function keyDown(event : KeyboardEvent) : void {
			keyMap[event.keyCode] = -1;
		}

		private function keyUp(event : KeyboardEvent) : void {
			keyMap[event.keyCode] = frameRef;
		}

		private function mouseDown(event : MouseEvent) : void {
			keyMap[200] = -1;
		}

		private function mouseUp(event : MouseEvent) : void {
			keyMap[200] = frameRef;
		}
		
		public function pressed(keyCode:int) : Boolean {
			return (keyMap[keyCode] == -1); 
		}

		public function released(keyCode:int) : Boolean {
			return (keyMap[keyCode] == frameRef-1); 
		}
		
		
	}
}
