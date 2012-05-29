package com.yogurt3d.core.objects.interfaces
{
	import org.swiftsuspenders.Injector;

	public interface IControllableObject
	{
		function get injector():Injector;
		function addComponent(name:String, controllerClass:Class, ... p):IController;
		function getComponent(name:String):IController;
		function removeComponent(name:String):void;
		function removeAllComponents():void;
	}
}