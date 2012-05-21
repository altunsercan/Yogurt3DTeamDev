package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectNegative extends PostProcessingEffectBase
	{
		
		public function EffectNegative()
		{
			super();
			shader.push(new FilterNegative());
		}
		
		public override function render():void{
			trace("\t[EffectNegative][render] start");
			
			super.render();
			
			trace("\t[EffectNegative][render] end");
			
		}
	}
}
import com.adobe.utils.AGALMiniAssembler;
import com.yogurt3d.core.lights.ELightType;
import com.yogurt3d.core.material.shaders.Shader;
import com.yogurt3d.core.render.post.PostProcessingEffectBase;
import com.yogurt3d.core.utils.ShaderUtils;

import flash.display3D.Context3DProgramType;
import flash.utils.ByteArray;

internal class FilterNegative extends Shader
{
	public function FilterNegative()
	{
		super();
	}
	
	public override function setShaderParameters():void{
		device.setTextureAt( 0, PostProcessingEffectBase.sampler);
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([1.0, 0.0, 0.0, 0.0]));	
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
				"sub ft0.xyz fc0.xxx ft0.xyz",//vec3(1.0) - texture2D(tex0, gl_TexCoord[0].xy).rgb;
				"mov ft0.w fc0.x",
				
				"mov oc ft0"
				
			].join("\n")
		);
	}
}