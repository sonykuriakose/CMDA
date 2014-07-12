package customevents
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GenerateNextViewEvent extends MouseEvent
	{
		public static const DATA_FIELD_SET:String = "GenerateDataFieldViewEvent";
		public var data:Object;
		
		public function GenerateNextViewEvent(type:String, data:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			this.data = data;
		}
		override public function clone():Event
		{
			return new GenerateNextViewEvent(type, data, bubbles, cancelable);
		}
	}
}