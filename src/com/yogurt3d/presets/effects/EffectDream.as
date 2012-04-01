package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectDream extends PostProcessingEffectBase
	{
		
		public function EffectDream()
		{
			super();
			shader.push(new FilterDream());
		}
						
		public override function render():void{
			trace("\t[EffectDream][render] start");
			
			super.render();
			
			trace("\t[EffectDream][render] end");
			
		}
	}
}
import com.adobe.utils.AGALMiniAssembler;
import com.yogurt3d.core.lights.ELightType;
import com.yogurt3d.core.material.shaders.EShaderConstantsType;
import com.yogurt3d.core.material.shaders.Shader;
import com.yogurt3d.core.material.shaders.ShaderConstants;
import com.yogurt3d.core.render.post.PostProcessingEffectBase;
import com.yogurt3d.core.utils.ShaderUtils;

import flash.display3D.Context3DProgramType;
import flash.utils.ByteArray;

internal class FilterDream extends Shader
{
	public function FilterDream()
	{
		super();
		
	}
	
	public override function setShaderParameters():void{
			device.setTextureAt( 0, PostProcessingEffectBase.sampler);
			device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([0.001, 0.003, 0.005, 0.007]));
			device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,  Vector.<Number>([0.009, 0.011, 3.0, 9.5]));
	}
	
	public override function clean():void{
		device.setTextureAt( 0, null);
	}
	
	public override function getVertexProgram(_meshKey:String, _lightType:ELightType = null):ByteArray
	{
		return ShaderUtils.vertexAssambler.assemble( AGALMiniAssembler.VERTEX, 
			"mov op va0\n"+
			"mov v0 va1"
		);
	}
	
	public override function getFragmentProgram(_lightType:ELightType=null):ByteArray{
		return ShaderUtils.fragmentAssambler.assemble( AGALMiniAssembler.FRAGMENT,
			[
				
				"tex ft0 v0 fs0<2d,wrap,linear>",
				"add ft1 v0 fc0.x",// uv+0.001
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv+0.001);
				"add ft0 ft0 ft1",
				
				"add ft1 v0 fc0.y",// uv+0.003
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv+0.003);
				"add ft0 ft0 ft1",
				
				"add ft1 v0 fc0.z",// uv+0.005
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv+0.005);
				"add ft0 ft0 ft1",
				
				"add ft1 v0 fc0.w",// uv+0.007
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv+0.007);
				"add ft0 ft0 ft1",
				
				"add ft1 v0 fc1.x",// uv+0.009
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv+0.009);
				"add ft0 ft0 ft1",
				
				"add ft1 v0 fc1.y",// uv+0.011
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv+0.011);
				"add ft0 ft0 ft1",
				
				"sub ft1 v0 fc0.x",// uv-0.001
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv-0.001);
				"add ft0 ft0 ft1",
				
				"sub ft1 v0 fc0.y",// uv-0.003
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv-0.003);
				"add ft0 ft0 ft1",
				
				"sub ft1 v0 fc0.z",// uv-0.005
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv-0.005);
				"add ft0 ft0 ft1",
				
				"sub ft1 v0 fc0.w",// uv-0.007
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv-0.007);
				"add ft0 ft0 ft1",
				
				"sub ft1 v0 fc1.x",// uv-0.009
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv-0.009);
				"add ft0 ft0 ft1",
				
				"sub ft1 v0 fc1.y",// uv-0.011
				"tex ft1 ft1 fs0<2d,wrap,linear>",//texture2D(sceneTex, uv-0.011);
				"add ft0 ft0 ft1",
				
				"mov ft2 ft0.x",
				"add ft2 ft2 ft0.y",
				"add ft2 ft2 ft0.z",
				"div ft0.xyz ft2.xyz fc1.z",// vec3((c.r+c.g+c.b)/3.0);
				"div ft0 ft0 fc1.w",// c = c / 9.5;
				"mov oc ft0"
				
			].join("\n")
		);
	}
}