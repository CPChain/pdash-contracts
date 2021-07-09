const Product = artifacts.require("Product");
const truffleAssert = require("truffle-assertions");

contract("Product", (accounts) => {
  it("Create PaymentWays", async () => {
    const instance = await Product.deployed();
    // add Coin
    await instance.addERC20(accounts[1])
    // add Product
    await instance.createProduct('p1', '{"description": ""}', 1, "file_uri", "file_hash")

    // add payment way
    let tx = await instance.addPaymentWay(1, 1, 188)
    truffleAssert.eventEmitted(tx, 'AddPayment', (e) => {
      assert.equal(e.id, 1)
      assert.equal(e.coinID, 1)
      assert.equal(e.productID, 1)
      assert.equal(e.price, 188)
      return true
    })
    assert.equal(await instance.getPaymentWayPrice(1, 1), 188)
  })
  it("Add again", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.addPaymentWay(1, 1, 188)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This payment way exists!'))
    }
    try {
      await instance.addPaymentWay(2, 1, 188)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This token not exists'))
    }
    try {
      await instance.addPaymentWay(1, 2, 188)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This product not exists'))
    }
  })
  it("Set price", async ()=> {
    const instance = await Product.deployed();
    let tx = await instance.setPaymentWayPrice(1, 1, 199)
    truffleAssert.eventEmitted(tx, 'SetPaymentWayPrice', (e) => {
      assert.equal(e.coinID, 1)
      assert.equal(e.productID, 1)
      assert.equal(e.price, 199)
      return true
    })
  })
  it("Remove", async () => {
    const instance = await Product.deployed();
    let tx = await instance.removePaymentWay(1, 1)
    truffleAssert.eventEmitted(tx, 'RemovePaymentWay', (e) => {
      assert.equal(e.coinID, 1)
      assert.equal(e.productID, 1)
      return true
    })
    assert.equal(await instance.getPaymentWayPrice(1, 1), 0)
  })
  it("Remove again", async () => {
    const instance = await Product.deployed();
    try {
      await instance.removePaymentWay(1, 1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('Payment way not exists'))
    }
    try {
      await instance.removePaymentWay(2, 1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This token not exists'))
    }
    try {
      await instance.removePaymentWay(1, 2)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This product not exists'))
    }
  })
})
