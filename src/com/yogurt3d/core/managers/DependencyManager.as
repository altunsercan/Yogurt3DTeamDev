package com.yogurt3d.core.managers
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.objects.EngineObject;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import flash.utils.Dictionary;
	
	import org.swiftsuspenders.InjectionMapping;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.utils.getConstructor;

	public class DependencyManager
	{
		private static var m_injector:Injector = new Injector();
		
		public static function map( type:Class, name:String="" ):InjectionMapping{
			return m_injector.map(type, name);
		}
		
		public static function registerObject( sceneObject:EngineObject, script:IController ):void{
			
			sceneObject.injector.map(getConstructor(sceneObject)).toValue(sceneObject);
			
			sceneObject.injector.injectInto( script );
	
			script.initialize();
		}

		public static function get injector():Injector
		{
			return m_injector;
		}

	}
}