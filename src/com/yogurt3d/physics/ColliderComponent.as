package com.yogurt3d.physics
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.objects.Controller;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.physics.objects.PhysicsObjectBase;
	import com.yogurt3d.physics.plugin.IYogurt3DPhysicsPlugin;
	
	public class ColliderComponent extends Controller
	{
		[Inject(name="collidable")]
		public var sceneObject:SceneObject;
		
		private var m_object:PhysicsObjectBase;
		
		public function ColliderComponent( object:PhysicsObjectBase )
		{
			super();
			m_object = object;
		}
		public override function initialize():void{
			var physics:IYogurt3DPhysicsPlugin = Yogurt3D.physics;
			if( physics == null ){
				Y3DCONFIG::DEBUG{
					trace("No Physics Plugin Found");
				}
				return;
			}
			physics.registerObject(sceneObject,m_object);
		}
		public override function dispose():void{
			var physics:IYogurt3DPhysicsPlugin = Yogurt3D.physics;
			if( physics == null ){
				Y3DCONFIG::DEBUG{
					trace("No Physics Plugin Found");
				}
				return;
			}
			physics.deregisterObject(sceneObject,m_object);
		}
	}
}