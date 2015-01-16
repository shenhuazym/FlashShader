package gl3d.core {
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import gl3d.ctrl.Ctrl;
	import gl3d.post.PostEffect;
	import gl3d.util.Utils;
	/**
	 * ...
	 * @author lizhi
	 */
	public class View3D extends Sprite
	{
		public var agalVersion:int;
		public var context:Context3D;
		public var scene:Node3D = new Node3D("scene");
		public var camera:Camera3D = new Camera3D;
		public var lights:Vector.<Light> = new <Light>[new Light];
		public var fog:Fog;
		public var invalid:Boolean = true;
		public var collects:Vector.<Node3D> = new Vector.<Node3D>;
		public var ctrls:Vector.<Ctrl> = new Vector.<Ctrl>;
		public var posts:Vector.<PostEffect> = new Vector.<PostEffect>;
		public var postRTTs:Vector.<TextureSet> = Vector.<TextureSet>([new TextureSet, new TextureSet]);
		private var _antiAlias:int = 2;
		public var stage3dWidth:Number = 0;
		public var stage3dHeight:Number = 0;
		public var time:Number = 0;
		public var drawTriangleCounter:int = 0;
		public var drawCounter:int = 0;
		public var driverInfo:String;
		public var background:uint = 0;
		public function View3D(agalVersion:int=2) 
		{
			this.agalVersion = agalVersion;
			scene.addChild(camera);
			for each(var light:Light in lights) {
				scene.addChild(light);
			}
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, stage_context3dCreate);
			stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, stage3Ds_error);
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO,Context3DProfile.STANDARD);
		}
		
		private function stage3Ds_error(e:ErrorEvent):void 
		{
			agalVersion = 1;
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
		}
		
		private function stage_context3dCreate(e:Event):void 
		{
			context = stage.stage3Ds[0].context3D;
			driverInfo = context.driverInfo;
		}
		
		public function updateCtrl():void {
			for each(var ctrl:Ctrl in ctrls) {
				ctrl.update();
			}
		}
		
		public function render(time:Number=0):void {
			this.time = time;
			if (context) {
				if(context.driverInfo == "Disposed"){
					invalid = true;
					//stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
					return;
				}
				if (invalid) {
					stage3dWidth = stage.stageWidth;
					stage3dHeight = stage.stageHeight;
					context.configureBackBuffer(stage3dWidth, stage3dHeight, antiAlias);
				}
				if (posts.length) {
					var len:int = posts.length>1?2:1;
					for (var i:int = 0; i < len; i++ ) {
						if(invalid)postRTTs[i].invalid = invalid;
						postRTTs[i].update(this);
					}
					context.setRenderToTexture(postRTTs[0].texture, true, antiAlias);
				}else {
					context.setRenderToBackBuffer();
				}
				invalid = false;
				context.clear((background>>16&0xff)/0xff,(background>>8&0xff)/0xff,(background&0xff)/0xff);
				collects.length = 0;
				drawTriangleCounter = 0;
				drawCounter = 0;
				collect(scene);
				for each(var node:Node3D in collects) {
					node.update(this);
				}
				if (posts.length) {
					for (i = 0; i < posts.length; i++ ) {
						var post:PostEffect = posts[i];
						post.update(this,i==posts.length-1);
						if (len==2) {
							var temp:TextureSet = postRTTs[0];
							postRTTs[0] = postRTTs[1];
							postRTTs[1] = temp;
						}
					}
				}
				context.present();
			}
		}
		
		private function collect(node:Node3D):void {
			collects.push(node);
			if (node.drawable) {
				drawTriangleCounter += node.drawable.index.data.length / 3;
				drawCounter++;
			}
			for each(var c:Node3D in node.children) {
				collect(c);
			}
		}
		
		public function get antiAlias():int 
		{
			return _antiAlias;
		}
		
		public function set antiAlias(value:int):void 
		{
			_antiAlias = value;
			invalid = true;
		}
	}

}