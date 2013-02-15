package org.springextensions.actionscript.samples.organizer.application {

/**
 * Factory that creates alert windows.
 *
 * @author Christophe Herreman
 */
public interface IAlertFactory {

	/**
	 * Creates an alert window.
	 *
	 * @param text the text to show in the alert
	 * @param title the title of the alert window
	 * @param flags indicates what buttons should be shown
	 * @param closeHandler handler function for the close event
	 */
	function createAlert(text:String, title:String, flags:uint = 4, closeHandler:Function = null):void;

}
}