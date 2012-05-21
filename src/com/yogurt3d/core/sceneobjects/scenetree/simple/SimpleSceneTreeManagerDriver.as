package com.yogurt3d.core.sceneobjects.scenetree.simple
{
	import com.yogurt3d.core.sceneobjects.scenetree.IRenderableManager;
	import com.yogurt3d.core.sceneobjects.scenetree.SceneTreeManagerDriver;
	
	
	public class SimpleSceneTreeManagerDriver extends SceneTreeManagerDriver
	{
		public function SimpleSceneTreeManagerDriver()
		{
			super();
		}
		public override function get name():String{
			return "SimpleSceneTreeManagerDriver";
		}
		public override function createTreeManager():IRenderableManager{
			return new SimpleSceneTreeManager();
		}
	}
}