package org.springextensions.actionscript.samples.organizer.application.service {

import org.springextensions.actionscript.core.operation.IOperation;
import org.springextensions.actionscript.samples.organizer.domain.Contact;

public interface IContactImageService {

	/**
	 * Loads the image of the given contact as a ByteArray.
	 * @return
	 */
	function getImageData(contact:Contact):IOperation;

}
}