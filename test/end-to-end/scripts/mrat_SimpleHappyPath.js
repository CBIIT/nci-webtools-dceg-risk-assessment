
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

  test.it('mrat_SimpleHappyPathFemale', function(done) {
    this.timeout(0);
    var driver = new webdriver.Builder()
    .forBrowser('firefox')
    .build();

    driver.get("https://mrisktool-dev.cancer.gov" + "/calculator.html");

    let errorMessage = "There was an error and the calculatins page was not displayed."
    driver.wait( until.elementLocated(By.id('nonHispanicWhiteRace')), 5000, errorMessage)

	driver.findElement(By.css('#nonHispanicWhiteRace + div > span')).click();
    driver.findElement(By.css(`#age > .removeOutline:nth-child(6)`)).click();
    driver.findElement(By.css('#northern + div > span')).click();
    driver.findElement(By.css('#femaleGender + div > span')).click()
    driver.findElement(By.css('#lightComplexion + div > span')).click()
    driver.findElement(By.css('#deeplyTan + div > span')).click()
    driver.findElement(By.css('#smallMoleAnswerLt5 + div > span')).click()
    driver.findElement(By.css('#mildFrecklingAnswer + div > span')).click()
    driver.findElement(By.id(`calculate`)).click();

	let errorMessage2 = "There was an error and the results page was not displayed."
    driver.wait( until.elementLocated(By.id('results_box')), 5000, errorMessage2)
    testResults.verify(driver)

    done()
    driver.close()

    //driver.close();
  });

  test.it('mrat_SimpleHappyPathMale', function(done) {
    this.timeout(0);
    var driver = new webdriver.Builder()
    .forBrowser('firefox')
    .build();

    driver.get("https://mrisktool-dev.cancer.gov" + "/calculator.html");

    let errorMessage = "There was an error and the calculatins page was not displayed."
    driver.wait( until.elementLocated(By.id('nonHispanicWhiteRace')), 5000, errorMessage)

	driver.findElement(By.css('#nonHispanicWhiteRace + div > span')).click();
    driver.findElement(By.css(`#age > .removeOutline:nth-child(6)`)).click();
    driver.findElement(By.css('#northern + div > span')).click();
    driver.findElement(By.css('#maleGender + div > span')).click()
    driver.findElement(By.css('#lightComplexion + div > span')).click()
    driver.findElement(By.css('#sunburnYes + div > span')).click()
    driver.findElement(By.css('#bigMole + div > span')).click()
    driver.findElement(By.css('#smallMoleAnswerLt5 + div > span')).click()
    driver.findElement(By.css('#mildFrecklingAnswer + div > span')).click()
    driver.findElement(By.css('#yesDamage + div > span')).click()
    driver.findElement(By.id(`calculate`)).click();

    let errorMessage2 = "There was an error and the results page was not displayed."
    driver.wait( until.elementLocated(By.id('results_box')), 5000, errorMessage2)
    testResults.verify(driver)

    done()
    driver.close()




    //driver.close();
  });
})
