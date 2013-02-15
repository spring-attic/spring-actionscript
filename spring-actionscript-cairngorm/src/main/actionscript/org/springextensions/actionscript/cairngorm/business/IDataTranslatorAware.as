package org.springextensions.actionscript.cairngorm.business
{
	/**
	 * Implemented by objects that need a reference to an <code>IDataTranslator</code> instance.
	 * @author Roland Zwaga
	 * @docref extensions-documentation.html#the_idatatranslator_interface
	 */
	public interface IDataTranslatorAware {
		/**
		 * The specified <code>IDataTranslator</code> instance.
		 */		
		function set dataTranslator(value:IDataTranslator):void;
	}
}