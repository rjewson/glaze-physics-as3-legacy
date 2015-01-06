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

package {
	import org.rje.glaze.engine.collision.shapes.GeometricShape;
	import org.rje.glaze.engine.collision.shapes.Polygon;
	import org.rje.glaze.engine.dynamics.Arbiter;
	import org.rje.glaze.engine.dynamics.BodyContact;
	import org.rje.glaze.engine.dynamics.Contact;
	import org.rje.glaze.engine.dynamics.Forces;
	import org.rje.glaze.engine.dynamics.Material;
	import org.rje.glaze.engine.dynamics.RigidBody;
	import org.rje.glaze.engine.dynamics.constraints.Constraint;
	import org.rje.glaze.engine.dynamics.constraints.DampedRotarySpring;
	import org.rje.glaze.engine.dynamics.constraints.DampedSpring;
	import org.rje.glaze.engine.math.Ray;
	import org.rje.glaze.engine.math.Vector2D;
	import org.rje.glaze.engine.space.Space;
	import org.rje.glaze.tests.Test;
	import org.rje.glaze.tests.basicstacktest.BasicStackTest;
	import org.rje.glaze.tests.jointtest.JointTest;
	import org.rje.glaze.tests.raytest.RayTest;
	import org.rje.glaze.util.FPSMeter;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	

	public class TestBed extends flash.display.Sprite {
		
		public var version:String = "0.3";
		public var lmb:Boolean;
		public var mousePos:Vector2D = new Vector2D();
		public var mouseWheelValue:int = 0;
		public var stageDim:Vector2D;
		public var screenCenter:Vector2D;
		public var space:Space;
		
		public var shiftDown:Boolean = false;
		public var XDown:Boolean = false;
		public var RDown:Boolean = false;
		public var dragging:Boolean = false;
		public var plotGraphics:Boolean = true;
		
		public var dragBody:RigidBody;
		
		public var attract:Boolean = false;
		public var flashy:Boolean = false;
		
		public var storedSpace:ByteArray;
		
		public var debug:Boolean = false;
		
		public var test:Test;
		
		//public var fpscounter:FPSCounter;
		
		public var staticSprite:Sprite;
		public var debugSprite:Sprite;
		
		public var upAngle:Number;
		
		public var frameCount:int;
		
		public var bfAlgos:Array = [ "SORTSWEEP" , "SPACIALHASH" , "BRUTEFORCE" ];
		public var bfAlgoSelector:int = 0;
		
		public var lastDemoID:int;
		
		public var spring1:DampedSpring, spring2:DampedSpring, spring3:DampedSpring, spring4:DampedSpring;
		public var rotarySpring: DampedRotarySpring;
		
		public var springLoc1:Vector2D = new Vector2D(), springLoc2:Vector2D = new Vector2D(), springLoc3:Vector2D = new Vector2D(), springLoc4:Vector2D = new Vector2D();
		private var demoContainer : Sprite;
		private var infoPanel : Sprite;
		private var testUIContainer : Sprite;
		private var infoText : XML;
		private var infoTextField : TextField;
		private var style : StyleSheet;

		public function TestBed():void {

			debugSprite = new Sprite();
			//staticSprite = new Sprite();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			
			//Setup event listeners
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardDownEvent);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyboardUpEvent);
						
			//Set stage dimension for demos
			stageDim = new Vector2D(600, 600);
			screenCenter = stageDim.mult(0.5);
			//Create and add the FPS counter
			//fpscounter = new FPSCounter();
			//this.addChild(fpscounter);
			
			upAngle = Math.atan2( 0, 1);
			
			initalizeInterface();
			
			//Set inital demo
			setDemo(1);
		}

		private function initalizeInterface() : void {
			
			demoContainer = new Sprite();
			addChild(demoContainer);
			
			addChild(new FPSMeter());
			
			infoPanel = new Sprite();
			infoPanel.x = 594;
			infoPanel.y = 1;
			infoPanel.graphics.lineStyle(2,0);
			infoPanel.graphics.beginFill(0xEEEEEE);
			infoPanel.graphics.drawRoundRect(0, 0, 204, 598,4);
			infoPanel.graphics.endFill();

			addChild(infoPanel);
			
			infoText = <xml>
							Title:<title></title>
							PPS:<pps></pps>
							Iterations:<iterations></iterations>
							Count:<count></count>
					   </xml>;
			
			style = new StyleSheet();
			style.setStyle("xml", {fontSize:'11px', fontFamily:'_sans', leading:'-2px'});
			style.setStyle("title", {display:'block'});
			style.setStyle("pps", {display:'block'});
			style.setStyle("iterations", {display:'block'});
			style.setStyle("count", {display:'block'});
			//style.setStyle("ms", {color: hex2css(theme.ms)});
			//style.setStyle("mem", {color: hex2css(theme.mem)});
			//style.setStyle("memMax", {color: hex2css(theme.memmax)});
			
			infoTextField = new TextField();
			infoTextField.width = 190;
			infoTextField.height = 300;
			infoTextField.styleSheet = style;
			infoTextField.condenseWhite = true;
			infoTextField.selectable = false;
			infoTextField.mouseEnabled = false;
			infoPanel.addChild(infoTextField);
			
			testUIContainer = new Sprite();
			testUIContainer.x = 4;
			testUIContainer.y = 450;
			infoPanel.addChild(testUIContainer);
			
		}

		
		//This is where everthing is called from.  At the moment the physics frame rate is
		//tied to the graphics frame rate.  The physics are update n time per frame where n = the value of 'steps'
		public function onEnterFrame(event:Event):void {
			
			//Clear the stage graphics (everything is drawn here for speed at the moment)
			demoContainer.graphics.clear();
			debugSprite.graphics.clear();
			
			//Update the demo, only used if we need to manual adjust a shape; e.g. the orientation of the static body
			test.update(1 / stage.frameRate );
			
			//Step the engine n times.  The higher n, the more accurate things get.
			space.step();
			
			//Draw everything
			if (plotGraphics) {
				var shape:GeometricShape = space.activeShapes;
				while (shape) {
					shape.draw(demoContainer.graphics);
					shape = shape.next;
				}
				shape = space.staticShapes;
				while (shape) {
					shape.draw(demoContainer.graphics);
					shape = shape.next;
				}
				var constraint:Constraint = space.constraints;
				while (constraint) {
					constraint.draw(demoContainer.graphics);
					constraint = constraint.next;
				}			
				
				if (RDown) {
					var ray:Ray = new Ray(screenCenter, mousePos);
					ray.returnNormal = true;
					space.castRay(ray);
					demoContainer.graphics.moveTo(screenCenter.x, screenCenter.y);
					demoContainer.graphics.lineStyle(3, 0xB56A6A);
					demoContainer.graphics.lineTo( screenCenter.x + (ray.direction.x * 100) , screenCenter.y + (ray.direction.y * 100) );
					demoContainer.graphics.lineTo( screenCenter.x, screenCenter.y);
					if (ray&&ray.intersectInRange) {
						var cPoint:Vector2D = ray.closestIntersectPoint;
						demoContainer.graphics.lineStyle(4, 0xF81A14);
						demoContainer.graphics.moveTo(cPoint.x - 5, cPoint.y - 5);
						demoContainer.graphics.lineTo(cPoint.x + 5, cPoint.y + 5);
						demoContainer.graphics.moveTo(cPoint.x + 5, cPoint.y - 5);
						demoContainer.graphics.lineTo(cPoint.x - 5, cPoint.y + 5);
						if (ray.returnNormal&&ray.closestIntersectNormal) {
							demoContainer.graphics.lineStyle(2, 0x24C507);
							demoContainer.graphics.moveTo(cPoint.x , cPoint.y );
							demoContainer.graphics.lineTo(cPoint.x +(ray.closestIntersectNormal.x*15), cPoint.y+(ray.closestIntersectNormal.y*15) );
						}
						if (ray.closestIntersectShape)
							ray.closestIntersectShape.body.ApplyForces(ray.direction.mult(1000*test.forceFactor), cPoint.minus(ray.closestIntersectShape.body.p));
					}
				}

				
				//If debug, the draw AABB's
				if (debug) {
					var contact:Contact;
					var arbiter:Arbiter = space.arbiters;
					demoContainer.graphics.lineStyle(1, 0xFF0000);
					while (arbiter!=null) {
						contact = arbiter.contacts;
						while (contact!=null) {
							graphics.drawRect(contact.p.x - 1, contact.p.y - 1, 2, 2);
							contact = contact.next;
						}
						arbiter = arbiter.next;
					}
					var bodyContact:BodyContact;
					for (bodyContact = space.bodyContacts.next; bodyContact.sentinel != true; bodyContact = bodyContact.next ) {
						demoContainer.graphics.moveTo(bodyContact.bodyA.p.x, bodyContact.bodyA.p.y);
						//demoContainer.graphics.lineStyle(1, 0xFF0000);
						demoContainer.graphics.lineStyle(bodyContact.contactCount, bodyContact.startContact ? 0x00FF00 : 0xFF0000);
						if (bodyContact.bodyB.isStatic) {
							demoContainer.graphics.drawCircle(bodyContact.bodyA.p.x, bodyContact.bodyA.p.y,5);
						} else {
							demoContainer.graphics.lineTo(bodyContact.bodyB.p.x, bodyContact.bodyB.p.y);
						}
					}
				}
			}
			
			if (attract) {
				var body:RigidBody = space.activeBodies;
				while (body) {
					Forces.LinearAttractor(body, mousePos, 1000 * test.forceFactor);
					body = body.next;
					//Forces.InverseSqrAttractor(body, mousePos, 2000);
				}
			}
			
			if (frameCount % 30) updateInfoString();
			
			frameCount++;

		}
		
		//If mouse is down, fire block.
		public function onMouseDown(event:MouseEvent):void {
			//if (event.eventPhase == EventPhase.AT_TARGET) {
				lmb = true;	
				
				if (shiftDown) {
					attract = true;
				} else if (XDown) {
					deleteBodyUnderMouse();
				} else {
					fireBlock();
				}
			//}
		}
		
		//If mouse is up
		public function onMouseUp(event:MouseEvent):void {
			if (event.eventPhase == EventPhase.AT_TARGET) {
				lmb = false;
				attract = false;
			}
		}
		
		//If mouse is moved
		public function onMouseMove(event:MouseEvent):void {
			mousePos.setTo(event.stageX, event.stageY);
			if (dragging) updateDragSprings();
		}
		
		//If mouse wheel is moved
		public function onMouseWheel(event:MouseEvent):void {
			mouseWheelValue += (event.delta < 0) ? 1 : -1;
		}
		
		public function updateDragSprings():void {
			springLoc1.x = mousePos.x - 20;
			springLoc1.y = mousePos.y - 20;
			springLoc2.x = mousePos.x + 20;
			springLoc2.y = mousePos.y - 20;
			springLoc3.x = mousePos.x + 20;
			springLoc3.y = mousePos.y + 20;
			springLoc4.x = mousePos.x - 20;
			springLoc4.y = mousePos.y + 20;			
		}
		
		//If key is pressed
		public function onKeyboardDownEvent(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.SPACE: 
					debug = !debug; 
					if (debug) 
						this.addChild(debugSprite);
					else
						this.removeChild(debugSprite);
					return;
				//Dump engine info to system clipboard.  Can the be pased into text editor of choice
				case Keyboard.ENTER:		
					bfAlgoSelector++;
					if (bfAlgoSelector == bfAlgos.length) bfAlgoSelector = 0;
					setDemo(lastDemoID);
					return;
				case Keyboard.SHIFT: shiftDown = true; return;
				case 68:
					if (dragging) return;
					var dragShape:GeometricShape = space.getShapeAtPoint(mousePos);
					if (dragShape != null) {
						dragBody = dragShape.body;
						dragging = true; 
						//dragBody.w = 0;
						
						updateDragSprings();
						
						var strength:Number = 500;
						var damping:Number = 5;
						var len:Number = 28;						
						
						spring1 = new DampedSpring(dragBody, space.defaultStaticBody, new Vector2D() ,springLoc1, len, strength, damping);
						spring2 = new DampedSpring(dragBody, space.defaultStaticBody, new Vector2D() ,springLoc2, len, strength, damping);
						spring3 = new DampedSpring(dragBody, space.defaultStaticBody, new Vector2D() ,springLoc3, len, strength, damping);
						spring4 = new DampedSpring(dragBody, space.defaultStaticBody, new Vector2D() ,springLoc4, len, strength, damping);
						rotarySpring = new DampedRotarySpring(dragBody, space.defaultStaticBody, 0, 10000, 70);
						
						space.addConstraint(spring1);
						space.addConstraint(spring2);
						space.addConstraint(spring3);
						space.addConstraint(spring4);
						space.addConstraint(rotarySpring);
						

					}
					return;
				case 71: plotGraphics = !plotGraphics; return;
				case 82: RDown = true; return;
				case 88: XDown = true; return;
				
				//Set which demo you want
				case 49:/*1*/  setDemo(1); return;
				case 50:/*2*/  setDemo(2); return;
				case 51:/*3*/  setDemo(3); return;
				case 52:/*4*/  setDemo(4); return;
				case 53:/*5*/  setDemo(5); return;
				case 54:/*6*/  setDemo(6); return;
				case 55:/*7*/  setDemo(7); return;
				case 56:/*8*/  setDemo(8); return;
				case 57:/*9*/  setDemo(9); return;
			}
		}

		public function onKeyboardUpEvent(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.SHIFT: shiftDown = false; return;
				case 68: dragging = false; 
						 
						 space.removeConstraint(spring1);
						 space.removeConstraint(spring2);
						 space.removeConstraint(spring3);
						 space.removeConstraint(spring4);
						 space.removeConstraint(rotarySpring);
						 
						 return;
				case 82: RDown = false; return;
				case 88: XDown = false; return;
			}
		}		
		
		//Util function to set demo
		public function setDemo( demoID:int ):void {
			
			if (testUIContainer.numChildren>0) testUIContainer.removeChildAt(0);
			
			lastDemoID = demoID;
			
			var newTest:Test;
			
			switch (demoID) {
				case 1:/*0*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 2:/*1*/ newTest = new RayTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 3:/*2*/ newTest = new JointTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 4:/*3*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 5:/*4*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 6:/*5*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 7:/*6*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 8:/*7*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 9:/*8*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
				case 0:/*9*/ newTest = new BasicStackTest(stage.frameRate, stageDim, bfAlgos[bfAlgoSelector]); break;
			}
			newTest.initTestInterface();
			testUIContainer.addChild(newTest.testControlsContainer);
			this.test = newTest;
			space = test.testSpace;
			updateInfoString();
			//fpscounter.refreshText();
		}
		
		public function updateInfoString():void {
			
			infoText.title = "the title" ;
			infoText.pps = "pps";
			infoText.iterations = "iterations";
			infoText.count = "count";
			
			infoTextField.htmlText = infoText;
		}
			
		//Fires a block into the scene
		public function fireBlock():void {
			var firePos:Vector2D = stageDim.clone();
			firePos.x += 100;
			firePos.y /= 3;
			
			var projVelocity:Vector2D = mousePos.minus(firePos).normalize().multEquals(800);

			var projectileBody:RigidBody = new RigidBody();
			projectileBody.setMaxVelocity( -1);
			projectileBody.p.copy(firePos);
			projectileBody.v.copy(projVelocity);
			projectileBody.w = 2;
			var material:Material = new Material(0.5, 1, 5);
			projectileBody.addShape(new Polygon(Polygon.createRectangle(10, 10), Vector2D.zeroVect, material));
			//projectileBody.addShape(new AxisAlignedBox(new Vector2D(20,20), new Vector2D(20,0)));
			
			space.addRigidBody(projectileBody);
		}

		public function deleteBodyUnderMouse():void {
			var shape:GeometricShape = space.getShapeAtPoint(mousePos);
			if (shape != null) 
				space.removeRigidBody(shape.body);
		}		
	}
}