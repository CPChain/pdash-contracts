const Product = artifacts.require("Product");
const truffleAssert = require("truffle-assertions");

contract("Product", (accounts) => {
  it("Create Product", async () => {
    const instance = await Product.deployed();
  })
})
