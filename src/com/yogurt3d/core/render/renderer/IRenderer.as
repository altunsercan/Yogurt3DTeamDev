package com.yogurt3d.core.render.renderer
{
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;

	public interface IRenderer
	{
		function render( device:Context3D, scene:Scene3D, camera:Camera3D, rect:Rectangle ):void;
	}
}