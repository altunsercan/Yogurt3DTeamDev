
/*
 * EngineObject.as
 * This file is part of Yogurt3D Flash Rendering Engine 
 *
 * Copyright (C) 2011 - Yogurt3D Corp.
 *
 * Yogurt3D Flash Rendering Engine is free software; you can redistribute it and/or
 * modify it under the terms of the YOGURT3D CLICK-THROUGH AGREEMENT
 * License.
 * 
 * Yogurt3D Flash Rendering Engine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 * 
 * You should have received a copy of the YOGURT3D CLICK-THROUGH AGREEMENT
 * License along with this library. If not, see <http://www.yogurt3d.com/yogurt3d/downloads/yogurt3d-click-through-agreement.html>. 
 */
 
 
package com.yogurt3d.core.objects {
	import avmplus.getQualifiedClassName;
	
	import com.yogurt3d.core.managers.DependencyManager;
	import com.yogurt3d.core.managers.IDManager;
	import com.yogurt3d.core.objects.interfaces.IController;
	import com.yogurt3d.core.objects.interfaces.IEngineObject;
	
	import flash.utils.Dictionary;
	
	import org.swiftsuspenders.Injector;

	/**
	 * <strong>IEngineObject</strong> interface abstract type.
  	 * @author Yogurt3D Engine Core Team
  	 * @company Yogurt3D Corp.
  	 **/
	public class EngineObject implements IEngineObject
	{
		private var injector:Injector;
		
		private var m_componentDict:Dictionary;
		
		/**
		 * 
		 * @param _initInternals
		 * 
		 */
		public function EngineObject(_initInternals:Boolean = true)
		{
			trackObject();
			injector = new Injector();
			injector.parentInjector = DependencyManager.injector;
			m_componentDict = new Dictionary();
			
			if(_initInternals)
			{
				initInternals();
			}
		}
		
		include "../../../../../includes/IdentifiableObject.as";
		
		/**
		 * @inheritDoc
		 * */
		public function toString():String
		{
			return "{systemId:"+IDManager.getSystemIDByObject(this)+", userId:"+IDManager.getUserIDByObject(this)+"}";
		}
		
		/**
		 * @inheritDoc
		 * */
		public function renew():void
		{
		}
		
		/**
		 * @inheritDoc
		 * */
		public function clone():IEngineObject
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function instance():*
		{
			return this;
		}
		
		/**
		 * @inheritDoc
		 * */
		public function dispose():void
		{
			IDManager.removeObject(this);
		}
		
		public function disposeDeep():void
		{
			dispose();
			
			Y3DCONFIG::DEBUG
			{
				Y3DCONFIG::TRACE
				{
					trace("This class has not implemented a disposeDeep function", getQualifiedClassName(this) );
				}
			}
			
		}
		
		public function disposeGPU():void
		{
			Y3DCONFIG::DEBUG
			{
				Y3DCONFIG::TRACE
				{
					trace("This class has not implemented a disposeGPU function", getQualifiedClassName(this) );
				}
			}
			
		}
		/**
		 * Starts the tracking of the object 
		 * @see com.yogurt3d.core.managers.idmanager.IDManager
		 */		
		protected function trackObject():void
		{
			IDManager.trackObject(this, EngineObject);
		}
		
		protected function initInternals():void
		{
		}
		
		public function addComponent(name:String, controllerClass:Class, ... p):IController{
			var ins:IController;
			switch (p.length)
			{
				case 0 : ins = new controllerClass(); break;
				case 1 : ins = new controllerClass(p[0]); break;
				case 2 : ins = new controllerClass(p[0], p[1]); break;
				case 3 : ins = new controllerClass(p[0], p[1], p[2]); break;
				case 4 : ins = new controllerClass(p[0], p[1], p[2], p[3]); break;
				case 5 : ins = new controllerClass(p[0], p[1], p[2], p[3], p[4]); break;
				case 6 : ins = new controllerClass(p[0], p[1], p[2], p[3], p[4], p[5]); break;
				case 7 : ins = new controllerClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6]); break;
				case 8 : ins = new controllerClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]); break;
				case 9 : ins = new controllerClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]); break;
				case 10 :ins = new controllerClass(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]); break;
			}
			p.length = 0;
			
			if( ins is IController ){
				DependencyManager.registerObject( this, ins);
			}else{
				throw new Error("Controller classes must implement IController");
			}
			m_componentDict[name] = ins;
			return ins;
		}
		
		public function getComponent(name:String):IController{
			return m_componentDict[name];
		}
		
		public function removeComponent(name:String):void{
			var comp:IController = m_componentDict[name];
			delete m_componentDict[name];
			comp.dispose();
		}
		public function removeAllComponents():void{
			for( var name:String in m_componentDict )
			{
				removeComponent(name);
			}
		}
		
	}
}
