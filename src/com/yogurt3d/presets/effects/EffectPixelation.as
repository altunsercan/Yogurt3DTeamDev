package com.yogurt3d.presets.effects
{
	import com.yogurt3d.core.render.post.PostProcessingEffectBase;
	
	import flash.display3D.Context3DProgramType;
	
	public class EffectPixelation extends PostProcessingEffectBase
	{
		private var m_filter:FilterPixelation;
		public function EffectPixelation(_pixelWidth:Number=15.0, _pixelHeight:Number=10.0)
		{
			super();
			
			shader.push( m_filter = new FilterPixelation(_pixelWidth, _pixelHeight) );
		}
		
		public function get pixelWidth():Number{
			return m_filter.pixelWidth;
		}
		
		public function get pixelHeight():Number{
			return m_filter.pixelHeight;
		}
		
		public function set pixelWidth(_value:Number):void{
			m_filter.pixelWidth = _value;
		}
		
		public function set pixelHeight(_value:Number):void{
			m_filter.pixelHeight = _value;
		}
		

		
		public override function render():void{
			trace("\t[EffectPixelation][render] start");
			
			super.render();
			
			trace("\t[EffectPixelation][render] end");
			
		}
	}
}
import com.adobe.utils.AGALMiniAssembler;
import com.yogurt3d.core.lights.ELightType;
import com.yogurt3d.core.material.shaders.Shader;
import com.yogurt3d.core.render.base.RenderTargetBase;
import com.yogurt3d.core.render.post.PostProcessingEffectBase;
import com.yogurt3d.core.utils.MathUtils;
import com.yogurt3d.core.utils.ShaderUtils;

import flash.display3D.Context3DProgramType;
import flash.utils.ByteArray;

internal class FilterPixelation extends Shader
{
	private var m_pixelWidth:Number;
	private var m_pixelHeight:Number;
	
	
	public function FilterPixelation(_pixelWidth:Number=15.0, _pixelHeight:Number=10.0)
	{
		super();
		m_pixelWidth = _pixelWidth;
		m_pixelHeight = _pixelHeight;
	}
	
	public function get pixelWidth():Number{
		return m_pixelWidth;
	}
	
	public function get pixelHeight():Number{
		return m_pixelHeight;
	}
	
	public function set pixelWidth(_value:Number):void{
		m_pixelWidth = _value;
	}
	
	public function set pixelHeight(_value:Number):void{
		m_pixelHeight = _value;
	}
	
	public override function clean():void{
		device.setTextureAt( 0, null);
	}
	
	public override function setShaderParameters():void{
		device.setTextureAt( 0, PostProcessingEffectBase.sampler);
		
		var width:uint = MathUtils.getClosestPowerOfTwo(RenderTargetBase.width);
		var height:uint = MathUtils.getClosestPowerOfTwo(RenderTargetBase.height);
		
		var dx:Number = 1.0/width * m_pixelWidth;
		var dy:Number = 1.0/height * m_pixelHeight;
		
		device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,  Vector.<Number>([dx, dy, 1.0, 0.0]));
	}
	
	public override function getVertexProgram(_meshKey:String, _lightType:ELightType = null):ByteArray
	{
		return ShaderUtils.vertexAssambler.assemble( AGALMiniAssembler.VERTEX, 
			"mov op va0\n"+
			"mov v0 va1"
		);
	}
	
	public override function getFragmentProgram(_lightType:ELightType=null):ByteArray{
		//			float dx = pixel_w*(1./rt_w);
		//			float dy = pixel_h*(1./rt_h);
		//			vec2 coord = vec2(dx*floor(uv.x/dx),
		//				dy*floor(uv.y/dy));
		//			tc = texture2D(sceneTex, coord).rgb;
		
		return ShaderUtils.fragmentAssambler.assemble( AGALMiniAssembler.FRAGMENT,
			
			[
				
				"tex ft0 v0 fs0<2d,wrap,linear>", // get render to texture
				
				"div ft1.x v0.x fc0.x",
				ShaderUtils.floorAGAL("ft2.x","ft1.x"),
				"mul ft1.x ft2.x fc0.x",
				
				"div ft1.y v0.y fc0.y",
				ShaderUtils.floorAGAL("ft2.x","ft1.y"),
				"mul ft1.y ft2.x fc0.y",
				
				"tex ft0 ft1.xy fs0<2d,wrap,linear>",
				
				"mov ft0.w fc0.z",
				
				"mov oc ft0"
				
			].join("\n")
			
		);
	}
}