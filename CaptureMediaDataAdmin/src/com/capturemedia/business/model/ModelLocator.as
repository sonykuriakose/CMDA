package com.capturemedia.business.model
{
	import mx.collections.ArrayCollection;
	
	import view.ui.customcomponents.TimeFieldSet;

	[Bindable]
	public class ModelLocator
	{
		private static var _instance:ModelLocator;
		
		public var userName:String;
		public var password:String;
		public var subClippingsColl:ArrayCollection;
		public var videoIdList:ArrayCollection;
		public var videoDataColl:ArrayCollection;
		public var videoDataFieldColl:Array;
		public var startTime:String;
		public var endTime:String;
		public var TEXT_FIELD_TYPE:String = "textField";
		public var DROP_DOWN_TYPE:String = "dropDown";
		public var DATE_FIELD_TYPE:String = "dateField";
		public var LIST_FIELD_TYPE:String = "ListName";
		public var typeList:ArrayCollection;
		public var timeFieldNumElements:Number = 1;
		public var currentTimeFieldId:TimeFieldSet;
		public var subType:String;
		
		public var subclipGridColl:ArrayCollection;
		
		public function ModelLocator(enforcer:SingletonEnforcer)
		{
		}
		 public static function getInstance():ModelLocator
		{
			if (!_instance)
			{
				_instance = new ModelLocator(new SingletonEnforcer());
			}
			return _instance;
		}
	}
}
class SingletonEnforcer{}