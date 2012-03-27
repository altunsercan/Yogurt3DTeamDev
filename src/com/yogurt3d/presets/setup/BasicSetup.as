package com.yogurt3d.presets.setup
{
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.sceneobjects.Scene;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.setup.SetupBase;
	import com.yogurt3d.core.viewports.Viewport;
	
	import flash.display.DisplayObjectContainer;

	public class BasicSetup extends SetupBase
	{
		public function BasicSetup(_parent:DisplayObjectContainer)
		{
			super( _parent );
			
			if( _parent.stage )
			{
				viewport = new Viewport();
				viewport.x = 0;
				viewport.y= 0;
				viewport.width = _parent.stage.stageWidth;
				viewport.height = _parent.stage.stageHeight;
			}else{
				viewport = new Viewport();
				viewport.x = 0;
				viewport.y= 0;
				viewport.width = _parent.width;
				viewport.height = _parent.height;
			}
			
			YOGURT3D_INTERNAL::scene = new Scene();
			
			YOGURT3D_INTERNAL::camera = new Camera();
			
			ready();
		}
		
		public function get scene():Scene3D{
			return YOGURT3D_INTERNAL::scene as Scene3D;
		}
		public function set scene(value:Scene3D):void{
			YOGURT3D_INTERNAL::scene = value;
		}
		
		public function get camera():Camera3D{
			return YOGURT3D_INTERNAL::camera as Camera3D;
		}
		
		public function set camera(value:Camera3D):void{
			YOGURT3D_INTERNAL::camera = value;
		}
	}
}