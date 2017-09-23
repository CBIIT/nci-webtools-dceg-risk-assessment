const assert = require('assert');
const path = require('path');
const test = require('selenium-webdriver/testing')
const webdriver = require('selenium-webdriver')

By = webdriver.By, until = webdriver.until

function initializeFireFox() {
   return new webdriver.Builder().forBrowser('chrome').build();
}

//function cleanup(driver) {
//  await driver.close();
//  done();
//}

function getBaseUrl() {
  return "http://localhost:5006/"
}

function gotoCalculatePage() { 
  return "http://localhost:9200/calculator.html"
}


function gotoIndexURL() {
  return "http://localhost:9200/index.html"
}

function correct(driver) {
  return driver.current
}

test.describe("Test Suite Calculation", async function() {

  var driver;

  before(async function() {
    await console.log("Currently in before() ");
    this.timeout(0)
    var driver = initializeFireFox();
    await driver.get(gotoCalculatePage());
    await console.log("Currently leaving before() ");
  });

  test.it("Enter Inputs to prduce a calcuation and verify that the results page is visible and that the value(s) are correct", async function(done) {

    //let classes = ""
    //url = await driver.findElement(By.id("gotoInputPageLink")).getAttribute("href");
    //console.log("The url is " + url);

    //javascriptStr = "document.getElementById('gotoInputPageLink').setAttribute('href','" + url + "');";
    //await driver.executeScript(javascriptStr).then(function(return_value)
    //  {
    //    console.log("The return value is " + return_value);
    //  });

    //await driver.findElement(By.id("gotoInputPageLink")).click();

    //driver.takeScreenshot().then(
    //   function(image, err) {
    //      require('fs').writeFile('out.png', image, 'base64', function(err) {
    //      console.log(err);
    //   });
    //});

    //await driver.wait( function() { return until.urlIs(url) }, 10000)

    //await console.log("The GUI has come up");
	 
    //await driver.findElement(By.id("cancerAndRadiationHistoryNo")).click();
	                            
    //await console.log("Clicking on the first button");

    //await driver.findElement(By.id("geneticMakeupNo")).click();


    console.log(driver.findElement(By.Id("biopsyAnswerYes")).getId());
    await driver.findElement(By.css("#age > option:last-child")).click();
    await driver.findElement(By.css("#race > option:nth-child(2)")).click();

    //await console.log("Currently tyring to print out a value");
    //await console.log(driver.findElement(By.id("biopsyAnswerYes")).then( function(element) { console.log("In Callback... "); return element.getId(); }));
    //await driver.findElement(By.id("biopsyAnswerYes")).click();
    await driver.findElement(By.css("#biopsyAnswerYes")).click();
    await driver.findElement(By.id("breastBiopsiesCount1")).click();
    await driver.findElement(By.id("hadAhNo")).click();
    await driver.findElement(By.id("firstPeriodPast14"));
    await driver.findElement(By.id("#childbirth_age > nth-option(3)")).click();

    await driver.wait( function() { return until.elementIsEnabled(findElement(By.id("calculate")), 300); });
    
    driver.findElement(By.id("calculate")).click();
    
    await driver.wait( function() { return until.elementIsEnabled(findElement(By.id("results_box")), 10000); });
    await driver.wait( function() { return until.elementIsEnabled(findElement(By.id("results_box2")), 3000); });

    var fiveYearResult = findElement(By.id("Risk1")).text();
    console.log("Value of fiveYearResult = " + fiveYearResult);
    await driver.wait( function() { return until.elementTextMatches("Risk1", "5.8\%"); }, 3000);
    
    var lifetimeResult = findElement(By.id("Risk2")).text();
    console.log("Value of life time result = " + lifetimeResult);
    await driver.wait( function() { return until.elementTextMatches("Risk1", "5.8\%"); }, 3000);

    driver.takeScreenshot().then(
       function(image, err) {
          require('fs').writeFile('out.png', image, 'base64', function(err) {
          console.log(err);
       });
    });


    //await done();	  
    await driver.close();
    done();
    //cleanup(driver);
  });

});
