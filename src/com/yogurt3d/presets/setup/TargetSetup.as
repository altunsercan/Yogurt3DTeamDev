package com.yogurt3d.presets.setup
{
	import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.sceneobjects.Scene;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.setup.SetupBase;
	import com.yogurt3d.core.viewports.Viewport;
	import com.yogurt3d.presets.cameras.TargetCamera;
	
	import flash.display.DisplayObjectContainer;

	public class TargetSetup extends SetupBase
	{
		public function TargetSetup(_parent:DisplayObjectContainer)
		{
			super( _parent );
			
			if( _parent.stage )
			{
				viewport.x = 0;
				viewport.y= 0;
				viewport.width = _parent.stage.stageWidth;
				viewport.height = _parent.stage.stageHeight;
			}else{
				viewport.x = 0;
				viewport.y= 0;
				viewport.width = _parent.width;
				viewport.height = _parent.height;
			}
			
			YOGURT3D_INTERNAL::scene = new Scene();
			
			YOGURT3D_INTERNAL::camera = new TargetCamera(viewport);
			
			camera.frustum.setProjectionPerspective(55, viewport.width/viewport.height,1,150 );
			
			ready();
		}
		
		public function get scene():Scene3D{
			return YOGURT3D_INTERNAL::scene as Scene3D;
		}
		public function set scene(value:Scene3D):void{
			YOGURT3D_INTERNAL::scene = value;
		}
		
		public function get camera():TargetCamera{
			return YOGURT3D_INTERNAL::camera as TargetCamera;
		}
		
		public function set camera(value:TargetCamera):void{
			YOGURT3D_INTERNAL::camera = value;
		}
	}
}