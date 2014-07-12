package customevents
{
	import flash.events.Event;
	
	public class CaptureTimeEvent extends Event
	{
		public static const TIME_EVENT:String = "TimeEvent";
		public static const START_TIME_EVENT:String = "StartTimeEvent";
		public static const END_TIME_EVENT:String = "EndTimeEvent";
		
		public var data:Object;
		
		public function CaptureTimeEvent(type:String, data:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			this.data = data;
		}
		override public function clone():Event
		{
			return new CaptureTimeEvent(type, data, bubbles, cancelable);
		}
	}
}