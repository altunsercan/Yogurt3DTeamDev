package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectVibrance extends PostProcessingEffectBase
	{
		private var m_filter:FilterVibrance;
		
		public function EffectVibrance(_amount:Number= 0.0)
		{
			super();
		
			shader.push( m_filter = new FilterVibrance(_amount) );
		}
		
		public function get amount():Number
		{
			return m_filter.amount;
		}
		
		public function set amount(value:Number):void
		{
			m_filter.amount = value;
		}
		
		public override function render():void{
			trace("\t[EffectVibrance][render] start");
			
			super.render();
			
			trace("\t[EffectVibrance][render] end");
			
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

internal class FilterVibrance extends Shader
{
	private var m_amount:Number;
	
	public function FilterVibrance(_amount:Number= 0.0)
	{
		super();
		m_amount = _amount;
	}
	
	public override function setShaderParameters():void{
		device.setTextureAt( 0, PostProcessingEffectBase.sampler);
		
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([-m_amount*3.0, 3.0, 1.0, 0.0]));
	}
	
	public function get amount():Number
	{
		return m_amount;
	}
	
	public function set amount(value:Number):void
	{
		m_amount = value;
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
				"tex ft0 v0 fs0<2d,wrap,linear>", // get render to texture
				
				"add ft1.x ft0.x ft0.y",
				"add ft1.x ft1.x ft0.z",
				"div ft1.x ft1.x fc0.y",//  float average = (color.r + color.g + color.b) / 3.0;
				
				"max ft1.y ft0.y ft0.z",
				"max ft1.y ft0.x ft1.y",//float mx = max(color.r, max(color.g, color.b));
				
				"sub ft1.z ft1.y ft1.x",//(mx - average)
				"mul ft1.z ft1.z fc0.x",// float amt = (mx - average) * (-amount * 3.0)
				
				"sub ft1.w fc0.z ft1.z",//1-amt
				
				ShaderUtils.mix("ft2","ft3","ft0.xyz","ft1.yyy","ft1.z","ft1.w"),
				
				"mov ft2.w fc0.z",
				"mov oc ft2"
				
				
			].join("\n")
			
		);
	}
}