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

package org.rje.glaze.tests.basicstacktest {
	import org.rje.glaze.util.Button;

	import flash.display.Sprite;

	import org.rje.glaze.tests.Test;
	import org.rje.glaze.engine.collision.shapes.*;
	import org.rje.glaze.engine.dynamics.*;
	import org.rje.glaze.engine.math.*;	

	public class BasicStackTest extends Test {
		
		public var side:Number = 10;//30;// 30;
		public var height:int = 0; //18
		public var yGap:int = 20;
		
		private var boxShape:Array;
		private var material:Material;
		
		public function BasicStackTest(fps:int, dim:Vector2D , bfAlgo:String) {
			super(dim,bfAlgo,18,fps,90);
			space.masslessForce.setTo(0, 300);
			title = "Basic Stack";
			forceFactor = 10;
		}
		
		public override function initTestInterface():void {
			testControlsContainer.addChild(new Button("Add Block",196,1));
		}
		
		public override function initSpace():void {
			createFloor();
			boxShape = Polygon.createRectangle(side, side);
			material = new Material(0.0, .8, 1);
		}

		private function createNewBlock() : void {
			var startY:Number = floor - (side / 2);
			var box:RigidBody = addPolyAsNewBody( dim.y/2 - side , startY - (height * side) - (height * yGap) , 0, boxShape, material);
			height++;
		}

		override public function doUIAction(id : int) : void {
			switch(id){
				case 1:
					createNewBlock();
					break;
				default:
			}
		}
	}
}
