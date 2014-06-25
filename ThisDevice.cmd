@echo off
echo {
	echo "make":"
		wmic computersystem get manufacturer /value
	echo ","model":"
		wmic computersystem get model /value
	echo ","ram":"
		wmic os get totalvisiblememorysize /value
	echo ","cpu":"
		wmic cpu get name /value
	echo ","hdd":"
		wmic diskdrive get deviceid, caption, size /value
	echo "
echo }