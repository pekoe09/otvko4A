import ohtu.*
import ohtu.services.*
import ohtu.data_access.*
import ohtu.domain.*
import ohtu.io.*
import org.openqa.selenium.*
import org.openqa.selenium.firefox.FirefoxDriver

description """A new user account can be created 
              if a proper unused username 
              and a proper password are given"""

scenario "creation succesfull with correct username and password", {
    given 'command new user is selected', {
        driver = new FirefoxDriver()
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("register new user"))
        element.click()
    }
 
    when 'a valid username and password are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko1");
        element = driver.findElement(By.name("password"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("passwordConfirmation"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("add"));
        element.submit();
    }

    then 'new user is registered to system', {
        driver.getPageSource().contains("info for newbie").shouldBe true

        element = driver.findElement(By.linkText("continue to application mainpage"));
        element.click();
        
        System.out.println("==");
        System.out.println(driver.getPageSource());
        element = driver.findElement(By.linkText("logout"));
        element.click();
    }
}

scenario "can login with succesfully generated account", {
    given 'command new user is selected', {
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("register new user"))
        element.click()
    }
 
    when 'a valid username and password are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko2");
        element = driver.findElement(By.name("password"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("passwordConfirmation"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("add"));
        element.submit();

        element = driver.findElement(By.linkText("continue to application mainpage"));
        element.click();
        element = driver.findElement(By.linkText("logout"));
        element.click();

        element = driver.findElement(By.linkText("login"));
        element.click();
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko2");
        element = driver.findElement(By.name("password"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("login"));
        element.submit();
    }

    then  'new credentials allow logging in to system', {
        driver.getPageSource().contains("Welcome to Ohtu Application!").shouldBe true
        element = driver.findElement(By.linkText("logout"));
        element.click();
    }
}

scenario "creation fails with correct username and too short password", {
    given 'command new user is selected', {
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("register new user"))
        element.click()  
    }
    when 'a valid username and too short password are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko3");
        element = driver.findElement(By.name("password"));
        element.sendKeys("as_5");
        element = driver.findElement(By.name("passwordConfirmation"));
        element.sendKeys("as_5");
        element = driver.findElement(By.name("add"));
        element.submit();
    }
    then 'new user is not be registered to system', {
        driver.getPageSource().contains("length greater or equal to 8").shouldBe true
    }
}

scenario "creation fails with correct username and pasword consisting of letters", {
    given 'command new user is selected', {
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("register new user"))
        element.click()         
    }
    when 'a valid username and password consisting of letters are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko3");
        element = driver.findElement(By.name("password"));
        element.sendKeys("abcdefghi");
        element = driver.findElement(By.name("passwordConfirmation"));
        element.sendKeys("abcdefghi");
        element = driver.findElement(By.name("add"));
        element.submit();
    }
    then 'new user is not be registered to system', {
        driver.getPageSource().contains("must contain one character that is not a letter").shouldBe true
    }
}

scenario "creation fails with too short username and valid pasword", {
    given 'command new user is selected', {
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("register new user"))
        element.click() 
    }
    when 'a too sort username and valid password are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("v");
        element = driver.findElement(By.name("password"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("passwordConfirmation"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("add"));
        element.submit();
    }
    then 'new user is not be registered to system', {
        driver.getPageSource().contains("length 5-10").shouldBe true
    }
}

scenario "creation fails with already taken username and valid pasword", {
    given 'command new user is selected', {
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("register new user"))
        element.click() 
    }
    when 'a already taken username and valid password are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko1");
        element = driver.findElement(By.name("password"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("passwordConfirmation"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("add"));
        element.submit();
    }
    then 'new user is not be registered to system', {
        driver.getPageSource().contains("username or password invalid").shouldBe true
    }
}

scenario "can not login with account that is not succesfully created", {
    given 'command new user is selected', {
        driver.get("http://localhost:8090")
        element = driver.findElement(By.linkText("login"))
        element.click() 
    }
    when 'a invalid username/password are entered', {
        element = driver.findElement(By.name("username"));
        element.sendKeys("veikko3");
        element = driver.findElement(By.name("password"));
        element.sendKeys("asdf_5jlkA");
        element = driver.findElement(By.name("login"));
        element.submit();
    }
    then  'new credentials do not allow logging in to system', {
        driver.getPageSource().contains("wrong username or password").shouldBe true
    }
}