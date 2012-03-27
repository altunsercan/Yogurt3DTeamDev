package com.yogurt3d.core.render.renderer
{
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	
	public class DepthRenderer implements IRenderer
	{
		public function DepthRenderer()
		{
		}
		public function render( device:Context3D, scene:Scene3D, camera:Camera3D, rect:Rectangle ):void{
			trace("[DepthRenderer][render] start");
			trace("[DepthRenderer][render] end");
		}
	}
}