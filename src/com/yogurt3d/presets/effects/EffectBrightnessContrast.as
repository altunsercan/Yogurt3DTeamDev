package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectBrightnessContrast extends PostProcessingEffectBase
	{	
		private var m_filter:FilterBrightnessContrast;
		
		public function EffectBrightnessContrast(_brightness:Number= 0.0, _contrast:Number=0.0 )
		{
			super();
			
			m_filter = new FilterBrightnessContrast(_brightness, _contrast);
			
			shader.push(m_filter);
		}
				
		public function get contrast():Number
		{
			return m_filter.contrast;
		}
		
		public function set contrast(value:Number):void
		{
			m_filter.contrast = value;
		}
		
		public function get brightness():Number
		{
			return m_filter.brightness;
		}
		
		public function set brightness(value:Number):void
		{
			m_filter.brightness = value;
		}
				
		public override function render():void{
			trace("\t[EffectBrightnessContrast][render] start");
			
			super.render();
			
			trace("\t[EffectBrightnessContrast][render] end");
			
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

internal class FilterBrightnessContrast extends Shader
{
	private var m_brightness:Number;
	private var m_contrast:Number;
	
	public function FilterBrightnessContrast(_brightness:Number= 0.0, _contrast:Number=0.0 )
	{
		super();
		m_brightness = _brightness;
		m_contrast = _contrast;
	}
	
	public function get contrast():Number
	{
		return m_contrast;
	}
	
	public function set contrast(value:Number):void
	{
		m_contrast = value;
	}
	
	public function get brightness():Number
	{
		return m_brightness;
	}
	
	public function set brightness(value:Number):void
	{
		m_brightness = value;
	}
	
	public override function setShaderParameters():void{
		device.setTextureAt( 0, PostProcessingEffectBase.sampler);
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([m_brightness, m_contrast, 0.0, 1.0]));
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,  Vector.<Number>([0.5, 0.0, 0.0, 0.0]));
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
				"add ft0 ft0 fc0.x",//color.rgb += brightness
				
				"mov ft1.x fc0.y",
				ShaderUtils.greaterThan("ft1.y","ft1.x","fc0.z","ft2"),//if
				"sub ft1.z fc0.w ft1.y",//else
				
				"sub ft0 ft0 fc1.x",//ft0 = color.rgb - 0.5
				"sub ft2.x fc0.w ft1.x",// 1.0 - contrast
				"add ft2.y fc0.w ft1.x",// 1.0 + contrast
				
				"div ft3 ft0 ft2.x",//(color.rgb - 0.5) / (1.0 - contrast) 
				"add ft3 ft3 fc1.x",//(color.rgb - 0.5) / (1.0 - contrast) + 0.5
				"mul ft3 ft3 ft1.y",
				
				"div ft4 ft0 ft2.y",//(color.rgb - 0.5) / (1.0 + contrast) 
				"add ft4 ft4 fc1.x",//(color.rgb - 0.5) / (1.0 + contrast) + 0.5
				"mul ft4 ft4 ft1.z",
				
				"add oc ft3 ft4"
				
			].join("\n")
		);
	}
}