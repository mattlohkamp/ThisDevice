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

	public class ThisDeviceWindows extends EventDispatcher	{
		private var path:String;
		private var file:File;
		private var proc:NativeProcess = new NativeProcess();
		private const defaultPath:String = File.applicationDirectory.resolvePath('ThisDevice.cmd').nativePath;
		private var _inProgress:Boolean;
		public function get inProgress():Boolean	{return _inProgress;};
		private var _raw:String = new String();
		public function get raw():String	{return _raw;};
		private var JSONString:String;
		private var JSONObject:Object;
		
		public function init(_path:String = 'ThisDevice.cmd'):void	{
			_inProgress = true;
			path = _path;
			file = new File(path);
			var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			startupInfo.executable = file;
			proc.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, stdoutcat);
			proc.addEventListener(NativeProcessExitEvent.EXIT, procComplete);
			proc.start(startupInfo);
		}
		
		private function stdoutcat(e:ProgressEvent):void	{
			_raw += proc.standardOutput.readUTFBytes(proc.standardOutput.bytesAvailable);
		}
		
		private function procComplete(e:NativeProcessExitEvent):void	{
			parseData();
		}
		
		private function parseData():void	{
			JSONString = _raw.replace(/\s*\R/g, '\n').replace(/^\s*|[\t ]+$/gm, '').replace(/[\u000d\u000a\u0008\u0020]+/g,'').replace( /\\/g, '');
			JSONObject = JSON.parse(JSONString);
			
				//	make & model
			
			JSONObject.make = JSONObject.make.split('=')[1];
			JSONObject.model = JSONObject.model.split('=')[1];
			
				//	RAM
			
			JSONObject.ram = JSONObject.ram.split('=')[1];
			//	var RAMInGB:Number = Math.ceil(JSONObject.ram / 1024 / 1024);
			
				//	CPU
			
			JSONObject.cpu = JSONObject.cpu.split('=')[1];
			
				//	HDD
			
			JSONObject.hdd = JSONObject.hdd.split('Caption=');
			JSONObject.hdd.shift();
			var hdds:Array = new Array();
			for each(var hddStr:String in JSONObject.hdd){
				var hdd:Object = new Object();
				hdd.name = hddStr.split('DeviceDeviceID=')[0];
				hdd.id = hddStr.split('DeviceDeviceID=.')[1].split('Size=')[0];
				hdd.size = Math.ceil(hddStr.split('Size=')[1] / 1024 / 1024 / 1024);
				hdds.push(hdd);
			}
			JSONObject.hdd = hdds;
			trace('HDD',JSON.stringify(JSONObject.hdd));
			
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