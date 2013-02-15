package org.springextensions.actionscript.cairngorm.business
{
	/**
	 * Defines a generic data translator object
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.cairngorm.business.IDataTranslatorAware
	 * @docref extensions-documentation.html#the_idatatranslator_interface
	 */
	public interface IDataTranslator {
		/**
		 * Receives an arbitrary object, performs some kind of conversion or translation and returns the result
		 * @param data the input data
		 * @return the converted or translated result
		 */
		function translate(data:*):*;
	}
}