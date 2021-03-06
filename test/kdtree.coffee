expect = require('chai').expect
should = require('chai').should()
KDtree = require '../coffee/kdtree'

describe "KD-tree", ->
  describe "1D construction", ->
    tree = new KDtree [{a:10}, {a: 2}, {a: 5}]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree

    it "should construct a tree with the median as its root", ->
      expect(tree.getRoot().val[0].a).to.equal 5

    it "should have the lower node as left child", ->
      expect(tree.getRoot().left.val[0].a).to.equal 2

    it "should have the higher node as right child", ->
      expect(tree.getRoot().right.val[0].a).to.equal 10

  describe "2D construction", ->
    # Example from http://en.wikipedia.org/wiki/K-d_tree
    tree = new KDtree [{x:2, y:3}, {x:5,y:4}, {x:9,y:6}, {x:4,y:7}, {x:8,y:1}, {x:7,y:2}], attributes: ["x", "y"]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree
      #console.log require('util').inspect tree.getRoot(), colors: true, depth: 5

    it "should have the root at x = 7", ->
      expect(tree.getRoot().val[0]).to.deep.equal {x:7, y:2}

    it "should have the correct first left child", ->
      expect(tree.getRoot().left.val[0]).to.deep.equal {x:5, y:4}

    it "should have the correct right left child", ->
      expect(tree.getRoot().right.val[0]).to.deep.equal {x:9, y:6}

    it "should build the complete correct tree", ->
      expect(tree.getRoot().left.left.val[0]).to.deep.equal {x:2, y:3}
      expect(tree.getRoot().left.right.val[0]).to.deep.equal {x:4, y:7}
      expect(tree.getRoot().right.left.val[0]).to.deep.equal {x:8, y:1}
      expect(tree.getRoot().right.right).to.equal null

  describe "3D construction with labels", ->
    tree = new KDtree [{x:1,y:2,z:3, label:'a'}, {x:5.1,y:2,z:7, label:'b'}, {x:3,y:3,z:4, label:'c'}, {x:5,y:5,z:5, label:'d'}, {x:9,y:0,z:1, label:'e'}, {x:10,y:1,z:3, label:'f'}, {x:5.2,y:3,z:7, label:'g'}, {x:3,y:9,z:9, label:'h'}, {x:8,y:8,z:8, label:'i'}], attributes: ["x", "y", "z"]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree
      # console.log require('util').inspect tree.getRoot(), colors: true, depth: 5

    it "should have the root at x = 5", ->
      expect(tree.getRoot().val[0]).to.deep.equal {label: 'b', x:5.1, y:2, z:7}

    it "should have the correct first left child", ->
      expect(tree.getRoot().left.val[0]).to.deep.equal {label: 'd', x:5, y:5, z:5}

    it "should have the correct right left child", ->
      expect(tree.getRoot().right.val[0]).to.deep.equal {label: 'g', x:5.2, y:3, z:7}

    it "should have the complete correct tree", ->
      expect(tree.getRoot().left.left.val[0]).to.deep.equal {label: 'c', x:3, y:3, z:4}
      expect(tree.getRoot().left.right.val[0]).to.deep.equal {label: 'h', x:3, y:9, z:9}
      expect(tree.getRoot().right.left.val[0]).to.deep.equal {label: 'f', x:10, y:1, z:3}
      expect(tree.getRoot().right.right.val[0]).to.deep.equal {label: 'i', x:8, y:8, z:8}
      expect(tree.getRoot().right.left.left.val[0]).to.deep.equal {label: 'e', x:9, y:0, z:1}
      expect(tree.getRoot().left.left.left.val[0]).to.deep.equal {label: 'a', x:1, y:2, z:3}

  describe "arguments", ->
    it "should have at least 1 argument", ->
      (-> new KDtree ).should.throw 'Need at least 1 argument'

    it "for the constructor should expect array of objects as first argument", ->
      (-> new KDtree {a:1, b:2, c:3}).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree "bla").should.throw "Expecting an array of objects as first argument"
      (-> new KDtree null).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree undefined).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [2,3,4]).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [{a:2},{b:3},4]).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [[2],[3],[4]]).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [null,undefined,[4]]).should.throw "Expecting an array of objects as first argument"

    it "should expect the second argument to be an array of strings", ->
      (-> new KDtree [{a:1}], attributes: "bla").should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: {a: 2}).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: 2).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: [2]).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: [null]).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: [{a:2}]).should.throw "Expecting an array of strings for attributes"

    it "should expect all objects to have (at least) the same keys as the first object", ->
      (-> new KDtree [{a:1},{a:2},{b:3}]).should.throw "Expecting all objects to have at least the same keys as first object or second parameter"

    it "should expect all objects to have (at least) the keys that are specified in second argument", ->
      (-> new KDtree [{a:1, b:2},{a:2, b:5},{b:3}], attributes: ['a']).should.throw "Expecting all objects to have at least the same keys as first object or second parameter"

  describe.skip "stack overflow", ->
    testCase = require './test-cases/simple'
    objects = testCase.objects
    profile1 = testCase.subject1
    profile2 = testCase.subject2
    tree = {}

    it "should construct tree while combining duplicate nodes", ->
      # Use test-case while duplicating each point once
      objects = testCase.objects.concat objects
      tree = new KDtree objects, {attributes: ["attr_a", "attr_b"]}
      # console.log require('util').inspect tree.getRoot(), colors: true, depth: 9
      expect(tree).to.be.instanceof KDtree
      expect(tree.getRoot().val).to.be.an.array
      expect(tree.getRoot().val[0].label).to.equal "G"
      expect(tree.getRoot().val[1].label).to.equal "G"
      expect(tree.getRoot().right.val).to.be.an.array

    it "should be able to handle ~50k rows without throwing SO", ->
      # Since we have 12 objects, doubling it up 12 times gives up ~50k rows
      for i in [1..11]
        objects = objects.concat objects

      console.log "Building tree with #{objects.length} number of rows"
      d = Date.now()
      tree = new KDtree objects, {attributes: ["attr_a", "attr_b"]}
      console.log "Finished in #{Date.now() - d}"
      expect(tree).to.be.instanceof KDtree

    it "should be able to handle ~100k rows without throwing SO", ->
      objects = objects.concat objects
      console.log "Building tree with #{objects.length} number of rows"
      d = Date.now()
      tree = new KDtree objects, {attributes: ["attr_a", "attr_b"]}
      console.log "Finished in #{Date.now() - d}"
      expect(tree).to.be.instanceof KDtree

    it "should support super fast queries for k = 10", ->
      expect(tree.query(profile1, k: 10)).to.have.length 10
      expect(tree.query(profile2, k: 10)).to.have.length 10
    it "should support super fast queries for k = 100", ->
      expect(tree.query(profile1, k: 100)).to.have.length 100
      expect(tree.query(profile2, k: 100)).to.have.length 100
    it "should support super fast queries for k = 1000", ->
      expect(tree.query(profile1, k: 1000)).to.have.length 1000
      expect(tree.query(profile2, k: 1000)).to.have.length 1000

    it "should be able to handle ~200k rows without throwing SO", ->
      objects = objects.concat objects
      console.log "Building tree with #{objects.length} number of rows"
      d = Date.now()
      tree = new KDtree objects, {attributes: ["attr_a", "attr_b"]}
      console.log "Finished in #{Date.now() - d}"
      expect(tree).to.be.instanceof KDtree
