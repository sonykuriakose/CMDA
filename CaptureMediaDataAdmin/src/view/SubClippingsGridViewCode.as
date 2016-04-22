package view
{
	import com.capturemedia.business.interfaces.IDisposable;
	import com.capturemedia.business.model.ModelLocator;
	
	import spark.components.Group;
	
	public class SubClippingsGridViewCode extends Group implements IDisposable
	{
		[Bindable]
		public var _model:ModelLocator = ModelLocator.getInstance();
		
		public function SubClippingsGridViewCode()
		{
			super();
		}
		
		public function dispose():void
		{
		}
	}
}