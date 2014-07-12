package view
{
	import com.adobe.serialization.json.JSON;
	import com.capturemedia.business.interfaces.IDisposable;
	import com.capturemedia.business.model.ModelLocator;
	
	import customevents.GenerateNextViewEvent;
	import customevents.VideoProcessEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import spark.components.ComboBox;
	import spark.components.Group;
	import spark.components.Image;
	import spark.events.IndexChangeEvent;
	
	import utils.vo.FieldsVO;
	
	public class SearchBarComponentViewCode extends Group implements IDisposable
	{
		public var searchDropDown:ComboBox;
		public var searchDropDownItem:ComboBox;
		public var processVidBtn:Image;
		public var getVideoFieldIdService:HTTPService;
		public var getVideoDetailsService:HTTPService;
		private var searchArrayColl:ArrayCollection;
		private var _model:ModelLocator = ModelLocator.getInstance();
		private var dataFieldArray:Array;
		private var displayListArray:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var getTypeField:String = "";
		public var getIdField:String = "";
		
		public function SearchBarComponentViewCode()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteHandler);
		}
		
		private function onCreationCompleteHandler(event:FlexEvent):void
		{
			setDataToDropDown();
			
		}
		
		
		private function setDataToDropDown():void
		{
			searchDropDown.dataProvider = _model.typeList;
			searchDropDown.addEventListener(IndexChangeEvent.CHANGE, getVideoType);
		}
		protected function getVideoType(event:IndexChangeEvent):void
		{
			
			getTypeField = searchDropDown.selectedItem;
			getVideoFieldIdService.send();
			
		}
		
		protected function onResultGetTypeField(event:ResultEvent):void
		{
			var obj:Object= com.adobe.serialization.json.JSON.decode(String(event.result));
			var videoList:ArrayCollection = new ArrayCollection();
			for each(var str:String in obj)
			{
				videoList.addItem(str);
			}
			_model.videoIdList = videoList;
			searchDropDownItem.dataProvider = _model.videoIdList;
			
			searchDropDownItem.addEventListener(IndexChangeEvent.CHANGE, getVideoId);
		}
		
		protected function onFaultGetTypeField(event:FaultEvent):void
		{
			Alert.show("Request faulted!!" + event.message);			
		}
		
		protected function getVideoId(event:IndexChangeEvent):void
		{
			getIdField = searchDropDownItem.selectedItem;
			
			getVideoDetails();
		}
		
		private function getVideoDetails():void
		{
			getVideoDetailsService = new HTTPService();
			getVideoDetailsService.url = "http://prd.nictpeople.org/admin/editgui.php?type="+getTypeField+"&videoId="+getIdField;
			getVideoDetailsService.method = "GET";
			getVideoDetailsService.resultFormat = "text";
			getVideoDetailsService.addEventListener(ResultEvent.RESULT, onResultGetVideoDetails);
			getVideoDetailsService.addEventListener(FaultEvent.FAULT, onFaultGetVideoDetails);
			if(searchDropDown.selectedItem && searchDropDownItem.selectedItem)
			{
				getVideoDetailsService.send();
			}
		}
		
		
		protected function startProcessingVideo(event:MouseEvent):void
		{
			if(searchDropDown.selectedItem && searchDropDownItem.selectedItem)
			{
				var obj:Object = new Object();
				obj.slectedSubject = searchDropDown.selectedItem;
				obj.videoId = searchDropDownItem.selectedItem;
				dispatchEvent(new VideoProcessEvent(VideoProcessEvent.START_PROCESS, obj));
			}
		}
		
		protected function onResultGetVideoDetails(event:ResultEvent):void
		{
			dataFieldArray = new Array();
			var obj:Object= com.adobe.serialization.json.JSON.decode(String(event.result));
			var videoDataList:ArrayCollection = new ArrayCollection();
			var array:Array = obj.DATA_ITEMS as Array;
			var fieldVO:FieldsVO;
			for(var i:int = 0; i < array.length; i++)
			{
				fieldVO = new FieldsVO();
				fieldVO.id = array[i].id;
				fieldVO.name = array[i].name;
				fieldVO.language = array[i].ln;
				fieldVO.type = array[i].type;
				fieldVO.value = array[i].value;
				
				dataFieldArray.push(fieldVO);
			}
			
			_model.videoDataFieldColl = new Array(); 
			_model.videoDataFieldColl = dataFieldArray;
			
			this.dispatchEvent(new GenerateNextViewEvent(GenerateNextViewEvent.DATA_FIELD_SET,_model));
		}
		
		protected function onFaultGetVideoDetails(event:FaultEvent):void
		{
			
		}
		
		protected function onFault(event:FaultEvent):void
		{
			Alert.show("Request faulted!!" + event.message);
		}
		
		public function dispose():void
		{
			
		}
	}
}