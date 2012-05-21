package com.yogurt3d.core.render
{
	import com.yogurt3d.core.managers.VertexStreamManager;
	import com.yogurt3d.core.render.base.RenderTargetBase;
	import com.yogurt3d.core.render.renderer.DefaultRenderer;
	import com.yogurt3d.core.render.renderer.IRenderer;
	import com.yogurt3d.core.render.texture.RenderTexture;
	import com.yogurt3d.core.sceneobjects.Scene3D;
	import com.yogurt3d.core.utils.MathUtils;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;

	public class BackBufferRenderTarget extends RenderTargetBase
	{	
		private var m_renderTexture:RenderTexture;
		public function BackBufferRenderTarget()
		{
			
		}
		
		public override function render():void{
			device.enableErrorChecking = true;
			trace("[BackBufferRenderTarget][render] start");
			if(!m_newBackBufferRect.equals( m_currentBackBufferRect ) )
			{
				device.configureBackBuffer( m_newBackBufferRect.width, m_newBackBufferRect.height, 16, true );
				m_currentBackBufferRect.copyFrom( m_newBackBufferRect );
			}
			if( scene.renderTargets.length != 0 )
			{// if scene contains render targets
				// render RTT's
				scene.renderTargets.updateAll(device);
				// set render to backbuffer
				device.setRenderToBackBuffer();
			}
			if( scene.postProcesses.length > 0 )
			{// if scene contains post processing effects
				if( m_renderTexture == null )
				{
					m_renderTexture = new RenderTexture();
				}
				// render to texture
				m_renderTexture.scene = scene;
				m_renderTexture.camera = camera;
				m_renderTexture.device = device;
				m_renderTexture.renderer = this.renderer;
				m_renderTexture.drawRect.width = MathUtils.getClosestPowerOfTwo(drawRect.width);
				m_renderTexture.drawRect.height = MathUtils.getClosestPowerOfTwo(drawRect.height);
				m_renderTexture.render();
				
				// send rtt to postprocessing effects
				scene.postProcesses.updateAll( device,scene,camera,m_renderTexture.drawRect,m_renderTexture);
			}else{ // if the scene does not contain and post processing effects
				// clear backbuffer
				device.clear(scene.sceneColor.r, scene.sceneColor.g, scene.sceneColor.b, scene.sceneColor.a);
				// draw
				m_renderer.render( device, scene, camera, m_currentBackBufferRect );
			}
			// flip backbuffer to front buffer
			device.present();
			VertexStreamManager.instance.cleanVertexBuffers(device);
			trace("[BackBufferRenderTarget][render] end");
		}
		public function getBitmapData():BitmapData{
			var bmp:BitmapData = new BitmapData(m_currentBackBufferRect.width, m_currentBackBufferRect.height);
			device.drawToBitmapData(bmp);
			return bmp;
		}
	}
}