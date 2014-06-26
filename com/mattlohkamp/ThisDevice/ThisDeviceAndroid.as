package com.mattlohkamp.ThisDevice	{
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.ProgressEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;

	public class ThisDeviceAndroid extends EventDispatcher	{
		private var _inProgress:Boolean;
		public function get inProgress():Boolean	{return _inProgress;};
		private var JSONObject:Object = {};
		
		public function init():void	{
			_inProgress = true;
			
				//	memory
			
			var meminfo_original:File = new File().resolvePath('/proc/meminfo');
			var meminfo_copy:File = File.documentsDirectory.resolvePath('meminfo');
			meminfo_original.copyTo(meminfo_copy, true);
			meminfo_copy.addEventListener(Event.COMPLETE, function(e:Event):void	{
				trace(File(e.target).data);
			});
			meminfo_copy.load();
			
				//	processor
			
			var cpuinfo_original:File = new File().resolvePath('/proc/cpuinfo');
			var cpuinfo_copy:File = File.documentsDirectory.resolvePath('cpuinfo');
			cpuinfo_original.copyTo(cpuinfo_copy, true);
			cpuinfo_copy.addEventListener(Event.COMPLETE, function(e:Event):void	{
				trace(File(e.target).data);
			});
			cpuinfo_copy.load();
		}
		
		private function queueProgress(e:Event):void	{
			
		}
		
		private function queueComplete(e:NativeProcessExitEvent):void	{
			parseData();
		}
		
		private function parseData():void	{
			_inProgress = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
			//	public data accessors - error out if proc isn't completed, listen for Event.COMPLETE before calling

		public function get make():String	{
			return JSONObject.make;
		}
		
		public function get model():String	{
			return JSONObject.model;
		}
		
		public function get cpu():String	{
			return JSONObject.cpu;
		}
		
		public function get ram():String	{	//	total RAM measured in kilobytes
			return JSONObject.ram;
		}
		
		public function get hdd():Array	{	//	each entry has an internal id, a hardware name, and a size value (in bytes)
			return JSONObject.hdd;
		}		
	}
}