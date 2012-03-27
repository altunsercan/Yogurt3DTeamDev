package com.yogurt3d.core.sceneobjects.scenetree.octree
{
	import com.yogurt3d.core.sceneobjects.scenetree.IRenderableManager;
	import com.yogurt3d.core.sceneobjects.scenetree.SceneTreeManagerDriver;
	
	
	public class OcTreeSceneTreeManagerDriver extends SceneTreeManagerDriver
	{
		public function OcTreeSceneTreeManagerDriver()
		{
			super();
		}
		public override function get name():String{
			return "OcSceneTreeManagerDriver";
		}
		public override function createTreeManager():IRenderableManager{
			return new OcTreeSceneTreeManager();
		}
	}
}