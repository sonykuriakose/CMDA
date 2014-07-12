package customevents
{
	import flash.events.Event;
	
	public class TimeFieldEvent extends Event
	{
		public static const ADD_FIELD_EVENT:String = "AddFieldEvent";
		public static const DELETE_FIELD_EVENT:String = "DeleteFieldEvent";
		public static const EDIT_FIELD_EVENT:String = "EditFieldEvent";
		
		public var data:Object;
		
		public function TimeFieldEvent(type:String, data:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			this.data = data;
		}
		override public function clone():Event
		{
			return new TimeFieldEvent(type, data, bubbles, cancelable);
		}
	}
}