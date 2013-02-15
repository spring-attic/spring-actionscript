package org.springextensions.actionscript.domain.util {

	import org.springextensions.actionscript.domain.INamed;

	/**
	 * @author Christophe Herreman
	 */
	public class NamedImpl implements INamed {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function NamedImpl(name:String = "") {
			this.name = name;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// name
		// ----------------------------

		private var m_name:String;

		public function get name():String {
			return m_name;
		}

		public function set name(value:String):void {
			if (value !== m_name) {
				m_name = value;
			}
		}
	}
}