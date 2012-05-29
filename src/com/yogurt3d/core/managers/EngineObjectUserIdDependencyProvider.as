package com.yogurt3d.core.managers
{
	import flash.utils.Dictionary;
	
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.dependencyproviders.DependencyProvider;
	
	public class EngineObjectUserIdDependencyProvider implements DependencyProvider
	{
		public function EngineObjectUserIdDependencyProvider()
		{
		}
		public function apply( targetType : Class, activeInjector : Injector, injectParameters : Dictionary ) : Object
		{
			if( injectParameters["userid"] )
			{
				return IDManager.getObjectByUserID(injectParameters["userid"]);
			}
			return null;

		}
	}
}