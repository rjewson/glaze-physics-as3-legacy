package engine.particle {
	import org.rje.glaze.engine.math.Vector2D;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class ParticleEngine extends Sprite {
		
		public var pcount:int;
		public var startParticle:BitmapParticle;
		public var particleCache:BitmapParticle;
		public var render:Boolean = true;
		
		public var bm:Bitmap;
		public var bmd:BitmapData;
				
		public function ParticleEngine( particleCount:int ) {
			pcount = particleCount;
			startParticle = null;
			var i:int = 0;
			do {
				particleCache = new BitmapParticle(i++,particleCache);
			} while (i<particleCount);
		}
		
		public function reserve():BitmapParticle {
			var p:BitmapParticle = particleCache;
			if (p==null)
				return null;
			particleCache = particleCache.next;
			return p;
		}
		
		public function release( p:BitmapParticle ):void {
			p.next = particleCache;
			particleCache = p;
		}

		public function emitGenericParticle( sX:int , sY:int , vX:Number , vY:Number , alive:int , decayable:Boolean , friction:Number , gravity:Number , colour:uint , external:Vector2D , top:Boolean , cullAlpha:Number = 0.1):void {
			var p:BitmapParticle = reserve();
			if (p==null) return;
			p.Init(startParticle,sX,sY,vX,vY,alive,decayable,friction,gravity,colour,external,top,cullAlpha);
			startParticle = p;	
			p.visible = render;
			top ? addChild(p) : addChildAt(p,0);
		}
			
		public function updateGenericParticles( deltaTime:int ):void {
			var p:BitmapParticle  = startParticle;
			var lp:BitmapParticle = null;
			while (p!=null) {
				if (p.Update(deltaTime)) {
					lp = p;
					p  = p.next;
				} else {
					 removeChild(p);
					 if (p==startParticle) {
						startParticle = p.next;
						release(p);
						p = startParticle;
					 } else {
						lp.next = p.next;
						release(p);
						p = lp.next;
					 }
				}				
			}
		}
	}
}
