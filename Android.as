package  {
	
	import flash.display.MovieClip;
	import com.mattlohkamp.ThisDevice.ThisDeviceAndroid;
	
	
	public class Android extends MovieClip {
		private var thisDevice:ThisDeviceAndroid = new ThisDeviceAndroid();
		
		public function Android() {
			thisDevice.init();
		}
	}
	
}
