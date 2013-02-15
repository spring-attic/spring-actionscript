package org.springextensions.actionscript.samples.organizer.domain {
	
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.builder.ToStringBuilder;
	
	[Bindable]
	[RemoteClass(alias="insync.model.Contact")]
	public class Contact implements ICloneable, IEquals {
		
		public var id:int = 0;
		public var firstName:String;
		public var lastName:String;
		public var email:String;
		public var phone:String;
		public var address:String;
		public var city:String;
		public var state:String;
		public var zip:String;
		public var dob:Date;
		public var pic:String;

		/**
		 * Creates a new Contact.
		 */
		public function Contact(id:int = 0, firstName:String = "", lastName:String = "", email:String = "", phone:String = "", address:String = "", city:String = "", state:String = "", zip:String = "", dob:Date = null, pic:String = "") {
			this.id = id;
			this.firstName = firstName;
			this.lastName = lastName;
			this.email = email;
			this.phone = phone;
			this.address = address;
			this.city = city;
			this.state = state;
			this.zip = zip;
			this.dob = dob;
			this.pic = pic;
		}
		
		public function get fullName():String {
			return firstName + " " + lastName;
		}

		/**
		 * Compares this contact with the given one and returns true if the contacts are equals. Since Contact
		 * is an entity, equality is based on the entity's identity.
		 *
		 * @param other the contact with which to compare this contact for equality
		 * @return true is the contacts are equals, false if not
		 */
		public function equals(other:Object):Boolean {
			if (this == other) {
				return true;
			}
			
			if (!(other is Contact)) {
				return false;
			}
			
			var that:Contact = Contact(other);
			return (id == that.id);
		}

		/**
		 * Returns a clone of this contact.
		 * @return a clone of this contact
		 */
		public function clone():* {
			return new Contact(id, firstName, lastName, email, phone, address, city, state, zip, dob, pic);
		}

		/**
		 * Returns a string representation of this contact, used for debugging purposes.
		 * @return the contact as a string
		 */
		public function toString():String {
			return new ToStringBuilder(this)
				.append(id, "id")
				.append(firstName, "firstName")
				.append(lastName, "lastName")
				.append(email, "email")
				.append(phone, "phone")
				.append(address, "address")
				.append(city, "city")
				.append(state, "state")
				.append(zip, "zip")
				.append(dob, "dob")
				.append(pic, "pic")
				.toString();
		}
		
		public function toPlainObject():Object{
			var obj:Object = {};
			obj.id = this.id;
			obj.firstName = this.firstName;
			obj.lastName = this.lastName;
			obj.email = this.email;
			obj.phone = this.phone;
			obj.address = this.address;
			obj.city = this.city;
			obj.state = this.state;
			obj.zip = this.zip;
			obj.dob = this.dob;
			obj.pic = this.pic;
			return obj;
		}
	}
}