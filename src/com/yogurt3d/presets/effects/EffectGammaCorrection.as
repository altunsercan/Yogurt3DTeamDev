package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectGammaCorrection extends PostProcessingEffectBase
	{
	
		private var m_filter:FilterGammaCorrection;
		public function EffectGammaCorrection(_gamma:Number=2.2)
		{
			super();
					
			shader.push( m_filter = new FilterGammaCorrection(_gamma) );
		}
		
		public function get gamma():Number{
			return m_filter.gamma;
		}
		
		public function set gamma(_value:Number):void{
			m_filter.gamma = _value;
		}

		public override function render():void{
			trace("\t[EffectGammaCorrection][render] start");
			
			super.render();
			
			trace("\t[EffectGammaCorrection][render] end");
			
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

internal class FilterGammaCorrection extends Shader
{
	
	private var m_gamma:Number;
	public function FilterGammaCorrection(_gamma:Number=2.2)
	{
		super();
	}
	
	public function get gamma():Number{
		return m_gamma;
	}
	
	public function set gamma(_value:Number):void{
		m_gamma = _value;
	}
	
	public override function setShaderParameters():void{
		device.setTextureAt( 0, PostProcessingEffectBase.sampler);
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([1/m_gamma, 0.5, 0.0, 1.0]));
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
		//outColor.rgb = pow(color, 1.0 / gammaRGB);
		
		return ShaderUtils.fragmentAssambler.assemble( AGALMiniAssembler.FRAGMENT,
			[
				"tex ft0 v0 fs0<2d,wrap,linear>", // get render to texture
				"pow ft0 ft0 fc0.xxx", //pow(color, 1.0 / gammaRGB)
				"mov ft0.w fc0.w",
				
				"mov oc ft0"
				
			].join("\n")
		);
	}
}