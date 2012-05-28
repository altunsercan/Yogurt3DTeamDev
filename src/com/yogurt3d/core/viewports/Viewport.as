package com.yogurt3d.core.viewports
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.managers.IDManager;
	import com.yogurt3d.core.objects.interfaces.IEngineObject;
	import com.yogurt3d.core.render.BackBufferRenderTarget;
	import com.yogurt3d.core.render.base.RenderTargetBase;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.utils.InputManager;
	
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Viewport extends Sprite 
	{
		private static var viewports			:Vector.<uint> = Vector.<uint>([0,1,2]);
		
		private var m_device:Context3D;
		
		public  var autoUpdate:Boolean = true;
		
		private var m_currentRenderTarget:RenderTargetBase;

		private var m_viewportID				:uint;
		
		private var m_width:uint;
		
		private var m_height:uint;
		
		public function Viewport( _width:uint = 800, _height:uint = 600)
		{
			super();
			
			m_currentRenderTarget = new BackBufferRenderTarget();
			
			if( viewports.length > 0 )
			{
				// get an empty stage3d index
				m_viewportID = viewports.shift();
			}else{
				throw new Error("Maximum 3 viewports are supported. You must dispose before creating a new one.");
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			height = _height;
			width = _width;
		}
		public function get scene():Scene3D{
			return m_currentRenderTarget.scene;
		}
		public function set scene(value:Scene3D):void{
			m_currentRenderTarget.scene = value;
		}
		public function get camera():Camera3D{
			return m_currentRenderTarget.camera;
		}
		public function set camera(value:Camera3D):void{
			m_currentRenderTarget.camera = value;
		}
		public override function set x( value:Number ):void{
			stage.stage3Ds[ m_viewportID ].x = value;
		}
		public override function set y( value:Number ):void{
			stage.stage3Ds[ m_viewportID ].y = value;
		}
		public override function set width( value:Number ):void{
			if( m_currentRenderTarget is BackBufferRenderTarget ){
				BackBufferRenderTarget(m_currentRenderTarget).drawRect.width = value;
			}
			m_width = value;
			drawBackground();
		}
		public override function set height( value:Number ):void{
			if( m_currentRenderTarget is BackBufferRenderTarget ){
				BackBufferRenderTarget(m_currentRenderTarget).drawRect.height = value;
			}
			m_height = value;
			drawBackground();
		}
		protected function onAddedToStage( _event:Event ):void{
			// create context
			stage.stage3Ds[m_viewportID].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated );
			stage.stage3Ds[m_viewportID].addEventListener(ErrorEvent.ERROR, onError );
			stage.stage3Ds[m_viewportID].requestContext3D();
			
			InputManager.setTriggerViewport( stage );
			
			Yogurt3D.registerViewport( this );
			drawBackground();
		}
		protected function onRemovedFromStage( _event:Event ):void{
			Yogurt3D.deregisterViewport( this );
		}
		private function onError( _event:Event ):void{
			stage.stage3Ds[m_viewportID].removeEventListener(ErrorEvent.ERROR, arguments.callee );
			var text:TextField = new TextField();
			text.text = "Add wmode=\"direct\" to params.";
			text.width = 600;
			addChild( text );
		}
		private function onContextCreated( _event:Event ):void{
			m_device = stage.stage3Ds[m_viewportID].context3D;
			m_currentRenderTarget.device = m_device;
		}
		private function drawBackground():void{
			if( m_width > 0 && m_height > 0 )
			{
				graphics.clear();
				graphics.beginFill(0x000000,0);
				graphics.drawRect(0,0,m_width,m_height);
				graphics.endFill();
				super.width = m_width;
				super.height = m_height;
				trace("[Viewport][drawBackground] ", m_width,m_height);
			}
		}
		public function get isDeviceCreated():Boolean
		{
			return m_device != null;
		}
		public function update():void{
			if( !isDeviceCreated ) return;
			trace("[Viewport][update] frame: " + Time.frameCount, " time:" + Time.timeSeconds);
			m_currentRenderTarget.render();
			trace("---------------");
		}
		////////////////////////////
		// IIdentifiableObject	  //
		////////////////////////////
		//include "../../../../../includes/IdentifiableObject.as"
		
		////////////////////////////
		// IReconstructibleObject //
		////////////////////////////
		public function instance():*{
			throw new Error("Viewports are not be initantialized");
		}
		
		public function clone():IEngineObject{
			throw new Error("Viewports are not clonable");
		}
		
		public function renew():void{
			throw new Error("Not implemented!");
		}
		
		public function dispose():void{
			//IDManager.removeObject(this);	
		}
		public function disposeDeep():void{
			scene.disposeDeep();
			dispose();
		}
		public function disposeGPU():void{
			scene.disposeGPU();
		}
	}
}