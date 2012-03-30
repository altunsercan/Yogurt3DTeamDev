package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectGreyScale extends PostProcessingEffectBase
	{
		
		public function EffectGreyScale()
		{
			super();
			shader = new FilterGreyScale();
		}
		
		public override function setShaderParameters():void{
			device.setTextureAt( 0, sampler);
			device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([0.299, 0.587, 0.114, 1.0]));
		}
		
		public override function clean():void{
			device.setTextureAt( 0, null);
		}
		
		public override function render():void{
			trace("\t[EffectGreyScale][render] start");
			
			super.render();
			
			trace("\t[EffectGreyScale][render] end");
			
		}
	}
}
import com.adobe.utils.AGALMiniAssembler;
import com.yogurt3d.core.lights.ELightType;
import com.yogurt3d.core.material.shaders.Shader;
import com.yogurt3d.core.utils.ShaderUtils;

import flash.display3D.Context3DProgramType;
import flash.utils.ByteArray;

internal class FilterGreyScale extends Shader
{
	public function FilterGreyScale()
	{
		super();
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
				"dp3 ft1.x ft0.xyz fc0.xyz",
				"mov ft1.y fc0.w",
				
				"mov oc ft1.xxxy"
				
			].join("\n")
		);
	}
}