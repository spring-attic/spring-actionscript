package org.springextensions.actionscript.samples.organizer.infrastructure.repository {
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.MockOperation;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.domain.IContactRepository;
	
	/**
	 *
	 */
	public class ContactInMemoryRepository extends EventDispatcher implements IContactRepository {
		
		private static var logger:ILogger = LoggerFactory.getClassLogger(ContactInMemoryRepository);
		
		private var contacts:ArrayCollection = new ArrayCollection();
		
		private var nextId:int;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 *
		 */
		public function ContactInMemoryRepository() {
			var contact:Contact = new Contact(1, "Ryan", "Howard", "ryan@dundermifflin.com", "", "", "Scranton");
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 2;
			contact.firstName = "Michael";
			contact.lastName = "Scott";
			contact.email = "michael@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 3;
			contact.firstName = "Dwight";
			contact.lastName = "Schrute";
			contact.email = "dwight@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 4;
			contact.firstName = "Jim";
			contact.lastName = "Halpert";
			contact.email = "jim@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 5;
			contact.firstName = "Pam";
			contact.lastName = "Beesly";
			contact.email = "pam@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 6;
			contact.firstName = "Angela";
			contact.lastName = "Martin";
			contact.email = "angela@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 7;
			contact.firstName = "Kevin";
			contact.lastName = "Malone";
			contact.email = "kevin@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 8;
			contact.firstName = "Oscar";
			contact.lastName = "Martinez";
			contact.email = "oscar@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 9;
			contact.firstName = "Creed";
			contact.lastName = "Bratton";
			contact.email = "creed@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 10;
			contact.firstName = "Andy";
			contact.lastName = "Bernard";
			contact.email = "andy@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 11;
			contact.firstName = "Phyllis";
			contact.lastName = "Lapin";
			contact.email = "phyllis@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 12;
			contact.firstName = "Stanley";
			contact.lastName = "Hudson";
			contact.email = "stanley@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 13;
			contact.firstName = "Meredith";
			contact.lastName = "Palmer";
			contact.email = "meredith@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			contact = new Contact();
			contact.id = 14;
			contact.firstName = "Kelly";
			contact.lastName = "Kapoor";
			contact.email = "kelly@dundermifflin.com";
			contact.city = "Scranton";
			contacts.addItem(contact);
			
			nextId = 15;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IContactRepository
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function getContacts():IOperation {
			logger.debug("getContacts()");
			return new MockOperation(contacts);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getContactsByName(name:String):IOperation {
			logger.debug("getContactsByName({0})", name);
			var result:ArrayCollection = new ArrayCollection();
			name = name.toUpperCase();
			
			for each (var contact:Contact in contacts) {
				if (contact.fullName.toUpperCase().indexOf(name) >= 0) {
					result.addItem(contact);
				}
			}
			
			return new MockOperation(result);
		}
		
		/**
		 * @inheritDoc
		 */
		public function save(contact:Contact):IOperation {
			logger.debug("save({0})", contact);
			
			if (contact.id == 0) // New contact
			{
				contact.id = nextId++;
			}
			return new MockOperation(contact, MockOperation.DEFAULT_MAX_DELAY, true);
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove(contact:Contact):IOperation {
			logger.debug("remove({0})", contact);
			var result:ArrayCollection = new ArrayCollection();
			
			for each (var c:Contact in contacts) {
				if (c.id == contact.id) {
					var index:int = contacts.getItemIndex(c);
					contacts.removeItemAt(index);
					break;
				}
			}
			
			return new MockOperation(contact);
		}
	
	}
}