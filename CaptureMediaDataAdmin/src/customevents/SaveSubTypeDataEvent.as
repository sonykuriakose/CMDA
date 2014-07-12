package customevents
{
	import flash.events.Event;

	public class SaveSubTypeDataEvent extends Event
	{
		public static const TIME_FIELD_ADDED_EVENT:String = "TimeFieldAddedEvent";
		
		public var data:Object;
		
		public function SaveSubTypeDataEvent(type:String, data:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			this.data = data;
		}
		override public function clone():Event
		{
			return new SaveSubTypeDataEvent(type, data, bubbles, cancelable);
		}
	}
}