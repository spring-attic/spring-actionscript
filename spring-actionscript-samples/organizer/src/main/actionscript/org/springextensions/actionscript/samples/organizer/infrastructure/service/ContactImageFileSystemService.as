package org.springextensions.actionscript.samples.organizer.infrastructure.service {

import org.springextensions.actionscript.core.operation.IOperation;
import org.springextensions.actionscript.samples.organizer.application.service.IContactImageService;
import org.springextensions.actionscript.samples.organizer.domain.Contact;
import org.springextensions.actionscript.samples.organizer.infrastructure.service.operation.LoadContactImageFromFileSystemOperation;

public class ContactImageFileSystemService implements IContactImageService {

	public function ContactImageFileSystemService() {
	}

	public function getImageData(contact:Contact):IOperation {
		return new LoadContactImageFromFileSystemOperation(contact);
	}
}
}