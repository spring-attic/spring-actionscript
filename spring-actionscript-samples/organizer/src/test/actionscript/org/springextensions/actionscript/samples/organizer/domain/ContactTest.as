package org.springextensions.actionscript.samples.organizer.domain {

import flexunit.framework.TestCase;

public class ContactTest extends TestCase {

	public function ContactTest() {
		super();
	}

	public function testEquals_shouldReturnTrueIfSameInstance():void {
		var contact1:Contact = new Contact(1, "John", "Doe");
		var contact2:Contact = contact1;
		assertTrue(contact1.equals(contact2));
		assertTrue(contact2.equals(contact1));
	}

	public function testEquals_shouldReturnFalseForNull():void {
		var contact:Contact = new Contact(1, "John", "Doe");
		assertFalse(contact.equals(null));
	}

	public function testEquals_shouldReturnFalseForDifferentClass():void {
		var contact:Contact = new Contact(1, "John", "Doe");
		assertFalse(contact.equals("myString"));
	}
}
}