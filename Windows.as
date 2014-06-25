package  {
	
	import flash.display.MovieClip;
	import com.mattlohkamp.ThisDevice.ThisDeviceWindows;
	import flash.events.Event;
	import flash.filesystem.File;
	
	
	public class Windows extends MovieClip {
		private var thisDevice:ThisDeviceWindows = new ThisDeviceWindows();
		
		public function Windows() {
			thisDevice.addEventListener(Event.COMPLETE, ThisDeviceComplete);
			thisDevice.init(File.applicationDirectory.resolvePath('ThisDevice.cmd').nativePath);	//	remember to pass in the fully qualified native path, not relative
		}
		
		private function ThisDeviceComplete(e:Event):void	{
			trace('make:',thisDevice.make);
			trace('model:',thisDevice.model);
			trace('cpu:',thisDevice.cpu);
			trace('ram:',thisDevice.ram);
			trace('hdds:',thisDevice.hdd);
		}
	}
	
}
