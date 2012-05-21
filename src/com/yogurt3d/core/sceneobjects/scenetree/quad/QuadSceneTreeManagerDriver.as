package com.yogurt3d.core.sceneobjects.scenetree.quad
{
	import com.yogurt3d.core.sceneobjects.scenetree.IRenderableManager;
	import com.yogurt3d.core.sceneobjects.scenetree.SceneTreeManagerDriver;
	
	
	public class QuadSceneTreeManagerDriver extends SceneTreeManagerDriver
	{
		public function QuadSceneTreeManagerDriver()
		{
			super();
		}
		public override function get name():String{
			return "QuadSceneTreeManagerDriver";
		}
		public override function createTreeManager():IRenderableManager{
			return new QuadSceneTreeManager();
		}
	}
}