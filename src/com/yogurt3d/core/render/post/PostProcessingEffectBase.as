package com.yogurt3d.core.render.post
{
	import com.yogurt3d.core.material.shaders.Shader;
	import com.yogurt3d.core.render.base.RenderTargetBase;
	import com.yogurt3d.core.render.renderer.PostProcessRenderer;
	
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.TextureBase;
	
	public class PostProcessingEffectBase extends RenderTargetBase
	{
		public var overrideToFront:Boolean = false;
		public var overrideToBack:Boolean = false;
		public var priority:uint = 0;
		
		/**
		 * This is the previos screen to be used as a sampler\n
		 * This will be set before render is called
		 */		
		public var sampler:TextureBase;
		protected var shader:Shader;
		
		public function PostProcessingEffectBase()
		{
			renderer = new PostProcessRenderer();
		}
		
		public function setShaderParameters():void{}
		
		public function clean():void{}
		
		public override function render():void{
			device.clear();
			
			device.clear(scene.sceneColor.r, scene.sceneColor.g,scene.sceneColor.b);
			// set program
			device.setProgram( shader.getProgram(device, null, "") );
			// set context3d properties and constants
			// eg: device.setTextureAt(0, sampler.getTextureForDevice( device );
			
			device.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO );
			device.setColorMask(true,true,true,false);
			device.setDepthTest( false, Context3DCompareMode.ALWAYS );
			device.setCulling( Context3DTriangleFace.NONE );
			
			setShaderParameters();
			
			
			// set context3d properties and constants
			// eg: device.setTextureAt(0, sampler.getTextureForDevice( device );
			
			// render
			renderer.render(device,scene,camera,drawRect);
			
			clean();
		}
	}
}