package engine.particle {
	import org.rje.glaze.engine.math.Vector2D;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BitmapParticle extends Bitmap {
		
		public var positionX:Number;
		public var positionY:Number;
		public var velocityX:Number;
		public var velocityY:Number;
		public var gravity:Number;
		
		public var external:Vector2D;

		public var decayable:Boolean = true;
		public var ttl:int;
		public var colour:uint;
		public var cullAlpha:Number;
		public var rdt:Number;
		public var age:int;
		public var next:BitmapParticle;
		public var id:int;
		public var friction:Number;
		public var acceleration:Vector2D = new Vector2D(0,0);
		public var bmd:BitmapData = new BitmapData(3,3,false);
		public var top:Boolean;
		
		public function BitmapParticle( id:int = 0 , next:BitmapParticle = null ) {
			this.id = id;
			this.next = next;
			this.bitmapData = bmd;
		}
				
		public function Init( nextParticle:BitmapParticle , sX:int , sY:int , vX:Number , vY:Number , ttl:int , decayable:Boolean , friction:Number , gravity:Number , colour:uint , external:Vector2D , top:Boolean , cullAlpha:Number = 0.1 ):void {
			this.x = positionX = sX;
			this.y = positionY = sY;
			velocityX = vX;
			velocityY = vY;
			this.ttl = age = ttl;
			this.colour = colour;
			this.decayable = decayable;
			this.next=nextParticle;
			this.friction = 1-friction;
			this.gravity = gravity;
			this.alpha = 1;
			this.bmd.lock();
			this.bmd.setPixel32(0,0,colour);
			this.bmd.setPixel32(0,1,colour);
			this.bmd.setPixel32(0,2,colour);
			this.bmd.setPixel32(1,0,colour);
			this.bmd.setPixel32(1,1,colour);
			this.bmd.setPixel32(1,2,colour);
			this.bmd.setPixel32(2,0,colour);
			this.bmd.setPixel32(2,1,colour);
			this.bmd.setPixel32(2,2,colour);
			this.bmd.unlock();
			this.external = external;
			this.top = top;
			this.cullAlpha = cullAlpha;
		}
		
		public function Update(deltaTime:int):Boolean {
			velocityY += gravity;
			velocityX *= friction;
			velocityY *= friction;
			if (external!=null) {
				velocityX += external.x;
				velocityY += external.y;
			}
			rdt = deltaTime/1000;
			positionX += (velocityX * rdt);
			positionY += (velocityY * rdt);
			
			this.x = int(positionX);
			this.y = int(positionY);

			age -= deltaTime;
			if (decayable) {
				this.alpha = (age/ttl);
				return (this.alpha>cullAlpha);
			}
			return (age>0);
		}
		
		public function ApplyForce(f:Vector2D):void {
			velocityX += f.x;
			velocityY += f.y;
		}
	}
}
