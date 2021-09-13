const Product = artifacts.require("Product");
const truffleAssert = require("truffle-assertions");

contract("Product", (accounts) => {
  it("Create Product", async () => {
    const instance = await Product.deployed();
    let tx = await instance.createProduct('p1', '{"description": ""}', 1, "file_uri", "file_hash")
    truffleAssert.eventEmitted(tx, 'CreateProduct', (e) => {
      assert.equal(e.id, 1)
      assert.equal(e.name, 'p1')
      assert.equal(e.extend, '{"description": ""}')
      assert.equal(e.price, 1)
      assert.equal(e.creator, accounts[0])
      return true
    })
    assert.equal(await instance.countOfProducts(), 1, "The count should be 1")
    assert.equal(await instance.getNameOfProduct(1), 'p1')
    assert.equal(await instance.getExtendOfProduct(1), '{"description": ""}')
    assert.equal(await instance.getPriceOfProduct(1), 1)
    let r = await instance.getProduct(1)
    let name = r['0']
    let extend = r['1']
    let price = r['2']
    assert.equal(name, 'p1')
    assert.equal(extend, '{"description": ""}')
    assert.equal(price, 1)
    assert.equal(await instance.isFileExists('file_uri', 'file_hash'), true, "The file should exists")
    assert.equal(await instance.isFileExists('file_uri', 'file_has1'), false, "The file should not exists")
    assert.equal(await instance.isFileExists('file_uri1', 'file_hash'), false, "The file should not exists")
  })
  it("Create again", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.createProduct('p1', '{"description": ""}', 1, "file_uri", "file_hash")
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This name already exists!"))
    }
  })
  it("Edit product", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.editProduct(2, 'p1', '{"description": ""}', 1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This product not exists!"))
    }
    // 不改变 name，改变描述，需能成功
    await instance.editProduct(1, 'p2', '{"description": "p2-1"}', 10)
    
    let tx = await instance.editProduct(1, 'p2', '{"description": "p2"}', 10)
    truffleAssert.eventEmitted(tx, 'EditProduct', (e) => {
      assert.equal(e.id, 1)
      assert.equal(e.name, 'p2')
      assert.equal(e.extend, '{"description": "p2"}')
      assert.equal(e.price, 10)
      assert.equal(e.creator, accounts[0])
      return true
    })
    assert.equal(await instance.countOfProducts(), 1, "The count should be 1")
    assert.equal(await instance.getNameOfProduct(1), 'p2')
    assert.equal(await instance.getExtendOfProduct(1), '{"description": "p2"}')
    assert.equal(await instance.getPriceOfProduct(1), 10)
  })
  it("Remove Product", async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.removeProduct(2)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This product not exists!"))
    }
    let tx = await instance.removeProduct(1)
    truffleAssert.eventEmitted(tx, 'RemoveProduct', (e) => {
      assert.equal(e.id, 1)
      return true
    })
    assert.equal(await instance.countOfProducts(), 0, "The count should be 1")
  })
  it('Disable by admin', async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.disableProduct(2)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This product not exists!"))
    }

    await instance.createProduct('p1', '{"description": ""}', 1, "file_uri-aaa", "file_hash")
    try {
      await instance.enableProduct(2)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This product haven't been disabled"))
    }

    try {
      await instance.disableProduct(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This product have been removed'))
    }

    assert.equal(await instance.isProductDisabled(2), false)

    let tx = await instance.disableProduct(2)
    truffleAssert.eventEmitted(tx, 'AdminDisableProduct', (e) => {
      assert.equal(e.id, 2)
      return true
    })

    assert.equal(await instance.isProductDisabled(2), true)

    try {
      await instance.disableProduct(2)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This product have been disabled'))
    }

  })
  it('Enable by admin', async ()=> {
    const instance = await Product.deployed();
    try {
      await instance.enableProduct(1)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes('This product have been removed'))
    }
    try {
      await instance.enableProduct(3)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This product not exists!"))
    }
    assert.equal(await instance.isProductDisabled(2), true)
    let tx = await instance.enableProduct(2)
    truffleAssert.eventEmitted(tx, 'AdminEnableProduct', (e) => {
      assert.equal(e.id, 2)
      return true
    })
    assert.equal(await instance.isProductDisabled(2), false)
  })
  it("Create 5 products", async ()=> {
    const instance = await Product.deployed();
    for(let i = 0; i < 5; i++) {
      let name = 't' + i
      let id = 3 + i
      let price = 1 + i
      let desc = `'{"description": "${i}"}'`
      let tx = await instance.createProduct(name, desc, price, `file_uri-${name}`, "file_hash")
      truffleAssert.eventEmitted(tx, 'CreateProduct', (e) => {
        assert.equal(e.id, id)
        assert.equal(e.name, name)
        assert.equal(e.extend, desc)
        assert.equal(e.price, price)
        assert.equal(e.creator, accounts[0])
        return true
      })
    }
    assert.equal(await instance.countOfProducts(), 6, "The count should be 1")
    try {
      await instance.editProduct(2, 't1', '{"description": "p2"}', 10)
      assert.fail()
    } catch(error) {
      assert.ok(error.toString().includes("This name already exists!"))
    }
  })
})
