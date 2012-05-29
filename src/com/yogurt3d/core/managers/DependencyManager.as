package com.yogurt3d.core.managers
{
	import com.yogurt3d.core.objects.EngineObject;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.objects.interfaces.IEngineObject;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import org.swiftsuspenders.InjectionMapping;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.utils.getConstructor;

	public class DependencyManager
	{
		private static var m_injector:Injector = new Injector();
		{
			m_injector.map(EngineObject).toProvider( new EngineObjectUserIdDependencyProvider() );
		}
		public static function map( type:Class, name:String="" ):InjectionMapping{
			return m_injector.map(type, name);
		}
		
		public static function registerObject( sceneObject:IEngineObject, script:IController ):void{
			if( sceneObject is SceneObject ){	
				sceneObject.injector.map(SceneObject).toValue(sceneObject);
				sceneObject.injector.map(getConstructor(sceneObject)).toValue(sceneObject);
			}else{
				sceneObject.injector.map(EngineObject).toValue(sceneObject);
				sceneObject.injector.map(getConstructor(sceneObject)).toValue(sceneObject);
			}			
			sceneObject.injector.injectInto( script );
	
			script.initialize();
		}

		public static function get injector():Injector
		{
			return m_injector;
		}

	}
}