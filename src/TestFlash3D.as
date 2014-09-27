
package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash3d.Meshs;
	import flash3d.Node3D;
	import flash3d.View3D;
	/**
	 * ...
	 * @author lizhi
	 */
	public class TestFlash3D extends Sprite
	{
		private var view:View3D = new View3D;
		private var node:Node3D = Meshs.sphere(13,13);
		public function TestFlash3D() 
		{
			view.nodes.push(node);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			node.rot.x += Math.PI / 180 * 1;
			node.rot.y += Math.PI / 180 * 1;
			var scale:Number = Math.sin(getTimer() / 1200);
			//node.scale.setTo(scale, scale, scale);
			view.render(graphics);
			
		}
		
	}

}