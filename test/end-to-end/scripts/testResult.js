const assert = require('assert');

exports.verify = function verify(driver) {
		driver.findElement(By.id('results_box3')).isDisplayed().then( function(displayed) {
		    assert(displayed, "ID='results_box3' was not displayed, so there was no switch to the results page")
		} )
}