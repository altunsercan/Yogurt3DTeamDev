package com.yogurt3d.core.cameras
{
	/**
	 *  
	 * @author Gurel
	 * 
	 */
	[Deprecated(message="Use Camera3D instead.", replacement="com.yogurt3d.core.cameras.Camera3D", since="3.0")]
	public class Camera extends Camera3D
	{
		public function Camera(_initInternals:Boolean=true)
		{
			super(_initInternals);
		}
	}
}