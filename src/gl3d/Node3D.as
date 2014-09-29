package gl3d 
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author lizhi
	 */
	public class Node3D 
	{
		public var parent:Node3D;
		public var world:Matrix3D = new Matrix3D;
		private var _matrix:Matrix3D = new Matrix3D;
		public var children:Vector.<Node3D> = new Vector.<Node3D>;
		public var drawable:Drawable3D;
		public var material:Material;
		private var trs:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(),new Vector3D(),new Vector3D(1,1,1)]);
		public function Node3D() 
		{
			
		}
		
		public function addChild(n:Node3D):void {
			children.push(n);
			n.parent = this;
		}
		
		public function update(view:View3D,camera:Camera3D):void {
			if (parent) {
				world.copyFrom(parent.world);
			}else {
				world.identity();
			}
			world.append(matrix);
			for each(var c:Node3D in children) {
				c.update(view,camera);
			}
			
			if (material) {
				material.draw(this,camera,view);
			}
		}
		
		public function get matrix():Matrix3D 
		{
			return _matrix;
		}
		
		public function set matrix(value:Matrix3D):void 
		{
			_matrix = value;
			trs=value.decompose();
		}
		
		public function recompose():void {
			_matrix.recompose(trs);
		}
		
		public function get x():Number 
		{
			return trs[0].x;
		}
		
		public function set x(value:Number):void 
		{
			trs[0].x = value;
			recompose()
		}
		
		public function get y():Number 
		{
			return trs[0].y;
		}
		
		public function set y(value:Number):void 
		{
			trs[0].y = value;
			recompose()
		}
		
		public function get z():Number 
		{
			return trs[0].z;
		}
		
		public function set z(value:Number):void 
		{
			trs[0].z = value;
			recompose()
		}
		
		public function get rotationX():Number 
		{
			return trs[1].x;
		}
		
		public function set rotationX(value:Number):void 
		{
			trs[1].x = value;
			recompose()
		}
		
		public function get rotationY():Number 
		{
			return trs[1].y;
		}
		
		public function set rotationY(value:Number):void 
		{
			trs[1].y = value;
			recompose()
		}
		
		public function get rotationZ():Number 
		{
			return trs[1].z;
		}
		
		public function set rotationZ(value:Number):void 
		{
			trs[1].z = value;
			recompose()
		}
		
		public function get scaleX():Number 
		{
			return trs[2].x;
		}
		
		public function set scaleX(value:Number):void 
		{
			trs[2].x = value;
			recompose()
		}
		
		public function get scaleY():Number 
		{
			return trs[2].y;
		}
		
		public function set scaleY(value:Number):void 
		{
			trs[2].y = value;
			recompose()
		}
		
		public function get scaleZ():Number 
		{
			return trs[2].z;
		}
		
		public function set scaleZ(value:Number):void 
		{
			trs[2].z = value;
			recompose()
		}
		
	}

}