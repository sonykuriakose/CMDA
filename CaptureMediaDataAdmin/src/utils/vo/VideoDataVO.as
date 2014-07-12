package utils.vo
{
	[Bindable]
	public class VideoDataVO
	{
		public var video_id:String = String();
		public var video_name:String = String();
		public var video_path:String = String();
		
		public var datafields:DataFieldVO = new DataFieldVO();
		public var subclippings:SubClippingsVO = new SubClippingsVO();
		
		public function VideoDataVO()
		{
			
		}
	}
}