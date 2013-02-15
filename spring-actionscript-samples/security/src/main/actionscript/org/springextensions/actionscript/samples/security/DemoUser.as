package org.springextensions.actionscript.samples.security {
	
	import flash.events.IEventDispatcher;
	
	import org.springextensions.actionscript.security.SimpleMembershipOwner;

	public class DemoUser extends SimpleMembershipOwner {

		public function DemoUser(target:IEventDispatcher = null) {
			super(target);
		}
		
		public var userName:String;
		public var password:String;

	}
}