package com.yogurt3d.core.sceneobjects
{
	[Deprecated(message="Use Scene3D instead.", replacement="com.yogurt3d.core.sceneobjects.Scene3D", since="3.0")]
	public class Scene extends Scene3D
	{
		public function Scene(_sceneTreeManagerDriver:String="SimpleSceneTreeManagerDriver", args:Object=null, _initInternals:Boolean=true)
		{
			super(_sceneTreeManagerDriver, args, _initInternals);
		}
	}
}