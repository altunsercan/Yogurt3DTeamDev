package com.yogurt3d.core.sceneobjects.scenetree.octree
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import com.yogurt3d.core.namespaces.YOGURT3D_INTERNAL;
	import com.yogurt3d.core.cameras.Camera3D;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.Light;
	import com.yogurt3d.core.managers.SceneTreeManager;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.sceneobjects.scenetree.IRenderableManager;
	import com.yogurt3d.core.sceneobjects.transformations.Transformation;
	import com.yogurt3d.core.volumes.AxisAlignedBoundingBox;
	
	use namespace YOGURT3D_INTERNAL;
	
	public class OcTreeSceneTreeManager implements IRenderableManager
	{
		YOGURT3D_INTERNAL static var s_octantByScene:Dictionary;
		private static var s_staticChildrenByScene:Dictionary;
		
		private static var s_dynamicChildrenByScene:Dictionary;
		//the list for storing recursive "visibilityProcess" results for the testers like camera or light
		private static var listOfVisibilityTesterByScene:Dictionary;
		
		private static var s_transformedDynamicChildren:Vector.<SceneObjectRenderable> = new Vector.<SceneObjectRenderable>();
		private static var s_marktransformedDynamicChildren:Dictionary = new Dictionary();
		
		public function OcTreeSceneTreeManager()
		{
			if( s_octantByScene == null )
			{
				s_octantByScene = new Dictionary(false);
				s_staticChildrenByScene = new Dictionary(true);
				s_dynamicChildrenByScene = new Dictionary(true);
				listOfVisibilityTesterByScene = new Dictionary();
				
				
			}
		}
		
		public function addChild(_child:SceneObjectRenderable, _scene:Scene3D, index:int=-1):void
		{
			SceneTreeManager.initRenSetIlluminatorLightIndexes(_scene, _child);
			
			if( s_octantByScene[_scene] == null )
			{
				if( Scene3D(_scene).YOGURT3D_INTERNAL::m_args != null && 
					"x" in Scene3D(_scene).YOGURT3D_INTERNAL::m_args && 
					"y" in Scene3D(_scene).YOGURT3D_INTERNAL::m_args && 
					"z" in Scene3D(_scene).YOGURT3D_INTERNAL::m_args && 
					"width" in Scene3D(_scene).YOGURT3D_INTERNAL::m_args && 
					"height" in Scene3D(_scene).YOGURT3D_INTERNAL::m_args &&
					"depth" in Scene3D(_scene).YOGURT3D_INTERNAL::m_args 
				)
				{
					s_octantByScene[_scene] = new OctTree( 
						new AxisAlignedBoundingBox( 
							new Vector3D(
								Scene3D(_scene).YOGURT3D_INTERNAL::m_args.x,
								Scene3D(_scene).YOGURT3D_INTERNAL::m_args.y,
								Scene3D(_scene).YOGURT3D_INTERNAL::m_args.z),
							new Vector3D(
								Scene3D(_scene).YOGURT3D_INTERNAL::m_args.width ,
								Scene3D(_scene).YOGURT3D_INTERNAL::m_args.height,
								Scene3D(_scene).YOGURT3D_INTERNAL::m_args.depth
							)
						),
						Scene3D(_scene).YOGURT3D_INTERNAL::m_args.maxDepth, 
						Scene3D(_scene).YOGURT3D_INTERNAL::m_args.preAllocateNodes
					);
					Y3DCONFIG::TRACE
					{
						trace("OCTREE ",
							"x", Scene3D(_scene).YOGURT3D_INTERNAL::m_args.x,
							"y", Scene3D(_scene).YOGURT3D_INTERNAL::m_args.y,
							"z", Scene3D(_scene).YOGURT3D_INTERNAL::m_args.z,
							"width", Scene3D(_scene).YOGURT3D_INTERNAL::m_args.width ,
							"height", Scene3D(_scene).YOGURT3D_INTERNAL::m_args.height,
							"depth", Scene3D(_scene).YOGURT3D_INTERNAL::m_args.depth);
					}
				}
				else{
					s_octantByScene[_scene] = new OctTree( 
						new AxisAlignedBoundingBox(
							new Vector3D(-10000,-10000,-10000),
							new Vector3D(20000,20000,20000)
						)
					);
				}
				
			}
			
			if( listOfVisibilityTesterByScene[_scene] == null )
			{
				listOfVisibilityTesterByScene[_scene] = new Dictionary();
			}
			
			
			if( s_staticChildrenByScene[_scene] == null )
			{
				s_staticChildrenByScene[_scene] = new Vector.<SceneObjectRenderable>();
			}
			
			if( s_dynamicChildrenByScene[_scene] == null )
			{
				s_dynamicChildrenByScene[_scene] = new Vector.<SceneObjectRenderable>();
			}
			
			
			if( _child.isStatic )
			{
				//if( s_staticChildrenByScene[_scene] == null )
				//{
					//s_staticChildrenByScene[_scene] = new Vector.<SceneObjectRenderable>();
				//}
				s_staticChildrenByScene[_scene].push(_child);
			}
			else
			{
/*				if( s_dynamicChildrenByScene[_scene] == null )
				{
					s_dynamicChildrenByScene[_scene] = new Vector.<SceneObjectRenderable>();
				}*/
				s_dynamicChildrenByScene[_scene].push( _child );
				
				_child.transformation.onChange.add( onChildTransChanged );
			}

	        s_octantByScene[_scene].insert(_child);
			
			_child.onStaticChanged.add(onStaticChange );
			
		}
		
		private function onChildTransChanged(tras:Transformation):void{
			if( tras.m_isAddedToSceneRefreshList == false)
			{
				s_transformedDynamicChildren[s_transformedDynamicChildren.length] = SceneObjectRenderable(tras.m_ownerSceneObject);
				tras.m_isAddedToSceneRefreshList = true;
			}
		}
		
		public function getListOfVisibilityTesterByScene():Dictionary{
			return listOfVisibilityTesterByScene;
		}
		
		
		private function onStaticChange( _scn:SceneObject ):void{
			var _child:SceneObjectRenderable = _scn as SceneObjectRenderable;
			
			if( _child.isStatic )
			{
				_removeChildFromDynamicList( _child, _child.scene );
				
				_child.transformation.onChange.remove( onChildTransChanged );
				
				s_staticChildrenByScene[_child.scene].push( _child );
				
				
			}else
			{
				_removeChildFromStaticList( _child, _child.scene );
				
				_child.transformation.onChange.add( onChildTransChanged );
				
				s_dynamicChildrenByScene[_child.scene].push( _child );
			}
		}
		
		private function _removeChildFromDynamicList( _child:SceneObjectRenderable, _scene:Scene3D ):void{
			if( s_dynamicChildrenByScene[_scene ] )
			{
				var _renderableObjectsByScene 	:Vector.<SceneObjectRenderable>	= s_dynamicChildrenByScene[_scene];
				var _index						:int								= _renderableObjectsByScene.indexOf(_child);
				
				if(_index != -1)
				{
					_renderableObjectsByScene.splice(_index, 1);
				}
				
				if(_renderableObjectsByScene.length == 0)
				{
					s_dynamicChildrenByScene[_scene] = null;
				}
			}
			
		}
		
		
		private function _removeChildFromStaticList( _child:SceneObjectRenderable, _scene:Scene3D ):void{
			if( s_dynamicChildrenByScene[_scene ] )
			{
				var _renderableObjectsByScene 	:Vector.<SceneObjectRenderable>	= s_staticChildrenByScene[_scene];
				var _index						:int								= _renderableObjectsByScene.indexOf(_child);
				
				if(_index != -1)
				{
					_renderableObjectsByScene.splice(_index, 1);
				}
				
				if(_renderableObjectsByScene.length == 0)
				{
					s_staticChildrenByScene[_scene] = null;
				}
			}
			
		}
		
		
		public function getSceneRenderableSet(_scene:Scene3D, _camera:Camera3D):Vector.<SceneObjectRenderable>
		{
			var camera:Camera3D =  _camera;

			if( s_octantByScene[_scene] )
			{
				s_octantByScene[_scene].updateTree(s_transformedDynamicChildren );
				
				camera.frustum.extractPlanes(camera.transformation);

				camera.frustum.boundingSphere.YOGURT3D_INTERNAL::m_center = camera.transformation.matrixGlobal.transformVector(camera.frustum.m_bSCenterOrginal);
				
				s_octantByScene[_scene].list = listOfVisibilityTesterByScene[_scene][_camera];
				
				s_octantByScene[_scene].visibilityProcess( _camera );
			
				return s_octantByScene[_scene].list;
			}
			
			return null;
		}
		
		public function getSceneRenderableSetLight(_scene:Scene3D, _light:Light, lightIndex:int):Vector.<SceneObjectRenderable>
		{
			if(_light.type == ELightType.DIRECTIONAL)
			{
				if(s_staticChildrenByScene[_scene] == null)
					return null;
					
				return s_dynamicChildrenByScene[_scene].concat(s_staticChildrenByScene[_scene]);
			}
			
			if( s_octantByScene[_scene] )
			{
				
				if(_light.type != ELightType.POINT)
				_light.frustum.extractPlanes(_light.transformation);
				
				_light.frustum.boundingSphere.YOGURT3D_INTERNAL::m_center = _light.transformation.matrixGlobal.transformVector(_light.frustum.m_bSCenterOrginal);
				
				s_octantByScene[_scene].list = listOfVisibilityTesterByScene[_scene][_light];
				
				s_octantByScene[_scene].visibilityProcessLight( _light, lightIndex, _scene);
				
				return s_octantByScene[_scene].list;
			}
			
			return null;
		}
		
		public function removeChildFromTree(_child:SceneObjectRenderable, _scene:Scene3D):void
		{
			var _renderableObjectsByScene 	:Vector.<SceneObjectRenderable>;
			var _index						:int;
			var _dictionary                 :Dictionary;
			
			
			if(_child.isStatic)
			{
				_renderableObjectsByScene	= s_staticChildrenByScene[_scene];
			    _index	= _renderableObjectsByScene.indexOf(_child);
				_dictionary = s_staticChildrenByScene;
			}
			else
			{
				_renderableObjectsByScene	= s_dynamicChildrenByScene[_scene];
				_index	= _renderableObjectsByScene.indexOf(_child);
				_dictionary = s_dynamicChildrenByScene;
				s_transformedDynamicChildren.splice(s_transformedDynamicChildren.indexOf(_child), 1);
				
			}
            
			if(_index != -1)
			{
				_renderableObjectsByScene.splice(_index, 1);
				SceneTreeManager.s_renSetIlluminatorLightIndexes[_scene][_child] = null;
			}
				
			if(_renderableObjectsByScene.length == 0)
			{
				_dictionary[_scene] = null;
			}

			s_octantByScene[_scene].removeFromNode(_child);
			delete s_octantByScene[_scene].sceneObjectToOctant[ _child ];
		
		}
		
		public function getIlluminatorLightIndexes(_scene:Scene3D, _objectRenderable:SceneObjectRenderable):Vector.<int>
		{
			return SceneTreeManager.s_renSetIlluminatorLightIndexes[_scene][_objectRenderable].concat(SceneTreeManager.s_sceneDirectionalLightIndexes[_scene]);
		}
		
		public function clearIlluminatorLightIndexes(_scene:Scene3D, _objectRenderable:SceneObjectRenderable):void
		{
			SceneTreeManager.s_renSetIlluminatorLightIndexes[_scene][_objectRenderable].length = 0;
		}
		
		
		
	}
}