package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectSephia extends PostProcessingEffectBase
	{
		
		public function EffectSephia()
		{
			super();
			shader.push( new FilterSephia());
		}
				
		public override function render():void{
			trace("\t[EffectSephia][render] start");
			
			super.render();
			
			trace("\t[EffectSephia][render] end");
			
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

internal class FilterSephia extends Shader
{
	public function FilterSephia()
	{
		super();
	}
	
	public override function setShaderParameters():void{
		device.setTextureAt( 0, PostProcessingEffectBase.sampler);
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([0.299, 0.587, 0.114, 1.0]));
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,  Vector.<Number>([1.2, 1.0, 0.8, 0.0]));
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
		//if (color[0].r < 0.50)
		//	outColor.rgb = pow(color, 1.0 / gammaRGB);
		//else
		//	outColor.rgb = color;
		//outColor.a = 1.0;
		return ShaderUtils.fragmentAssambler.assemble( AGALMiniAssembler.FRAGMENT,
			[
				
				"tex ft0 v0 fs0<2d,wrap,linear>", // get render to texture
				
				"dp3 ft1.x ft0.xyz fc0.xyz",
				"mul ft1.xyz fc1.xyz ft1.x",
				"mov ft1.w fc0.w",
				"mov oc ft1"
				
			].join("\n")
		);
	}
}