package view
{
	import com.adobe.serialization.json.JSON;
	import com.capturemedia.business.interfaces.IDisposable;
	import com.capturemedia.business.model.ModelLocator;
	
	import customevents.GenerateNextViewEvent;
	import customevents.TimeFieldEvent;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.TextArea;
	import spark.components.VGroup;
	
	import view.ui.customcomponents.DataFieldInput;
	import view.ui.customcomponents.TimeFieldSet;
	
	public class DataFieldViewCode extends Group implements IDisposable
	{
		[Bindable]
		public var _model:ModelLocator = ModelLocator.getInstance();
		
		public var dynFieldGroup:VGroup;
		private var dataFieldsCollection:Array;
		private var field:DataFieldInput;
		public var saveData:Button;
		public var saveVideoDataService:HTTPService;
		public var remarks:TextArea;
		
		public function DataFieldViewCode()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, initDataView);
		}
		
		protected function initDataView(event:FlexEvent):void
		{
			dynFieldGroup.removeAllElements();
			FlexGlobals.topLevelApplication.searchBar.addEventListener(GenerateNextViewEvent.DATA_FIELD_SET, initializeFields);
			FlexGlobals.topLevelApplication.addEventListener(TimeFieldEvent.DELETE_FIELD_EVENT, deleteFieldsFromArray);
			FlexGlobals.topLevelApplication.addEventListener(TimeFieldEvent.EDIT_FIELD_EVENT, enableFieldsToEdit);
		}
		
		protected function enableFieldsToEdit(event:TimeFieldEvent):void
		{
			// TODO Auto-generated method stub
			for(var m:int = 0; m<dynFieldGroup.numElements; m++){
				if((DataFieldInput(dynFieldGroup.getElementAt(m)).fieldName == "personality") && (DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.numElements > 0))
				{
					for(var p:int = 0; p < DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.numElements; p++)
					{
						if(TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)) !== TimeFieldSet(event.data))
						{
							TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)).editCheckBox.selected = false;
							TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)).txtPerson.enabled = false;	
							TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)).valTxt.enabled = false;
							TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)).startTimeField.enabled = false;
							TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)).endTimeField.enabled = false;
							TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p)).plusBtnSub.enabled = false;
						}
					}
				}
			}
			
			var timefield:TimeFieldSet = event.data as TimeFieldSet;
			if(timefield.editCheckBox.selected){
				timefield.txtPerson.enabled = true;	
				timefield.valTxt.enabled = true;
				timefield.startTimeField.enabled = true;
				timefield.endTimeField.enabled = true;
				timefield.plusBtnSub.enabled = true;
			}
			else{
				timefield.txtPerson.enabled = false;	
				timefield.valTxt.enabled = false;
				timefield.startTimeField.enabled = false;
				timefield.endTimeField.enabled = false;
				timefield.plusBtnSub.enabled = false;
			}
			
			
			_model.currentTimeFieldId = timefield;
		}
		
		protected function initializeFields(event:GenerateNextViewEvent):void
		{
			if(dynFieldGroup.numElements > 0)
				dynFieldGroup.removeAllElements();
			dataFieldsCollection = new Array();
			dataFieldsCollection = _model.videoDataFieldColl;
			fieldColl = new ArrayCollection();
			for(var i:int = 0; i < dataFieldsCollection.length; i++)
			{
				if(dataFieldsCollection[i].language != "ML"){
					
					
					field = new DataFieldInput();
					field.fieldName = dataFieldsCollection[i].name;
					switch(dataFieldsCollection[i].type)
					{
						case _model.TEXT_FIELD_TYPE:
							field.dataFieldSet.visible = false;
							field.dataFieldSet.includeInLayout = false;
							field.normalField.visible = true;
							field.normalField.includeInLayout = true;
							field.fieldValue = dataFieldsCollection[i].value;
							field.fieldWidth = 150;
							field.fieldHeight = 30;
							break;
						case _model.DROP_DOWN_TYPE:
							field.currentState = _model.DROP_DOWN_TYPE;
							field.fieldWidth = 150;
							field.fieldHeight = 30;
							field.dataColl = dataFieldsCollection[i].displayList;
							break;
						case _model.LIST_FIELD_TYPE:
							field.dataFieldSet.visible = true;
							field.dataFieldSet.includeInLayout = true;
							field.normalField.visible = false;
							field.normalField.includeInLayout = false;
							field.fieldWidth = 150;
							field.fieldHeight = 30;
							field.dataColl = dataFieldsCollection[i].displayList;
							
							break;
						
					}
					dynFieldGroup.addElement(field);
					fieldColl.addItem(field);
				}
			}
			
			saveData.addEventListener(MouseEvent.CLICK, onSaveDataClick);
		}
		private var fieldColl:ArrayCollection = new ArrayCollection();
		private var saveObject:Object;
		private var saveObjColl:Array = new Array();
		
		[Bindable]
		public var dataString:String = new String();
		
		protected function onSaveDataClick(event:MouseEvent):void
		{
			_model.subclipGridColl = new ArrayCollection();
			
			for(var k:int = 0; k<_model.videoDataFieldColl.length; k++){
				for(var m:int = 0; m<dynFieldGroup.numElements; m++){
					if((_model.videoDataFieldColl[k].name == DataFieldInput(dynFieldGroup.getElementAt(m)).fieldName))
					{
						if((_model.videoDataFieldColl[k].name != "personality"))
						{
							if((_model.videoDataFieldColl[k].language == "EN") && (_model.videoDataFieldColl[k].name == DataFieldInput(dynFieldGroup.getElementAt(m)).fieldName))
							{
								saveObject = new Object();
								saveObject.value = DataFieldInput(dynFieldGroup.getElementAt(m)).valueTxt.text;
								saveObject.name = _model.videoDataFieldColl[k].name;
								saveObject.id = _model.videoDataFieldColl[k].id;
								saveObject.ln = _model.videoDataFieldColl[k].language;
								saveObject.type = "textField";
								saveObjColl.push(saveObject);
								_model.subclipGridColl.addItem(saveObject);
								for(var i:int = 0; i < _model.videoDataFieldColl.length; i++){
									if(_model.videoDataFieldColl[i].language == "ML" && _model.videoDataFieldColl[i].id == saveObject.id+"_ml"){
										
										saveObject = new Object();
										saveObject.value = _model.videoDataFieldColl[i].value;
										saveObject.name = _model.videoDataFieldColl[i].name;
										saveObject.id = _model.videoDataFieldColl[i].id;
										saveObject.ln = _model.videoDataFieldColl[i].language;
										saveObject.type = "textField";
										saveObjColl.push(saveObject);
										break;
									}
								}
							}
							/*else if((_model.videoDataFieldColl[k].language == "ML") && (_model.videoDataFieldColl[k].id == saveObject.id+"_ml"))
							{
								saveObject = new Object();
								saveObject.value = _model.videoDataFieldColl[k].value;
								saveObject.name = _model.videoDataFieldColl[k].name;
								saveObject.id = _model.videoDataFieldColl[k].id;
								saveObject.ln = _model.videoDataFieldColl[k].language;
								saveObject.type = "textField";
								saveObjColl.push(saveObject);
							}*/
						}
						else if((_model.videoDataFieldColl[k].name == "personality"))
						{
							saveObject = new Object();
							saveObject.name = _model.videoDataFieldColl[k].name;
							saveObject.id = _model.videoDataFieldColl[k].id;
							saveObject.type = "textField";
							var multiItemArr:Array = new Array();
							for(var a:int = 0; a < DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.numElements; a++){
								
								var timefield:TimeFieldSet = TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(a))
								var multiObj:Object = new Object();
								multiObj.id = a;
								multiObj.name = timefield.txtPerson.text;
								multiObj.name_ml = "";
								multiObj.multi_sub = timefield.valTxt.text;
								multiObj.multi_sub_ml = "";
								multiObj.timecode_from = timefield.startTimeField.text;
								multiObj.timecode_to = timefield.endTimeField.text;
								
								multiItemArr.push(multiObj);
							}
							saveObject.name = "personality";
							saveObject.id = "personality";
							saveObject.type = "Listname";
							saveObject.MultiItem = multiItemArr;
							saveObject.ln = _model.videoDataFieldColl[k].language;
							saveObject.value = _model.videoDataFieldColl[k].value;
							saveObjColl.push(saveObject);
							_model.subclipGridColl.addItem(saveObject);
						}
					}
				}
			}
			saveObject = new Object();
			saveObject.id = "subtype";
			saveObject.name = "sub type";
			saveObject.ln = "EN";
			saveObject.type = "textField";
			saveObject.value = _model.subType;
			
			saveObjColl.push(saveObject);
			
			var objSend:Object = new Object();
			dataString = com.adobe.serialization.json.JSON.encode(saveObjColl);
			trace("Parsed data to save :: "+dataString);
//						Alert.show("Parsed data to save :: "+dataString);
			debug(dataString);
			saveVideoDataService.url = "http://prd.nictpeople.org/admin/save.php?data='"+dataString+"'";
//			saveVideoDataService.url = "http://localhost/prd/save.php?data='"+dataString+"'";
			objSend.data = dataString;
			saveVideoDataService.send(objSend);
		}
		
		public static function debug(str:String):void{
			if(ExternalInterface.available){
				ExternalInterface.call("flashDebug", str);
			}
		}

		
		protected function onResult(event:ResultEvent):void
		{
			debug("In Result Event! ~~~ "+"Result :: "+event.result+ " ::::  Result message from backend :: " +event.message);
			trace("Result :"+event.message);
			if(event.result == "1"){
				Alert.show("Subtype(s) saved successfully!");
				dispose();
			}
		}
		
		protected function onFault(event:FaultEvent):void
		{
			Alert.show("Request faulted!!" + event.message);
		}
		
		private function deleteFieldsFromArray(event:TimeFieldEvent):void
		{
			
			
			var deletedObj:Object = new Object();
			deletedObj = event.data;
			if(saveObjColl.length > 0)
			{
				var obj:Object = new Object();
				for(var i:int = 0; i<saveObjColl.length; i++)
				{
					obj = saveObjColl[i];
					if(obj.subject == deletedObj.subject){
						break;
						
						trace("subject : "+ obj.subject + " :: " + deletedObj.subject);
					}
					
				}
				
				for(var j:int = i; j < saveObjColl.length; j++){
					saveObjColl[j] = saveObjColl[j+1];					
				}
				
				saveObjColl.pop();
			}
			
			for(var m:int = 0; m<dynFieldGroup.numElements; m++){
				if((DataFieldInput(dynFieldGroup.getElementAt(m)).fieldName == "personality") && (DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.numElements > 0))
				{
					for(var p:int = 0; p < DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.numElements; p++)
					{
						if(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(p) === event.target)
						{
							DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.removeElementAt(p);
							_model.timeFieldNumElements = DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.numElements;
							break;
							
						}
					}
					/*
					var timefield:TimeFieldSet = TimeFieldSet(DataFieldInput(dynFieldGroup.getElementAt(m)).dataFieldSet.getElementAt(_model.timeFieldNumElements - 1));
					timefield.txtPerson.enabled = true;	
					timefield.valTxt.enabled = true;
					timefield.startTimeField.enabled = true;
					timefield.endTimeField.enabled = true;
					timefield.plusBtnSub.enabled = true;
					
					_model.currentTimeFieldId = timefield;*/
					
				}
			}
		}
		
		public function dispose():void
		{
			saveObjColl = new Array();
		}
	}
}