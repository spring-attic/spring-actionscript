package com.adobe.cairngorm.samples.store.business {

	import org.springextensions.actionscript.cairngorm.IResponderAware;

	public interface IProductDelegate extends IResponderAware {

		function getProducts():void;

	}
}
