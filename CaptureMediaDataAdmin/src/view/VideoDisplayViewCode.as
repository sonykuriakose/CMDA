package view
{
	import com.capturemedia.business.interfaces.IDisposable;
	import com.capturemedia.business.model.ModelLocator;
	
	import customevents.CaptureTimeEvent;
	import customevents.VideoProcessEvent;
	
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	import org.osmf.events.TimeEvent;
	
	import spark.components.Group;
	import spark.components.VideoPlayer;
	
	public class VideoDisplayViewCode extends Group implements IDisposable
	{
		public var vidPlayer:VideoPlayer;
		
		private var _model:ModelLocator = ModelLocator.getInstance();
		
		public function VideoDisplayViewCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, initializeVideo);
			 
		}
		
		protected function initializeVideo(event:FlexEvent):void
		{
			vidPlayer.stop();
			vidPlayer.autoPlay = false;
			vidPlayer.playPauseButton.enabled = false;
			vidPlayer.addEventListener(CaptureTimeEvent.START_TIME_EVENT, logStartAndEndTime);
			vidPlayer.addEventListener(CaptureTimeEvent.END_TIME_EVENT, logStartAndEndTime);
			vidPlayer.addEventListener(CaptureTimeEvent.TIME_EVENT, logStartAndEndTime);
			FlexGlobals.topLevelApplication.searchBar.addEventListener(VideoProcessEvent.START_PROCESS, startVideo);
		}
		
		protected function logStartAndEndTime(event:CaptureTimeEvent):void
		{
			if(event.type == CaptureTimeEvent.START_TIME_EVENT){
				_model.startTime = vidPlayer.currentTime.toString();
			}
			else if(event.type == CaptureTimeEvent.END_TIME_EVENT)
			{
				_model.endTime = vidPlayer.currentTime.toString();
			}
			else{
				_model.startTime = event.data.startTime;			
				_model.endTime = event.data.endTime;
				vidPlayer.seek(Number(_model.startTime));
			}
			
			FlexGlobals.topLevelApplication.dispatchEvent(new CaptureTimeEvent(CaptureTimeEvent.TIME_EVENT, _model));
				
		}
		
		protected function startVideo(event:VideoProcessEvent):void
		{
			vidPlayer.source =  "";
			vidPlayer.source = "http://prd.nictpeople.org/videos/"+event.data.videoId+".flv";
//			vidPlayer.source = "http://localhost/prd/videos/"+event.data.videoId+".flv";
			vidPlayer.playPauseButton.enabled = true;
//			vidPlayer.play();
		}
		
		
		protected function captureCurrentTime(event:TimeEvent):void
		{
		}
		
		public function dispose():void
		{
			
		}
	}
}