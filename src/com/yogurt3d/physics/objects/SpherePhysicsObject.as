package com.yogurt3d.physics.objects
{
	public class SpherePhysicsObject extends PhysicsObjectBase
	{
		private var m_radius:Number;
		
		public function SpherePhysicsObject(radius:Number)
		{
			super(true);
		}

		public function get radius():Number
		{
			return m_radius;
		}

	}
}