package com.yogurt3d.physics.plugin
{
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.physics.objects.PhysicsObjectBase;

	public interface IYogurt3DPhysicsPlugin
	{
		/**
		 * 
		 * @param sceneObject
		 * @param object
		 * 
		 */
		function registerObject( sceneObject:SceneObject, object:PhysicsObjectBase ):void;
		/**
		 * 
		 * @param sceneObject
		 * @param object
		 * 
		 */
		function deregisterObject( sceneObject:SceneObject, object:PhysicsObjectBase ):void;
		/**
		 * 
		 * 
		 */
		function step():void;
		
	}
}