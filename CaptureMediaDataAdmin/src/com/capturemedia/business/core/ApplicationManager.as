package com.capturemedia.business.core
{
	import com.adobe.serialization.json.JSON;
	import com.capturemedia.business.interfaces.IDisposable;
	import com.capturemedia.business.model.ModelLocator;
	
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import spark.components.Application;
	
	public class ApplicationManager extends Application implements IDisposable
	{
		public var appLoadingService:HTTPService;
		private var _model:ModelLocator = ModelLocator.getInstance();
		public function ApplicationManager()
		{
			super();
		}
		
		public function init():void
		{
			trace("@@Application initialized!!");
			appLoadingService.send();
		}
		
		protected function onResult(event:ResultEvent):void
		{
			// TODO Auto-generated method stub
			var obj:Object= com.adobe.serialization.json.JSON.decode(String(event.result)); 
			var resultCollection:ArrayCollection = new ArrayCollection;
			var str:String = new String();
			for each(str in obj)
			{
				resultCollection.addItem(str);
			}
			
			_model.typeList = resultCollection;
			this.currentState = "Initialized";
		}
		
		protected function onFault(event:FaultEvent):void
		{
			// TODO Auto-generated method stub
			Alert.show("Request faulted!!" + event.message);
		}
		
		public function dispose():void
		{
		}
	}
}