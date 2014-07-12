package com.capturemedia.business.interfaces
{
	public interface ICommand
	{
		function execute():void;
		function resultHandler(event:Object):void;
		function faultHandler(event:Object):void;
	}
}