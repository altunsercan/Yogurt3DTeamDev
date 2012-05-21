package com.yogurt3d.core.objects.interfaces
{
	public interface IControllable
	{
		function addComponent(name:String, controllerClass:Class, ... p):IController;
		function getComponent(name:String):IController;
		function removeComponent(name:String):void;
		function removeAllComponents():void;
	}
}