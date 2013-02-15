package  org.springextensions.actionscript.samples.cafetownsend.domain {

	import org.as3commons.lang.ICloneable;
	import org.springextensions.actionscript.domain.ICopyFrom;

	[Bindable]
	public class Employee implements ICloneable, ICopyFrom {

		public var id:int;
		public var firstname:String;
		public var lastname:String;
		public var email:String;
		public var startdate:Date;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function Employee(id:int = -1, firstname:String = "", lastname:String = "", email:String = "", startdate:Date = null) {
			this.id = id;
			this.firstname = firstname;
			this.lastname = lastname;
			this.email = email;
			this.startdate = ( startdate == null ) ?  new Date() : startdate;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: ICloneable
		//
		// --------------------------------------------------------------------

		public function clone():* {
			var result:Employee = new Employee();
			result.copyFrom(this);
			return result;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: ICopyFrom
		//
		// --------------------------------------------------------------------

		public function copyFrom(other:*):void {
			if (other is Employee) {
				var that:Employee = Employee(other);
				id = that.id;
				firstname = that.firstname;
				lastname = that.lastname;
				email = that.email;
				startdate = new Date(that.startdate.time);
			}
		}

	}
}