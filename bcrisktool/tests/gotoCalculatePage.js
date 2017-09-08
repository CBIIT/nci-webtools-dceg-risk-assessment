const assert = require('assert');
const path = require('path');
const test = require('selenium-webdriver/testing')
const webdriver = require('selenium-webdriver')

By = webdriver.By, until = webdriver.until

function initializeFireFox() {
   return new webdriver.Builder().forBrowser('firefox').build();
}

function cleanup(driver) {
  driver.close();
}

function getBaseUrl() {
  return "http://localhost:5006/"
}


function gotoIndexURL() {
  return "http://localhost:5006/index.html"
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

    test1 = await driver.findElement(By.id("gotoInputPageLink")).click().then( function(p) {
      console.log(JSON.parse(JSON.stringify(p)));
      console.log(typeof p);
      console.log(Object.keys(p));
    });

    await driver.wait( function() { driver.wait(until.urlIs(url)) }, 1)
    console.log("Done")

        //console.log("Done");

    //console.log("url = " + classes);
    //let url = await driver.executeScript(`return 'http://localhost:5006/' + $('#gotoInputPageLink').attr('href')");
    //await driver.get(url);


//        driver.get(
//let html = await driver.findElement(By.id("gotoInputPageLink")).getAttribute('innerHTML')
//console.log(html);
//
//
//          driver.executeScript("return ${getBaseUrl()} + $('#gotoInputPageLink').attr('href')`)
//        ).then(function() {
//          driver.getCurrentUrl().then(url => assert('http://localhost:5006/calculator.html', url));
//        })
//
//
//
//    })
//
//    ;
//
 //   */


    done();
  })

/*
  test.it("When the Access Patitent Link is clicked then the Input Page should be shown.", function() {
  this.timeout(0)
  var driver = null

  if ( driver == null ) driver = initializeFireFox();

  driver.get(gotoIndexURL())
  driver.findElement(By.id("gotoInputPageLink")).click().then(function() {
    driver.sleep(3000)
  });

  assert(true);
  console.log("Current URL is " + driver.getCurrentUrl().toString());

*/

  //if ( driver != null ) driver.close();

//  });
});
