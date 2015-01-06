// glaze - 2D rigid body dynamics & game engine
// Copyright (c) 2010, Richard Jewson
// 
// This project also contains work derived from the Chipmunk & APE physics engines.  
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package org.rje.glaze.tests {
	import org.rje.glaze.util.ButtonEvent;
	import flash.display.Sprite;

	import org.rje.glaze.engine.collision.shapes.*;
	import org.rje.glaze.engine.dynamics.*;
	import org.rje.glaze.engine.math.*;
	import org.rje.glaze.engine.space.*;	

	public class Test {
		
		public var space:Space;
		public var staticShape:GeometricShape;
		public var dim:Vector2D;
		public var floor:Number;
		public var staticColour:uint = 0xE8EC95;
		
		public var title:String;
		public var comment:String;
		
		public var forceFactor:Number = 1;
		public var fps : int;
		public var pps : int;
		public var iterations : int;
		
		public var testControlsContainer:Sprite;

		public function Test( dim:Vector2D , bfAlgo:String, iterations:int = 20, fps:int = 30 , pps:int = 90 ) {
			this.fps = fps;
			this.pps = pps;
			this.iterations = iterations;
			this.dim = dim;

			switch (bfAlgo) {
				case "SORTSWEEP"    : space = new SortAndSweepSpace(fps, pps, null); break;
				case "SPACIALHASH"  : space = new SpacialHashSpace( fps, pps, null, 257, 60); break;
				default             : space = new BruteForceSpace(fps, pps, null); break;
			}

			space.iterations = iterations;
			
			testControlsContainer = new Sprite();
			testControlsContainer.addEventListener(ButtonEvent.BUTTON_EVENT, onButtonClick);
			initSpace();
			space.syncBroadphase();
		}


		public virtual function initTestInterface():void {
		}

		public virtual function initSpace():void {
		}

		private function onButtonClick(event : ButtonEvent) : void {
			doUIAction(event.id);
		}
		
		public virtual function get testSpace():Space {
			return space;
		}
		
		public virtual function update(dt:Number):void {
		}

		public virtual function doUIAction(id:int):void {
		}
		
		public function createFloor( material:Material = null ):void {
			floor = dim.y - 20;
			staticShape = new Polygon(Polygon.createRectangle(dim.x, 10), new Vector2D(dim.x / 2, dim.y) , material );
			staticShape.fillColour = staticColour;
			space.defaultStaticBody.addShape(staticShape);
		}	
		
		public function addPolyAsNewBody( x:Number, y:Number, a:Number , verts:Array , material:Material = null ):RigidBody {
			var polyBody:RigidBody = new RigidBody(RigidBody.DYNAMIC_BODY);
			polyBody.p.setTo( x, y );
			polyBody.setAngle(a);
			var polyShape:GeometricShape = polyBody.addShape(new Polygon(verts, Vector2D.zeroVect, material));
			space.addRigidBody(polyBody);
			//polyBody.rotationLocked = true;
			return polyBody;
		}
		
		public function addCircleAsNewBody( x:Number, y:Number, radius:Number , material:Material = null ):RigidBody {
			var circleBody:RigidBody = new RigidBody(RigidBody.DYNAMIC_BODY);
			circleBody.p.setTo( x, y );
			var circleShape:GeometricShape = circleBody.addShape(new Circle(radius, Vector2D.zeroVect, material));
			space.addRigidBody(circleBody);
			//polyBody.rotationLocked = true;
			return circleBody;
		}		
		
		public static function randomRange(min:Number, max:Number):Number {
			return Math.round(Math.random() * (max - min + 1)) + min;
		}
		
		public static function deg2rad(deg:Number):Number {
			return deg * Math.PI / 180;
		}
		
	}
	
}