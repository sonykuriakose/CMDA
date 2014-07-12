package customevents
{
	import flash.events.Event;
	
	public class VideoProcessEvent extends Event
	{
		public static const START_PROCESS:String = "StartProcessingEvent";
		public static const COMPLETE_PROCESS:String = "CompletedPRocessingEvent";
		
		public var data:Object;
		
		public function VideoProcessEvent(type:String, data:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			this.data = data;
		}
		override public function clone():Event
		{
			return new VideoProcessEvent(type, data, bubbles, cancelable);
		}
	}
}