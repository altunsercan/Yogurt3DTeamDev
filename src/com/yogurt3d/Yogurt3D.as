package com.yogurt3d
{
	import com.yogurt3d.core.Time;
	import com.yogurt3d.core.managers.SceneTreeManager;
	import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.plugin.Kernel;
	import com.yogurt3d.core.plugin.Server;
	import com.yogurt3d.core.sceneobjects.scenetree.SceneTreePlugins;
	import com.yogurt3d.core.viewports.Viewport;
	import com.yogurt3d.physics.plugin.IYogurt3DPhysicsPlugin;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.osflash.signals.PrioritySignal;

	public class Yogurt3D
	{
		public static var physics:IYogurt3DPhysicsPlugin;
		
		public static var m_viewportList:Vector.<Viewport> = new Vector.<Viewport>();
		
		private static var m_isEnterFrameRegistered:Boolean = false;
		
		private static var m_lastEnterFrame:uint;
		
		public static var onFrameStart:PrioritySignal = new PrioritySignal();
		public static var onUpdate:PrioritySignal = new PrioritySignal();
		public static var onFrameEnd:PrioritySignal = new PrioritySignal();
		
		YOGURT3D_INTERNAL static function registerViewport( viewport:Viewport ):void{
			m_viewportList.push( viewport );
			if( !m_isEnterFrameRegistered && viewport.stage )
			{
				viewport.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame );
				m_lastEnterFrame = getTimer();
				m_isEnterFrameRegistered = true;
			}
		}
		YOGURT3D_INTERNAL static function deregisterViewport( viewport:Viewport ):void{
			// find index of viewport
			var index:int = m_viewportList.indexOf( viewport );
			if( index != -1 )
			{
				// if viewport is in the viewport list
				// remove from viewport list
				m_viewportList.splice( index, 1 );
			}
		}
		
		private static function onEnterFrame( event:Event ):void{
			Time.YOGURT3D_INTERNAL::m_frameCount+=1;
			var now:uint = getTimer();
			Time.YOGURT3D_INTERNAL::m_deltaTime = (now - m_lastEnterFrame) * Time.timeScale;
			Time.YOGURT3D_INTERNAL::m_deltaTimeSeconds = Time.YOGURT3D_INTERNAL::m_deltaTime / 1000;
			Time.YOGURT3D_INTERNAL::m_time += Time.YOGURT3D_INTERNAL::m_deltaTime;
			Time.YOGURT3D_INTERNAL::m_timeSeconds = Time.YOGURT3D_INTERNAL::m_time / 1000;
			m_lastEnterFrame = now;
			
			onFrameStart.dispatch();
			if(physics!=null)
			{
				physics.step();
			}
			onUpdate.dispatch();
			for( var i:int = 0; i < m_viewportList.length; i++ )
			{
				if( m_viewportList[i].autoUpdate )
					m_viewportList[i].update();
			}
			onFrameEnd.dispatch();
		}
		
		
	}
}