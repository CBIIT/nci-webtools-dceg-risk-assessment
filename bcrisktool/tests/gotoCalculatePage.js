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
  return "http://localhost:9200/"
}


function gotoIndexURL() {
  return "http://localhost:9200/index.html"
}

function correct(driver) {
  return driver.current
}

test.describe("Test Suite", async function() {
  test.it("When the Access Patient Link is clicked then the Input Page should be shown", async function(done) {
    this.timeout(0)
    var driver = initializeFireFox();
    await driver.get(gotoIndexURL());


    let classes = ""
    url = await driver.findElement(By.id("gotoInputPageLink")).getAttribute("href");
    console.log("The url is " + url);

    javascriptStr = "document.getElementById('gotoInputPageLink').setAttribute('href','" + url + "');";
    await driver.executeScript(javascriptStr).then(function(return_value)
      {
        console.log("The return value is " + return_value);
      });

    await driver.findElement(By.id("gotoInputPageLink")).click();

    driver.takeScreenshot().then(
       function(image, err) {
          require('fs').writeFile('out.png', image, 'base64', function(err) {
          console.log(err);
       });
    });

    await driver.wait( function() { return until.urlIs(url) }, 10000)

    //await done();	  
    driver.close();
    done();
    //cleanup(driver);
  });

});
