// ActionScript file
import com.yogurt3d.core.objects.interfaces.IController;
import flash.utils.Dictionary;
import com.yogurt3d.core.managers.DependencyManager;
import org.swiftsuspenders.Injector;
import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;

YOGURT3D_INTERNAL var m_injector:Injector;

private var m_componentDict:Dictionary;

public function get injector():Injector{
	return YOGURT3D_INTERNAL::m_injector;
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