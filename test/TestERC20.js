const Product = artifacts.require("Product");
const truffleAssert = require("truffle-assertions");

contract("Product", (accounts) => {
  it("Add ERC20", async () => {
    const instance = await Product.deployed();
    let tx = await instance.addERC20(accounts[1])
    truffleAssert.eventEmitted(tx, 'AddNewERC20', (e) => {
      assert.equal(e.id, 1)
      assert.equal(e.erc20, accounts[1])
      return true
    })
    let got = await instance.getERC20(1)
    assert.equal(got, accounts[1], "ERC20 Address is error")
  })
  it("Add again", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.addERC20(accounts[1])
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This ERC-20 already exists!"))
    }
  })
  it("Remove ERC20", async ()=> {
    const instance = await Product.deployed();
    let tx = await instance.removeERC20(1)
    truffleAssert.eventEmitted(tx, 'RemoveERC20', (e) => {
      assert.equal(e.id, 1)
      assert.equal(e.erc20, accounts[1])
      return true
    })
    let got = await instance.getERC20(1)
    assert.equal(got, 0x0)
  })
  it("Add more than 1 ERC20", async ()=> {
    const instance = await Product.deployed();
    for(let i = 1; i < 5; i++) {
      let tx = await instance.addERC20(accounts[i])
      const expect_id = 1 + i
      truffleAssert.eventEmitted(tx, 'AddNewERC20', (e) => {
        assert.equal(e.id, expect_id)
        assert.equal(e.erc20, accounts[i])
        return true
      })
      let got = await instance.getERC20(expect_id)
      assert.equal(got, accounts[i], "ERC20 Address is error")
    }
  })
  it("Disable ERC20", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.disableERC20(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This coin not exists"))
    }
    let disabled = await instance.isERC20Disabled(2)
    assert.equal(disabled, false)
    let tx = await instance.disableERC20(2);
    truffleAssert.eventEmitted(tx, 'DisableERC20', (e) => {
      assert.equal(e.id, 2)
      assert.equal(e.erc20, accounts[1])
      return true
    })
    disabled = await instance.isERC20Disabled(2)
    assert.equal(disabled, true)
  })
  it("Enable ERC20", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.enableERC20(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This coin not exists"))
    }
    try {
      await instance.enableERC20(3)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This coin haven't been disabled"))
    }
    let disabled = await instance.isERC20Disabled(2)
    assert.equal(disabled, true)
    let tx = await instance.enableERC20(2);
    truffleAssert.eventEmitted(tx, 'EnableERC20', (e) => {
      assert.equal(e.id, 2)
      assert.equal(e.erc20, accounts[1])
      return true
    })
    disabled = await instance.isERC20Disabled(2)
    assert.equal(disabled, false)
  })
  it("Only Owner", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.enableERC20(1, {from: accounts[1]})
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("Ownable: caller is not the owner"))
    }
    try {
      await instance.disableERC20(1, {from: accounts[1]})
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("Ownable: caller is not the owner"))
    }
    try {
      await instance.addERC20(accounts[1], {from: accounts[1]})
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("Ownable: caller is not the owner"))
    }
    try {
      await instance.removeERC20(1, {from: accounts[1]})
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("Ownable: caller is not the owner"))
    }
  })
  it("Only Enable", async ()=> {
    const instance = await Product.deployed();
    await instance.disableContract()
    try {
      await instance.enableERC20(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("The contract is disabled"))
    }
    try {
      await instance.disableERC20(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("The contract is disabled"))
    }
    try {
      await instance.addERC20(accounts[1])
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("The contract is disabled"))
    }
    try {
      await instance.removeERC20(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("The contract is disabled"))
    }
  })
})
