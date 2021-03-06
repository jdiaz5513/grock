expect = require('chai').expect
Buffer = require('buffer').Buffer
es = require('event-stream')
gutil = require('gulp-util')

t = require('../../lib/transforms')

describe "Rename Index File", ->
  indexPath = "index.coffee"
  indexFile = null
  fakeIndexFile = null
  fakeFile = null

  beforeEach ->
    fakeFile = new gutil.File
      cwd: "/",
      base: "/test/",
      path: "/test/file.coffee"
      contents: new Buffer("test = 123")

    fakeIndexFile = new gutil.File
      cwd: ".",
      base: "",
      path: indexPath
      contents: new Buffer("test = 123")

    indexFile = t.indexFile(indexPath)

  it "should export a function", ->
    expect(t.indexFile).to.be.a('function')

  it "should rename index file", (done) ->
    indexFile
    .once 'data', (file) ->
      expect(file.isBuffer()).to.be.true
      expect(file.path).to.eql 'index.html'
      done()
    .on 'error', done

    indexFile.write(fakeIndexFile)

  it "should ignore other files", (done) ->
    indexFile
    .once 'data', (file) ->
      expect(file.path).to.not.eql 'index.html'
      done()
    .on 'error', done

    indexFile.write(fakeFile)

  it "should accept a non-string argument to disable", (done) ->
    indexFile = t.indexFile(false)

    indexFile
    .once 'data', (file) ->
      expect(file.path).to.not.eql 'index.html'
      done()
    .on 'error', done

    indexFile.write(fakeIndexFile)
