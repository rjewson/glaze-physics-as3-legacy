package engine.particle {
	import org.rje.glaze.engine.math.Vector2D;

	public class Emitters {
		
		public static function destroyedItemHazeRect( pe:ParticleEngine , pos:Vector2D , halfWidth:Vector2D , density:Number ):void {
			density *= 3;
			var bm:int = 5;
			var xC:int = halfWidth.x;
			var yC:int = halfWidth.y;
			for (var x:int = 0; x < xC; x+=density ) {
				for (var y:int = 0; y < yC; y+=density) {
					pe.emitGenericParticle(pos.x+x,pos.y+y,Emitters.randomRange(-bm,bm),Emitters.randomRange(-bm,bm) , Emitters.randomRange(2000,8000) , true , 0 , 0 ,  randomGrey() , null , false , 0.3);
					pe.emitGenericParticle(pos.x-x,pos.y+y,Emitters.randomRange(-bm,bm),Emitters.randomRange(-bm,bm) , Emitters.randomRange(2000,8000) , true , 0 , 0 ,  randomGrey() , null , false , 0.3);
					pe.emitGenericParticle(pos.x+x,pos.y-y,Emitters.randomRange(-bm,bm),Emitters.randomRange(-bm,bm) , Emitters.randomRange(2000,8000) , true , 0 , 0 ,  randomGrey() , null , false , 0.3);
					pe.emitGenericParticle(pos.x-x,pos.y-y,Emitters.randomRange(-bm,bm),Emitters.randomRange(-bm,bm) , Emitters.randomRange(2000,8000) , true , 0 , 0 ,  randomGrey() , null , false , 0.3);					
				}
			}
		}
		
		public static function explosionA(pe:ParticleEngine , pos:Vector2D , n:Vector2D , power:int , density:Number ):void {
			power /= 8;
			if (power>200)
				power=200;
			for (var i:int = 0; i < power; i++) {
				pe.emitGenericParticle(pos.x,pos.y,Emitters.randomRange(-power,power),Emitters.randomRange(-power,power) , Emitters.randomRange(500,2000) , true , 0 , 0 ,  randomFire() , null , false , 0.3);
				pe.emitGenericParticle(pos.x,pos.y,Emitters.randomRange(-power/2,power/2),Emitters.randomRange(-power/2,power/2) , Emitters.randomRange(500,2000) , true , 0 , 0 ,  randomFire() , null , false , 0.3);	
			}
		}
				
		public static function fire( x:int , y:int , pe:ParticleEngine , frame:int , dt:int , externalForce:Vector2D ):void {
			if ((frame & 5) == 0)
				pe.emitGenericParticle(x-4,y,randomRange(-3,1),randomRange(-10,0) , randomRange(700,2000) , true , 0 , 0 , 0xFFFF0000 , externalForce , true);
				pe.emitGenericParticle(x,y,randomRange(-3,3),randomRange(-10,0) , randomRange(1200,2400) , true , 0 , 0 , 0xFFFF0000 , externalForce , true);
				pe.emitGenericParticle(x+4,y,randomRange(-1,3),randomRange(-10,0) , randomRange(700,2000) , true , 0 , 0 , 0xFFFF0000 , externalForce , true);
			//pe.emitGenericParticle(x,y,randomRange(-3,3),randomRange(-10,0) , randomRange(1000,2000) , true , 0 , 0 , 0xFFFF0000 , externalForce , true);
			//pe.emitGenericParticle(x,y,randomRange(-3,3),randomRange(-10,0) , randomRange(1000,2000) , true , 0 , 0 , 0xFFFF8000 , externalForce , true);
			if ((frame & 4) == 0)
				pe.emitGenericParticle(x,y,randomRange(-1,1),randomRange(-30,-3) , randomRange(2000,7000) , true , 0 , 0 , 0xFFAAAAAA , externalForce , false , 0.3);
		}
		
		public static function explosion1( x:int , y:int , pe:ParticleEngine , frame:int , dt:int , size:int ):void {
			while (size>0) {
				pe.emitGenericParticle(x,y,randomRange(-20,20),randomRange(-20,20) , randomRange(1000,2000) , true , 0.05 , 1 , 0xFFFF0000 , null , true);
				pe.emitGenericParticle(x,y,randomRange(-20,20),randomRange(-20,20) , randomRange(1000,2000) , true , 0.05 , 1 , 0xFFFFFF00 , null , true);
				pe.emitGenericParticle(x,y,randomRange(-20,20),randomRange(-20,20) , randomRange(1000,2000) , true , 0.05 , 1 , 0xFFFF8000 , null , true);
				size-=3;
			}
		}
		
		public static function burst1( x:int , y:int , pe:ParticleEngine , frame:int , dt:int , size:int ):void {
			pe.emitGenericParticle(x+1,y+1,0,0 , randomRange(1000,2000) , false , 0.1 , 0 , 0xFFFF0000 , null , true , 0.2);
			pe.emitGenericParticle(x+1,y+0,0,0 , randomRange(1000,2000) , false , 0.1 , 0 , 0xFFFF0000 , null , true , 0.2);
			pe.emitGenericParticle(x+0,y+1,0,0 , randomRange(1000,2000) , false , 0.1 , 0 , 0xFFFF0000 , null , true , 0.2);
			pe.emitGenericParticle(x,y,0,0     , randomRange(1000,2000) , false , 0.1 , 0 , 0xFFFF0000 , null , true , 0.2);

			while (size>0) {
				pe.emitGenericParticle(x,y,randomRange(-50,50),randomRange(-50,50) , randomRange(1000,2000) , false , 0.1 , 0 , 0xFFFF0000 , null , true , 0.2);
				size-=1;
			}
		}
		
		public static function fireball( x:int , y:int , pe:ParticleEngine , frame:int , dt:int , size:int ):void {
			while (size>0) {
				pe.emitGenericParticle(x,y,randomRange(-10,10),randomRange(-10,10) , randomRange(500,800) , true , 0 , 0 , 0xFFFF0000 , null , true , 0);
				pe.emitGenericParticle(x,y,randomRange(-10,10),randomRange(-10,10) , randomRange(500,800) , true , 0 , 0 , 0xFFFFFF00 , null , true , 0);
				size-=1;
			}
		}
		
		public static function randomRange(min:Number, max:Number):Number {
			return Math.round(Math.random() * (max - min + 1)) + min;
		}
		
		public static function randomGrey():uint {
			var g:uint = Math.round(Math.random() * 255);
			var a:uint = 0xff;
			var colour:uint = a << 24 | g << 16 | g << 8 | g;
			return colour;
		}
		
		public static function randomFire():uint {
			var r:uint = randomRange(200, 255)
			var g:uint = randomRange(0, 25)
			var colour:uint = 0xFF << 24 | r << 16 | g << 8 | 0x00;
			return colour;
		}
		
	}
	
}
