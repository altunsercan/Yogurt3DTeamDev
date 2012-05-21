package com.yogurt3d.core.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.natives.NativeSignal;

	public class InputManager
	{
		private static var m_keyDown:NativeSignal;
		private static var m_keyUp:NativeSignal;
		
		private static var m_keyDict:Dictionary = new Dictionary();
		
		public static function setTriggerViewport( sprite:DisplayObjectContainer ):void{
			if( m_keyDown != null )
			{
				m_keyDown.removeAll();
				m_keyDown = null;
			}
			if(  m_keyUp != null )
			{
				m_keyUp.removeAll();
				m_keyUp = null;
			}
			m_keyDown = new NativeSignal(sprite, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			m_keyUp = new NativeSignal(sprite, KeyboardEvent.KEY_UP, KeyboardEvent);
			m_keyDown.add( onKeyDown );
			m_keyUp.add( onKeyUp);
		}
		
		public static function isKeyDown( value:uint ):Boolean{
			return m_keyDict[value] != null;
		}
		
		private static function onKeyDown( event:KeyboardEvent ):void{
			m_keyDict[ event.keyCode ] = true;
			if( event.ctrlKey ){
				m_keyDict[ Keyboard.CONTROL] = true;
			}
			if( event.shiftKey ){
				m_keyDict[ Keyboard.SHIFT] = true;
			}
		}
		
		private static function onKeyUp( event:KeyboardEvent ):void{
			delete m_keyDict[ event.keyCode ];
			if( !event.ctrlKey ){
				delete m_keyDict[ Keyboard.CONTROL];
			}
			if( !event.shiftKey ){
				delete m_keyDict[ Keyboard.SHIFT];
			}
		}
	}
}