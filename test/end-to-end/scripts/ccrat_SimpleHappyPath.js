
const assert = require('assert');
const path = require('path');
const test = require('selenium-webdriver/testing');
const webdriver = require('selenium-webdriver');
const testResults = require("./testResult")
By = webdriver.By,
until = webdriver.until;

describe('Test Suite 1 - ' + path.basename(__filename), function() {
  // default: {filename} - Test Suite 1

  test.before(function(){
        
    // do something before test suite execution
    // no matter if there are failed cases

  });

  test.after(function(){

    // do something after test suite execution is finished
    // no matter if there are failed cases

  });

  test.beforeEach(function(){
    
    // do something before test case execution
    // no matter if there are failed cases

  });

  test.afterEach(function(){

    // do something after test case execution is finished
    // no matter if there are failed cases

  });

  test.it('test', function(done) {
    this.timeout(0);
    var driver = new webdriver.Builder()
    .forBrowser('firefox')
    .build();

    driver.get("https://ccrisktool-dev.cancer.gov/index.html");
    driver.findElement(By.id(`AssessPatientRisk`)).click();
	driver.findElement(By.xpath(`//section[@id='demo-section']/div/div[2]/div/span`)).click();
	driver.findElement(By.xpath(`//section[@id='demo-section']/div[2]/div/div/span`)).click();
	driver.findElement(By.id(`age`)).click();
	driver.findElement(By.id(`age`)).sendKeys('/Users/stockmanc2/github/selenium-ide-js-converter/examples/56');
	driver.findElement(By.xpath(`//option[@value='56']`)).click();
	driver.findElement(By.css(`#maleFocus > span.removeOutline`)).click();
	driver.findElement(By.id(`height_ft`)).click();
	driver.findElement(By.id(`height_ft`)).sendKeys('6');
	driver.findElement(By.id(`height_in`)).click();
    driver.findElement(By.id(`height_in`)).sendKeys('1');
    driver.findElement(By.id(`weight`)).click();
    driver.findElement(By.id(`weight`)).sendKeys('221');
    driver.findElement(By.id(`veg_servings`)).sendKeys('/Users/stockmanc2/github/selenium-ide-js-converter/examples/None');
    driver.findElement(By.xpath(`//option[@value='0']`)).click();
    driver.findElement(By.id(`moderate_months`)).sendKeys('/Users/stockmanc2/github/selenium-ide-js-converter/examples/0');
    driver.findElement(By.xpath(`(//option[@value='0'])[2]`)).click();
    driver.findElement(By.id(`vigorous_months`)).sendKeys('/Users/stockmanc2/github/selenium-ide-js-converter/examples/0');
    driver.findElement(By.xpath(`(//option[@value='0'])[3]`)).click();
    driver.findElement(By.xpath(`//section[@id='medical-section']/div/div[2]/div`)).click();
    driver.findElement(By.xpath(`//section[@id='medical-section']/div[3]/div[2]/div/span`)).click();
    driver.findElement(By.xpath(`//section[@id='medical-section']/div[4]/div[2]/div/span`)).click();
    driver.findElement(By.xpath(`//section[@id='family-section']/div/div[2]/div`)).click();
    driver.findElement(By.xpath(`//section[@id='cigarette-section']/div/div[2]/div`)).click();
    driver.findElement(By.id(`calculate`)).click();

	let errorMessage = "There was an error and the results page was not displayed."
    driver.wait( until.elementLocated(By.id('results_box3')), 5000, errorMessage)
    testResults.verify(driver)

    driver.close()
    done()


  });

  // test.it("Test-2", function(done){
 
  //   // test Code
  //   // assertions
    
  // });

  // test.it("Test-3", function(done){

  //     // test Code
  //     // assertions

  // });

})
