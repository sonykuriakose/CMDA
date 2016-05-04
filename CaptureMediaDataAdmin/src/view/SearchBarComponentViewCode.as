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
			_model.subType = getTypeField;
			getVideoFieldIdService.send();
			
		}
		
		protected function onResultGetTypeField(event:ResultEvent):void
		{
//			trace("Video Data:" + event.result);
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
//			getVideoDetailsService.url = "http://localhost/prd/editgui.php?type="+getTypeField+"&videoId="+getIdField;
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
//			Alert.show("Video results :: " +event.result);
			dataFieldArray = new Array();
			var obj:Object= com.adobe.serialization.json.JSON.decode(String(event.result));
			
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
				if(array[i].id == "personality" && array[i].MultiItem.length > 0)
				{
					var multiItemArr:Array = new Array();
					var multiObj:Object;
					for(var j:int = 0; j < array[i].MultiItem.length; j++)
					{
						multiObj = new Object();
						multiObj.id = array[i].MultiItem[j].id;
						multiObj.name = array[i].MultiItem[j].name;
						multiObj.name_ml = array[i].MultiItem[j].name_ml;
						multiObj.multi_sub = array[i].MultiItem[j].multi_sub;
						multiObj.multi_sub_ml = array[i].MultiItem[j].multi_sub_ml;
						multiObj.timecode_from = array[i].MultiItem[j].timecode_from;
						multiObj.timecode_to = array[i].MultiItem[j].timecode_to;
						
						multiItemArr.push(multiObj);
					}
					fieldVO.displayList = multiItemArr;
				}
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