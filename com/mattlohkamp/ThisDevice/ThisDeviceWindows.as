package com.mattlohkamp.ThisDevice	{
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;

	public class ThisDeviceWindows extends EventDispatcher	{
		private var path:String;
		private var file:File;
		private var proc:NativeProcess = new NativeProcess();
		private const defaultPath:String = File.applicationDirectory.resolvePath('ThisDevice.cmd').nativePath;
		
		public function init(_path:String = defaultPath):void	{
			path = _path;
			file = new File(path);
			trace(file.nativePath,file.exists);
			var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			startupInfo.executable = file;
			proc.start(startupInfo);
		}
	}
}