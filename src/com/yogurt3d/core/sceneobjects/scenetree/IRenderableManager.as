package com.yogurt3d.core.sceneobjects.scenetree
{
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	
	import flash.utils.Dictionary;
	
	public interface IRenderableManager
	{
		function addChild(_child:SceneObjectRenderable, _scene:Scene3D, index:int = -1):void;
		function removeChildFromTree(_child:SceneObjectRenderable, _scene:Scene3D):void;
		function getSceneRenderableSet(_scene:Scene3D, _camera:Camera3D):Vector.<SceneObjectRenderable>;
		function getSceneRenderableSetLight(_scene:Scene3D, _light:Light, lightIndex:int):Vector.<SceneObjectRenderable>;
		function getIlluminatorLightIndexes(_scene:Scene3D, _objectRenderable:SceneObjectRenderable):Vector.<int>;
		function clearIlluminatorLightIndexes(_scene:Scene3D, _objectRenderable:SceneObjectRenderable):void;
		function getListOfVisibilityTesterByScene():Dictionary;
	}
}