package org.springextensions.actionscript.samples.organizer.infrastructure.repository {

	import mx.rpc.remoting.RemoteObject;

	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.rpc.remoting.RemoteObjectService;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.domain.IContactRepository;

	/**
	 * Remote object implementation of the IContactRepository.
	 *
	 * @author Christophe Herreman
	 */
	public class ContactRemoteObjectRepository extends RemoteObjectService implements IContactRepository {

		/**
		 * creates a new <code>ContactRemoteObjectRepository</code> instance.
		 */
		public function ContactRemoteObjectRepository(remoteObject:RemoteObject) {
			super(remoteObject);
		}

		/**
		 * @inheritDoc
		 */
		public function getContacts():IOperation {
			return call("getContacts");
		}

		/**
		 * @inheritDoc
		 */
		public function getContactsByName(name:String):IOperation {
			return call("getContactsByName", name);
		}

		/**
		 * @inheritDoc
		 */
		public function save(contact:Contact):IOperation {
			return call("save", contact);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(contact:Contact):IOperation {
			return call("remove", contact);
		}

	}
}