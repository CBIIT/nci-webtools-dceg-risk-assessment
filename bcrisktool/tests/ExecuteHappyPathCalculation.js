const assert = require('assert');
const path = require('path');
const test = require('selenium-webdriver/testing')
const webdriver = require('selenium-webdriver')

By = webdriver.By, until = webdriver.until

function initializeChrome() {
   return new webdriver.Builder().forBrowser('chrome').build();
}

//function cleanup(driver) {
//  await driver.close();
//  done();
//}

function getBaseUrl() {
  return "http://localhost:5006/"
}


function gotoIndexURL() {
  return "http://localhost:5006/index.html"
}

function gotoCalculateURL() {
  return "http://localhost:5006/calculator.html"
}

function correct(driver) {
  return driver.current
}

test.describe("Test Suite", async function() {

  // Problem : Trying to intialize driver and goto page, but calling them
  // in before is not working correctly.
  test.before( function() {
    console.log("Inside Function")
  });

  test.it("Entering inputs that will produce a result", async function(done) {



    //process.on('uncaughtException', function (err) {
    //  console.log("Messagte : " + err.message);
    //  console.log("-------------------------------------")
    //})
    //
    try {

      this.timeout(0)
      var driver = initializeChrome();
      await driver.get(gotoCalculateURL());

      // Patient Eligibility
      await driver.findElement(By.xpath("//*[@for='cancerAndRadiationHistoryNo']")).click();
      await driver.findElement(By.xpath("//*[@for='geneticMakeupNo']")).click();

      // Demographics
      await driver.findElement(By.css("#age > option:last-child")).click();
      await driver.findElement(By.css("#race > option:nth-child(2)")).click();

      // Patient and Family History
      var biopsyButton = await driver.findElement(By.xpath("//*[@for='biopsyAnswerNo']"))
      let location = await biopsyButton.getLocation();

      // Need to work on removing the hardcodes values, but I don't understand,
      // but for now they are needed.  I tried working with the poistions of the
      // GUI Elements, but it did not work.
      driver.executeScript(`window.scrollTo(0, 1230)`)

      var biopsyButton = await driver.findElement(By.xpath("//*[@for='biopsyAnswerNo']"))
      await biopsyButton.click();
      var selected = await biopsyButton.isSelected();
      console.log("Value is " + selected)

      var ageOfFirstPeriod = await driver.findElement(By.xpath("//*[@for='ageGt14']"))
      await ageOfFirstPeriod.click();

      await driver.findElement(By.css("#childbirth_age > option:last-child")).click();

      driver.executeScript(`window.scrollTo(0, 1530)`)
      await driver.findElement(By.xpath("//*[@for='relativesGtOne']")).click();

      // Click the Calculate Button and the display should change to the results
      // Page.
      await driver.findElement(By.id("calculate")).click();

      // Verify that the result page has the correct data.
      let risk1Str = await driver.findElement(By.id("Risk1")).getText();
      assert.equal(risk1Str,"6%")

      let risk2Str = await driver.findElement(By.id("Risk2")).getText();
      assert.equal(risk2Str,"1%")

      let risk3Str = await driver.findElement(By.id("Risk3")).getText();
      assert.equal(risk3Str,"41%")

      let risk4Str = await driver.findElement(By.id("Risk4")).getText();
      assert.equal(risk4Str,"13%")

      driver.takeScreenshot().then(
        function(image, err) {
          require('fs').writeFile('out2.png', image, 'base64', function(err) {
          console.log(err);
        });
      });

    //await driver.wait( function() { return until.urlIs(gotoIndexURL()) }, 10000)
  } catch(err) {
    console.log("----------------------------------------------------");
    console.log(err);
    console.log(err.message);
    console.log("----------------------------------------------------");
  }


    done()
    driver.executeScript("self.close()")
    await driver.close();
    await driver.quit();
  });

});
