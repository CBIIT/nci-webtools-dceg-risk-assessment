const assert = require('assert');

exports.verify = function verify(driver) {
		driver.findElement(By.id('results_box')).isDisplayed().then( function(displayed) {
		    assert(displayed, "ID='results_box' was not displayed, so there was no switch to the results page")
		} )
}