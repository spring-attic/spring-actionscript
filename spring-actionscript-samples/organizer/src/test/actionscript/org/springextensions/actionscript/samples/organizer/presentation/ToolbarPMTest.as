package org.springextensions.actionscript.samples.organizer.presentation {

	import flexunit.framework.TestCase;

	import org.as3commons.lang.IllegalArgumentError;
	import org.springextensions.actionscript.samples.organizer.application.model.ApplicationModel;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;

	public class ToolbarPMTest extends TestCase {

		public function ToolbarPMTest() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Tests: new
		//
		// --------------------------------------------------------------------

		public function testNew():void {
			var pm:ToolbarPM = new ToolbarPM(new ApplicationModel());
		}

		public function testNew_shouldThrowIllegalArgumentErrorWhenApplicationModelIsNull():void {
			try {
				var pm:ToolbarPM = new ToolbarPM(null);
				fail("Creating new ToolbarPM with null should fail");
			} catch (e:IllegalArgumentError) {}
		}

		// --------------------------------------------------------------------
		//
		// Tests: deleteAllowed
		//
		// --------------------------------------------------------------------

		public function testDeleteAllowed():void {
			var appModel:ApplicationModel = new ApplicationModel();
			var pm:ToolbarPM = new ToolbarPM(appModel);

			appModel.selectedContact = null;
			assertFalse(pm.deleteAllowed);
			
			appModel.selectedContact = new Contact();
			assertTrue(pm.deleteAllowed);

			appModel.selectedContact = null;
			assertFalse(pm.deleteAllowed);
		}
	}
}